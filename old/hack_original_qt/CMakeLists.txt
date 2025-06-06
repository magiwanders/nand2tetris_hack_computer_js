cmake_minimum_required(VERSION 3.5)

project(hack_computer_original_qt VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Widgets LinguistTools REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets LinguistTools REQUIRED)

set(TS_FILES hack_computer_original_qt_en_GB.ts)

set(PROJECT_SOURCES
        main.cpp
        hackcomputerqt.cpp
        hackcomputerqt.h
        hackcomputerqt.ui
        ticker.h
        ticker.cpp
        drawer.h
        drawer.cpp
        utility/default.h
        utility/default.cpp
        cpu/cpu.h
        cpu/cpu.cpp
        cpu/pc.h
        cpu/pc.cpp
        cpu/pccontroller.h
        cpu/pccontroller.cpp
        cpu/alu.h
        cpu/alu.cpp
        utility/instruction.h
        utility/instruction.cpp
        ram.h
        ram.cpp
        rom.h
        rom.cpp
        hackcomputer.h
        hackcomputer.cpp
        test.h
        test.cpp
        ${TS_FILES}
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(hack_computer_original_qt
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET hack_computer_original_qt APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation

    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
else()
    if(ANDROID)
        add_library(hack_computer_original_qt SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(hack_computer_original_qt
            ${PROJECT_SOURCES}
        )
    endif()

    qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
endif()

target_link_libraries(hack_computer_original_qt PRIVATE Qt${QT_VERSION_MAJOR}::Widgets)

set_target_properties(hack_computer_original_qt PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(hack_computer_original_qt)
endif()
