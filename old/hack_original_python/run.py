import sys, json, time, tqdm
from multiprocessing import Pool
from functools import partial
# import builtins as __builtin__

# TODO REMEMBER THIS SUPPORTS ONLY UP TO 128 bits (see extract_column_vals), parallelize tests, Add support for comments test for all the parts.
# NOTE LITTLE ENDIAN INDEXING: instr=00101 -> instr[0]=1 (rightmost) and instr[4]=0 (leftmost)

# Parts for which a 'fast' implementation is provided.
builtin_chips = [
    'Nand',
    # 'Not',
    # 'And',
    # 'Or',
]

# region CLASSES | Containers for script-wide variables. 

class Unique: # Makes all the recursively parsed input pairings unique. It gets incremented for every recursion.
    def __init__(self):
        self.unique = 0
u = Unique()

class Chip: # Contains the most important parsed information about chips
    def __init__(self):
        self.chip_name = '' 
        self.file_content = ''
        self.inputs = {}
        self.internals = {}
        self.outputs = {}
        self.parts = {}
    
    def print(self):
        print('-----------------------------------------------------')
        print('CHIP: ' + self.chip_name)
        print('IN: ' + json.dumps(self.inputs, indent=4))
        print('INTERNAL: ' + json.dumps(self.internals, indent=4))
        print('OUT: ' + json.dumps(self.outputs, indent=4))
        print('PARTS: ' + json.dumps(self.parts, indent=4))
        print('-----------------------------------------------------')

# endregion

# region FILE I/O | Read and write the .hdl file on disk.

def read(chip_name): # Reads the chip .hdl file as a single string
    assert chip_name.find('.hdl') == len(chip_name)-4, "File to be tested must have .hdl extension"
    chip_name = chip_name.replace('\t', '').replace(' ', '')
    chip = open(chip_name, 'r').read()
    assert chip_name[:-4] == extract_name(chip) , "Name of chip '" +chip_name[:-4]+ "' is not the same as name of the file '"+extract_name(chip) +"'"
    return chip

def generate_test_result_headline(outs): # Generates the test results headline.
    test_results_headline = '|| Passed | '
    for out in outs:
        test_results_headline = test_results_headline + out + ' | '
    return test_results_headline

def generate_test_result_line(outs, test_result): # Generates the test result line after Y or N 'passed' value. Only shows unexpected obtained results under the corresponding column.
    line = ' ' if test_result[1][outs[0]]==True else '|'
    for i, out in enumerate(outs):
        if test_result[1][out]==True:
            line += ' ' * int(len(out)+3)
        else:
            line = line[:-1]
            line += '| ' + (' ' * int(len(out)-int(len(out)/2)-1) ) + str(test_result[1][out][1]) + ( ' ' * int(len(out)/2) ) + ' |'
    return line

def inject(test_results, file_content): # Inject the results into the file content.
    file_content_lines = file_content.split('\n')
    while [] in file_content_lines: # Process the file contents as array of lines.
        file_content_lines.remove([])
    outs = list(parse_io('OUT', file_content).keys())
    for i, line in enumerate(file_content_lines):
        index_of_separator = line.find('||')
        if index_of_separator != -1: # Stops parsing when it finds the first separator '||', that is the test variable header.
            file_content_lines[i] = line[:index_of_separator] + generate_test_result_headline(outs) # Complete the header.
            j = 0
            k = 0
            while j<len(test_results): # For each test add the correct line.
                test_result = test_results[j]
                if file_content_lines[i+j+1+k]=='': # Skip empty lines
                    k+=1
                index_of_separator = file_content_lines[i+j+1+k].find('||')
                file_content_lines[i+j+1+k] = file_content_lines[i+j+1+k][:index_of_separator] + ( ('||   Y    ' if test_result[0]==True else '||   N    ') + generate_test_result_line(outs, test_result) )
                j+=1
            break
    file_content = ''
    for line in file_content_lines: # Recompact the file content lines into one single String.
        file_content += line + '\n'
    return file_content[:-1]

# endregion

# region EXTRACTORS | Extract specific items from the .hdl file content. 

def extract_name(file_content): # Extracts the name of the chip (the one after CHIP keyword)
    index_of_CHIP = file_content.find('CHIP')+4
    index_of_open_bracket = file_content.find('{')
    name = file_content[index_of_CHIP:index_of_open_bracket].strip()
    assert name != '', 'Chip name not defined.'
    return name

def extract_io(io, chip): # Extracts the io (either IN or OUT) as array of strings.
    index_of_io = chip.find(io) + len(io)
    index_of_newline = index_of_io + chip[index_of_io:].find(';')
    io_string = chip[index_of_io:index_of_newline].strip().replace(' ', '').replace('\n', '')
    # assert io_string[-1] == ';', 'Expected ;'
    assert io_string != '', 'There are no defined ' + io
    io_array = io_string.split(',')
    i=0
    while True:
        if i==len(io_array):
            break
        if io_array[i][0]=='#':
            io_array.remove(io_array[i])
        else:
            i+=1
    return io_array

def extract_test_strings_array(file_content): # Extracts the lines in the file_content corresponding to the TESTs
    index_of_TEST = file_content.find('TEST')+4
    index_of_close_bracket = index_of_TEST + file_content[index_of_TEST:].find('}')
    tests_array = file_content[index_of_TEST:index_of_close_bracket].replace(' ', '').replace('{', '').strip().split('\n')
    while '' in tests_array:
        tests_array.remove('')
    return tests_array

def bin2scomp(dec, nbits):
    binary = bin(((1 << nbits) - 1) & int(dec))[2:]
    sign = '0' if dec>=0 else '1'
    for i in range(nbits-len(binary)):
        binary = sign + binary
    return binary

def extract_column_vals(file_content, i): # Extracts the dictionary of test values of the ith test row (0th row is the test variables names)
    column_names_line = extract_test_strings_array(file_content)[i]
    index_of_separator = column_names_line.find('||')
    vals = column_names_line[1:index_of_separator].split('|')
    if len(sys.argv) > 3 and sys.argv[3] == 'd' and i!=0:
        column_names = extract_column_vals(file_content, 0)
        for i, val in enumerate(vals):
            if vals[i]!='*':
                vals[i] = bin2scomp(int(vals[i]), 16) if column_names[i]!='instruction' else vals[i]
    return vals

def extract_column_names(file_content): # Extracts the array of test variables names (values of the 0th row of tests)
    return extract_column_vals(file_content, 0)

def extract_n_tests(file_content): # Extracts the number of tests. Minus 1 because the test variables names row is clearly not a test.
    return len(extract_test_strings_array(file_content)) - 1

def extract_column_named(variable, file_content): # Extracts the array of test values in column <name>
    index_open_bracket, index_close_bracket, name, index_colon, first_value, second_value = extract_unfold_info(variable)
    assert name in extract_column_names(file_content), 'No "' + name + '" column among TEST variables columns ' + str(extract_column_names(file_content))
    index_of_name = extract_column_names(file_content).index(name)
    values = []
    for i in range( extract_n_tests(file_content) ):
        value = extract_column_vals(file_content, i+1)[index_of_name]
        if index_open_bracket!=-1:
            value = value[-int(first_value)-1]
        values.append( value if value=='*' else int(value) )
    return values

def extract_parts_string_array(chip): # Extracts parts strings as an array. Ignores lines with # as first character.
    index_of_parts = chip.find('PARTS:')+6
    index_of_chip_end = index_of_parts + chip[index_of_parts:].find('}')
    parts = chip[index_of_parts:index_of_chip_end].replace(' ', '').strip()
    assert parts != '', 'There are no parts!'
    parts_array = parts.split('\n')
    while '' in parts_array:
        parts_array.remove('')
    i=0
    while True:
        if i==len(parts_array):
            break
        if parts_array[i][0]=='#':
            parts_array.remove(parts_array[i])
        else:
            i+=1
    return parts_array

def recompose_part(name, ins, pairings):
    pairs = ''
    for i, pairing in enumerate(pairings):
        pairs += ins[i] + '=' + pairing + ','
    return name + '(' + pairs[:-1] + ');'

def replace_uniquize(parts_array, substitute='', replacement=''): # For each subpart, replace all variables in the substitute array into the ones in the replacement array. Uniquize all other variables.
    assert len(substitute) == len(replacement), '[INTERNAL] Substitutes (' + str(len(substitute)) + ') must be just as many as replacements (' + str(len(replacement)) + ')' + '\n' + str(substitute) + '\n' + str(replacement) 
    if substitute != '' and replacement !='':
        for i, part in enumerate(parts_array):
            part_name = extract_part_name(part)
            ins, pairings = extract_io_pairs(part)
            for j, pairing in enumerate(pairings):
                pairings[j] = ( str(u.unique) + pairing ) if pairing.find('false')==-1 and pairing.find('true')==-1 else pairing
            # parts_array[i] = parts_array[i].replace('=', '='+str(u.unique)) # Make all variables unique.
            for j in range(len(substitute)):
                for k, pairing in enumerate(pairings):
                    if pairing == (str(u.unique) + substitute[j]):
                        pairings[k] = replacement[j] 
            parts_array[i] = recompose_part(part_name, ins, pairings)
                # parts_array[i] = parts_array[i].replace(str(u.unique)+str(substitute[j]), str(replacement[j])) # Substitute with the replacements.
    return parts_array

def extract_part_name(part): # Extracts the name of the part from the part string.
    index_of_bracket = part.find('(')
    name = part[0:index_of_bracket]
    return name

def extract_io_pairs(part): # Extract an array of left and right sides of the part pairings from the part string.
    ins = []
    ins_pairs = []
    part = part.replace(' ', '')
    index_of_open_bracket = part.find('(')+1
    index_of_close_bracket = part.find(')')
    pairings_array = part[index_of_open_bracket:index_of_close_bracket].split(',')
    for i, pairing in enumerate(pairings_array):
        index_of_equals = pairing.find('=')
        left_pair = pairing[0:index_of_equals]
        comp = left_pair.find(':')
        if comp!=-1:
            left_pair = unfold(left_pair)
        ins.extend( [left_pair] if comp==-1 else left_pair)
        right_pair = pairing[index_of_equals+1:]
        comp = right_pair.find(':')
        if comp!=-1:
            right_pair = unfold(right_pair)
        ins_pairs.extend( [right_pair] if comp==-1 else right_pair)
    return ins, ins_pairs

def extract_unfold_info(variable):
    index_open_bracket = variable.find('[')
    index_close_bracket = variable.find(']')
    name = variable[0:index_open_bracket] if index_open_bracket!=-1 else variable
    index_colon = variable.find(':')
    first_value = variable[index_open_bracket+1:index_close_bracket] if index_colon==-1 else str(int(variable[index_open_bracket+1:index_colon])+1)
    second_value = '0' if index_colon==-1 else variable[index_colon+1:index_close_bracket]
    return index_open_bracket, index_close_bracket, name, index_colon, first_value, second_value

# endregion

# region PARSE | Parse the relevant .hdl file content into an easily code-readable dictionary.

def unfold(variable): # Transforms declarations (es. in[3] -> [in[0], in[1], in[2]]) or ranges (es. a[4:7] -> [a[4], a[5], a[6], a[7]])
    if variable.find('[')==-1:
        return [variable]
    index_open_bracket, index_close_bracket, name, index_colon, first_value, second_value = extract_unfold_info(variable)
    if index_close_bracket==-1 or index_open_bracket==-1: # Let single bit variables pass through
        return [variable]
    # print(first_value>=second_value, first_value-second_value)
    # assert first_value>=second_value, 'Invalid indexing.'
    unfolded_array = []
    for i in range(int(second_value), int(first_value)):
        unfolded_array.insert(0, name+'['+str(i)+']')
    return unfolded_array

def unfold_io(io_array): # Substitutes all composite variables into bits. Ex. foo[3] -> foo[0], foo[1], foo[2]
    unfolded_io_array = []
    for io_var in io_array: # For each io variable...
        unfolded_io_array.extend(unfold(io_var))
    return unfolded_io_array

def set_io_test_values(unfolded_array, file_content): # Matches each IO variable in unfolded_array with the corresponding test (for IN) or compare (for OUT) values into a dictionary.
    initialized_dictionary = {}
    for io_variable in unfolded_array:
        initialized_dictionary[io_variable] = extract_column_named(io_variable, file_content) # dict['io_value'] = [<array of test values>]
    return initialized_dictionary

def parse_io(io, file_content): # Extract the dictionary of INs or OUTs as list of in: [array of test values]
    io_array = extract_io(io, file_content) # 1. Extract the array of io as they are written
    unfolded_io_array = unfold_io(io_array) # 2. Decompose multi-bit io into single bits
    return set_io_test_values(unfolded_io_array, file_content) # 3. Populate the io dictionary with the test (for IN) or compare (for OUT) values

def parse_subparts_recursively(parts_array): # Recursively transform all parts in nands (and other builtin chips) with correct linking.
    i=0 
    while (i<len(parts_array)): 
        part_name = extract_part_name(parts_array[i])
        # print(parts_array[i])
        if (part_name not in builtin_chips): # 1. If the part is not among those supported in their "fast" implementation (builtin) it must be recursively nandified.
            u.unique+=1 # 2. Increase the ever increasing uniquizing number for uniquizing the non substituted internal pins of the new subparts
            subpart_chip_file_content = read(part_name + '.hdl') # 3. Read the non-builtin part file
            subparts_array = extract_parts_string_array(subpart_chip_file_content) # 4. Extract the parts of the non-builtin part
            ins, ins_pairs = extract_io_pairs(parts_array[i]) # 5. Extract the pairings of the part being nandified 
            subparts_array = replace_uniquize(subparts_array, ins, ins_pairs) # 6. Substitute the pairings of the nandified parts into its subparts
            del parts_array[i] # 7. Replace non-builtin part with all the subparts   
            for j in range(len(subparts_array)):
                parts_array.insert(i+j, subparts_array[j])
            i-=1 # 8. The part might have been replaced with other non-builtin chips, so repeat the analysis until only builtin chips are found
        i+=1
    return parts_array

def builtin_parse(part_name, pairings): # Part-specific parsing. ADD HERE SUPPORTED CHIPS
    if part_name == 'Nand': # ADD HERE the minimum simulation information for any future supported chip.
        return [part_name, pairings[0].replace("'", ''), pairings[1].replace("'", ''), pairings[2]] # ['Nand', a, b, out]

def parse_parts(file_content): # Return an array of builtin chips pairings for simulation, and an array of all the right sides of the pairings.
    parts_array = extract_parts_string_array(file_content) # 1. Extract parts as array of strings
    parts_array = parse_subparts_recursively(parts_array) # 2. Recursive nandification (transforming parts into nands and other builtin parts). After this loop parts_array contains only builtin chips.
    pairings_array = []
    for i in tqdm.tqdm(range(len(parts_array))): # 3. Parsing the bare minimum for simulating the builtin parts.
        assert parts_array[i][-1]==';', 'Semicolon missing after one of the parts.'
        part_name = extract_part_name(parts_array[i])
        assert part_name in builtin_chips, 'Found ' + part_name + ' among nandified parts, but it is not among the builtin chips.'
        _, pairings = extract_io_pairs(parts_array[i])
        pairings_array.extend(pairings)
        parts_array[i] = builtin_parse(part_name, pairings) # 4. Here it is checked which of the builtin chips' format to use.
    return parts_array, pairings_array

def initialize_internals(c): # Filter the true internal values, if needed initializing their value. Note that at this point c.internals only contains an array of all the right sides of the pairings with no value, not the true internal values.
    internals = {
        'false': 0,
        'false[0]': 0,
        'false[1]': 0,
        'false[2]': 0,
        'false[3]': 0,
        'false[4]': 0,
        'false[5]': 0,
        'false[6]': 0,
        'false[7]': 0,
        'false[8]': 0,
        'false[9]': 0,
        'false[10]': 0,
        'false[11]': 0,
        'false[12]': 0,
        'false[13]': 0,
        'false[14]': 0,
        'false[15]': 0,
        'true': 1,
        'true[0]': 1,
        'true[1]': 1,
        'true[2]': 1,
        'true[3]': 1,
        'true[4]': 1,
        'true[5]': 1,
        'true[6]': 1,
        'true[7]': 1,
        'true[8]': 1,
        'true[9]': 1,
        'true[10]': 1,
        'true[11]': 1,
        'true[12]': 1,
        'true[13]': 1,
        'true[14]': 1,
        'true[15]': 1,
    }
    for internal in c.internals:
        if internal not in list(c.inputs.keys()) and internal not in list(internals.keys()):
            internals[internal.replace("'", '')] = 1 if internal[-1]=="'" else 0   
    return internals

def parse_chip(file_content): # Returns a populated Chip() class of the chip_name hdl file. Oprionally substitutes all internal variables with the paired replacement from the more external chip.
    print('Parsing...')
    start_time = time.time()
    c = Chip()
    c.file_content = file_content # 1. Save the file content
    c.chip_name = extract_name(file_content) # 2. Extract the name
    c.inputs = parse_io('IN', file_content) # 3. Unwrap, extract and initialize the inputs
    c.outputs = parse_io('OUT', file_content) # 4. Unwrap, extract and initialize the outputs
    c.parts, c.internals = parse_parts(file_content) # 5. Parse the relevant information for the parts (for now we only support nand, thus {'Nand', a, b, out}
    c.internals = initialize_internals(c) # 6. Unwrap, extract and initialize internal variables. Remove initialization markers.
    print('Done in', time.time()-start_time, 'seconds |', len(c.parts), 'Nands!')
    return c

# endregion

# region TEST | Simulate the chip and compare results with the expected ones

def builtin_function(part, c, test_number): # ADD HERE other builtin functions here. In the future this might be where python calls fast Rust backend.
    out = {}
    if part[0]=='Nand':
        a = c.inputs[part[1]][test_number] if part[1] in list(c.inputs.keys()) else c.internals[part[1]]
        b = c.inputs[part[2]][test_number] if part[2] in list(c.inputs.keys()) else c.internals[part[2]]
        assert a!=-1, 'Trying to use internal variable ' + part[1] + ' which has not been calculated yet (and was not initialized).'
        assert b!=-1, 'Trying to use internal variable ' + part[2] + ' which has not been calculated yet (and was not initialized).'
        out = 0 if int(a)==1 and int(b)==1 else 1
    return out

def simulate_parts(c, test_number): # HEART OF SIMULATION -> Feed the test values into the parts and simulate their behaviour, then return the results.
    test_results = {}
    for part in c.parts: # Cycles all the parts for each test
        assert part[0] in builtin_chips, 'Recursive part decomposition has not worked correctly. Found ' + part[0] + ' instead of Nand.'
        out = builtin_function(part, c, test_number) # THE HEART OF EVERYTHING -> SIMULATE THE BUILTIN 
        if part[3] in list(c.internals.keys()): # Update the internal variable if builtin function outputs to internal variable
            c.internals[part[3]] = out
        if part[3] in list(c.outputs.keys()): # If instead builtin function outputs to output check if result is the expected one, if not save obtained result.
            test_results[part[3]] = out
    return test_results

def compare_results(c, test_results, test_number): # HEART OF TEST -> Compare the obtained results with the expected ones, then return the comparison.
    passed = True
    compared_test_result = {}
    for i in range(len(test_results)): # Cycles all the results
        if list(test_results.values())[i] == c.outputs[list(test_results.keys())[i]][test_number] or c.outputs[list(test_results.keys())[i]][test_number]=='*':
            compared_test_result[list(test_results.keys())[i]] = True # If the result is the expected one, just write True to the compared results.
        else:
            compared_test_result[list(test_results.keys())[i]] = [False, list(test_results.values())[i]] # If the result is NOT the expected one, write False and the obtained value to the compared results.
            passed = False
    return passed, compared_test_result

def run_test(c): # Run test expecting only builtin parts. Return an array of all tests' compared results.
    print('Testing...')
    start_time = time.time()
    compared_test_results = []
    passed = True
    # p = Pool(4)
    # simulate_part=partial(simulate_parts, c)
    # r = p.map(simulate_part, tqdm.tqdm(range(len(list(c.outputs.values())[0]))))
    # p.close()
    # p.join() NOT WORKING
    for test_number in tqdm.tqdm(range(len(list(c.outputs.values())[0]))): # Cycles all the tests
        test_results = simulate_parts(c, test_number) # 1. Run the simulation with the test values.
        assert test_results!={}, 'Something went wrong in the tests.'
        test_passed, compared_test_result = compare_results(c, test_results, test_number) # 2. Compare the results with the expected ones.
        if not test_passed:
            passed = False
        compared_test_results.append([test_passed, compared_test_result])
    print('Done in', time.time()-start_time, 'seconds |', '\033[92m[✓] Test Passed!\033[00m' if passed else "\033[91m[x] Test Failed...\033[00m" ) # 3. Output the test results. 
    return compared_test_results, passed

# endregion

# region DRIVERS | Make everything work

def test(chip_name): # Drives the test. Extracts the .hdl file content, parses it, simulates the chip, and writes back the result.
    file_content = read(chip_name) # 1. Extract .hdl file as string
    c = parse_chip(file_content) # 2. Parse the chip's relevant information into a code readable class.
    test_results, passed = run_test(c) # 3. Run the test simulation. Return passed bool and the new file content to write with the results added.
    # print(inject(test_results, file_content))
    open(chip_name, 'w').write( inject(test_results, file_content) )  # 4. Write back the file with results injected in.
    return passed

if sys.argv[2] == 'test':
    test(sys.argv[1])

# endregion