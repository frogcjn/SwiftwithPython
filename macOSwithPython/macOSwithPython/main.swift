//
//  main.swift
//  macOSwithPython
//
//  Created by Cao, Jiannan on 2/12/25.
//

import Foundation
import Python

Py_Initialize()
let version = String(cString: Py_GetVersion())
print(version)

// we now have a Python interpreter ready to be used (optional)

import PythonKit
func testPythonKit() {
    //Py_Initialize()
    let sys = Python.import("sys")
    print("Python Version: \(sys.version)")
    print("Python Version: \(sys.version_info.major).\(sys.version_info.minor)")
    print("Python Encoding: \(sys.getdefaultencoding().upper())")
    print("Python Path: \(sys.path)")
    
    _ = Python.import("math") // verifies `lib-dynload` is found and signed successfully
    //Py_Finalize()
}
testPythonKit()

Py_Finalize()
