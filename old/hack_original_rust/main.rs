use std::collections::{HashMap, VecDeque};
use std::sync::mpsc::{self, Sender};
use std::thread;
use std::time::Duration;

enum Component {
    Nand(String),
    In(String),
    Out(String)
}

fn send_command(tx: &Sender<Vec<String>>, cmd: Vec<&str>) {
    tx.send(cmd.iter().cloned().map(|s| String::from(s)).collect()).unwrap();
    std::thread::sleep(Duration::from_millis(1000));
}

fn main() {

    let (tx, rx) = mpsc::channel::<Vec<String>>();

    let parser = thread::spawn(move || {
        send_command(&tx, vec!["add", "in", "in0"]);
        send_command(&tx, vec!["add", "in", "in1"]);
        send_command(&tx, vec!["add", "in", "in2"]);
        send_command(&tx, vec!["add", "out", "out0"]);
        send_command(&tx, vec!["add", "out", "out1"]);
        send_command(&tx, vec!["add", "out", "out2"]);
        send_command(&tx, vec!["add", "out", "out3"]);
        send_command(&tx, vec!["add", "out", "out4"]);
        send_command(&tx, vec!["set", "in0", "true"]);
        send_command(&tx, vec!["set", "in2", "true"]);
        send_command(&tx, vec!["propagate"]);
        send_command(&tx, vec!["connect", "in0", "out0"]);
        send_command(&tx, vec!["connect", "in0", "out4"]);
        send_command(&tx, vec!["connect", "in1", "out3"]);
        send_command(&tx, vec!["connect", "in2", "out2"]);
        send_command(&tx, vec!["propagate"]);
        send_command(&tx, vec!["set", "in0", "false"]);
        send_command(&tx, vec!["set", "in1", "true"]);
        send_command(&tx, vec!["propagate"]);
        send_command(&tx, vec!["add", "nand", "nand0"]);
        send_command(&tx, vec!["connect", "in0", "nand0.a"]);
        send_command(&tx, vec!["connect", "in1", "nand0.b"]);
        send_command(&tx, vec!["connect", "nand0.out", "out1"]);
        send_command(&tx, vec!["exit"]);
    });
    
    let simulator = thread::spawn(move || {
        let mut ins: Vec<String> = Vec::new();
        let mut outs: Vec<String> = Vec::new();
        let mut components: Vec<String> = Vec::new();
        let mut event_cue: VecDeque<(String, u32)> = VecDeque::new();
        let mut subscriptions: HashMap<String, Vec<String>> = HashMap::new();

        fn nand(ins: Vec<bool>) -> bool { if ins[0]&ins[1] {false} else {true} }

        loop {
            std::thread::sleep(Duration::from_millis(100));
            match rx.try_recv() {
                Ok(result) => { 
                    let action = result[0].as_str();
                    match action {
                        "add" => {
                            let component = result[1].as_str();
                            let id = result[2].clone();
                            match component {
                                "in" => { ins.push(id); }
                                "out" => { outs.push(id); }
                                "nand" => { components.push(id); }
                                _ => break
                            }
                        },
                        "connect" => {
                            let out_id = result[1].clone();
                            let in_id = result[2].clone();
                            if let Some(listeners) = subscriptions.get_mut(out_id.as_str()) {
                                listeners.push(in_id);
                            } else {
                                subscriptions.insert(out_id, vec![in_id]);
                            }
                        }
                        "propagate" => {
                            for (i, input) in ins.iter().enumerate() { event_cue.push_back((input.clone(), result[i+1].parse::<u32>().unwrap())); }

                            loop {
                                if let Some(event) = event_cue.pop_front() {
                                    if let Some(listeners) = subscriptions.get(event.as_str()) {
                                        
                                    }
                                    if let Some(in_value) = ins.get(element.as_str()) {
                                        if let Some(listeners) = connections.get(element.as_str()) {
                                            for listener in listeners {
                                                if let Some(out_value) = outs.get_mut(listener.as_str()) {
                                                    *out_value = *in_value;
                                                }
                                            }
                                        }
                                    }
                                } else { break; }
                            }

                            for out in &outs {
                                println!("OUT {:?}", out);
                            }
                        },
                        _ => break
                    }
                    println!(
                        "Command: {:?} \n Global INS: {:?} \n Global OUTS: {:?} \n Connections: {:?} \n Changed {:?}", 
                        result,           ins,                outs,                connections,         changed
                    );
                }, 
                Err(err) => println!("."),
            }
        }
    });
    
    parser.join().unwrap();
    simulator.join().unwrap();
}