//
//  InitPython.swift
//  iOSwithPython3.13
//
//  Created by Cao, Jiannan on 2/12/25.
//

import Python
import Foundation
import PythonKit

func initPythonSimpleVersion() {
    print("init Python")
    
    // let resourcePath = Bundle.main.resourcePath!
    guard let pythonHome = Bundle.main.path(forResource: "python", ofType: nil) else { return }
    guard let pythonPath = Bundle.main.path(forResource: "python/lib/python3.13", ofType: nil) else { return }
    guard let libDynLoad = Bundle.main.path(forResource: "python/lib/python3.13/lib-dynload", ofType: nil) else { return }
    let appPath = Bundle.main.path(forResource: "app", ofType: nil)
    
    setenv("PYTHONHOME", pythonHome, 1)
    
    /*
     The PYTHONPATH for the interpreter includes:
     the python/lib/python3.X subfolder of your app’s bundle,
     the python/lib/python3.X/lib-dynload subfolder of your app’s bundle, and
     the app subfolder of your app’s bundle
     */
    
    setenv("PYTHONPATH", [pythonPath, libDynLoad, appPath].compactMap { $0 }.joined(separator: ":"), 1)
    Py_Initialize()
    
    print("init Success")
}

var version: String? = nil
func testPythonKit() {
    print("test PythonKit")
    
    let sys = Python.import("sys")
    version = "\(sys.version)"
    print("Python Version: \(version ?? "Not Available")")
    print("Python Encoding: \(sys.getdefaultencoding().upper())")
    print("Python Path: \(sys.path)")
    let platform = Python.import("platform")
    print(platform.system())
}

func initPythonWithConfigVersion() {
    
    /*
    var preConfig = PyPreConfig()
    var config = PyConfig()
    var config2 = PyConfig()
    PyPreConfig_InitIsolatedConfig(&preConfig)
    PyConfig_InitIsolatedConfig(&config)
    PyConfig_InitIsolatedConfig(&config2)

    let resourcePath = Bundle.main.resourcePath!
    preConfig.utf8_mode = 1
    config.buffered_stdio = 0
    config.write_bytecode = 0
    config.install_signal_handlers = 1
    // config.use_system_logger = 1
    
    print("Pre-initializing Python runtime...")
    var status = Py_PreInitialize(&preConfig)
    if PyStatus_Exception(status) != 0 {
        print("Unable to pre-initialize Python interpreter: \(String(cString: status.err_msg))")
        PyConfig_Clear(&config)
        Py_ExitStatusException(status)
    }
    
    
    let python_home = (resourcePath as NSString).appendingPathComponent("python")
    let wtmp_str = Py_DecodeLocale(python_home.cString(using: .utf8), nil)
    //status = PyConfig_SetString(&config, &config.home, wtmp_str)
    status = PyConfig_SetString(nil, &config.home, wtmp_str)

    if (PyStatus_Exception(status) != 0) {
        print("Unable to set PYTHONHOME: \(String(cString:status.err_msg))")
        PyConfig_Clear(&config);
        Py_ExitStatusException(status);
    }
    PyMem_RawFree(wtmp_str)
    /*
    // Determine the app module name
    app_module_name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MainModule"];
    if (app_module_name == NULL) {
        NSLog(@"Unable to identify app module name.");
    }
    app_module_str = [app_module_name UTF8String];
    status = PyConfig_SetBytesString(&config, &config.run_module, app_module_str);
    if (PyStatus_Exception(status)) {
        crash_dialog([NSString stringWithFormat:@"Unable to set app module name: %s", status.err_msg, nil]);
        PyConfig_Clear(&config);
        Py_ExitStatusException(status);
    }
     */
    
    /*
     // Read the site config
     status = PyConfig_Read(&config);
     if (PyStatus_Exception(status)) {
         crash_dialog([NSString stringWithFormat:@"Unable to read site config: %s", status.err_msg, nil]);
         PyConfig_Clear(&config);
         Py_ExitStatusException(status);
     }
     */
    let python_tag = "3.13"
    // The unpacked form of the stdlib
    var path = "\(python_home)/lib/python\(python_tag)"
    print("- \(path)")

    if let wtmpStr = Py_DecodeLocale(path, nil) {
        let status = PyWideStringList_Append(&config.module_search_paths, wtmpStr)
        if PyStatus_Exception(status) != 0 {
            print("Unable to set unpacked form of stdlib path: \(String(cString: status.err_msg))")
            PyConfig_Clear(&config)
            Py_ExitStatusException(status)
        }
        PyMem_RawFree(wtmpStr)
    }

    
    // The binary modules in the stdlib
    path = "\(python_home)/lib/python\(python_tag)/lib-dynload"
    print("- \(path)")

    if let wtmpStr = Py_DecodeLocale(path, nil) {
        let status = PyWideStringList_Append(&config.module_search_paths, wtmpStr)
        if PyStatus_Exception(status) != 0 {
            print("Unable to set unpacked form of stdlib path: \(String(cString: status.err_msg))")
            PyConfig_Clear(&config)
            Py_ExitStatusException(status)
        }
        PyMem_RawFree(wtmpStr)
    }

    // Add the app_packages path
    path = "\(resourcePath)/app_packages"
    print("- \(path)")

    if let wtmpStr = Py_DecodeLocale(path, nil) {
        let status = PyWideStringList_Append(&config.module_search_paths, wtmpStr)
        if PyStatus_Exception(status) != 0 {
            print("Unable to set app packages path: \(String(cString: status.err_msg))")
            PyConfig_Clear(&config)
            Py_ExitStatusException(status)
        }
        PyMem_RawFree(wtmpStr)
    }

    // Add the app path
    path = "\(resourcePath)/app"
    print("- \(path)")

    if let wtmpStr = Py_DecodeLocale(path, nil) {
        let status = PyWideStringList_Append(&config.module_search_paths, wtmpStr)
        if PyStatus_Exception(status) != 0 {
            print("Unable to set app path: \(String(cString: status.err_msg))")
            PyConfig_Clear(&config)
            Py_ExitStatusException(status)
        }
        PyMem_RawFree(wtmpStr)
    }
    
    // Py_Initialize()
/*
    // Add the app path
    let path = (resourcePath as NSString).appendingPathComponent("app")
    print("- \(path)")

    if let wtmpStr = path.cString(using: .utf8) {
        let wtmpStrPointer = Py_DecodeLocale(wtmpStr, nil)
        let status = PyWideStringList_Append(&config.module_search_paths, wtmpStrPointer)
        
        if PyStatus_Exception(status) != 0 {
            print("Unable to set app path: \(String(cString: status.err_msg))")
            PyConfig_Clear(&config)
            Py_ExitStatusException(status)
        }
        
        PyMem_RawFree(wtmpStrPointer)
    }*/

    print("Configure argc/argv...")
    status = PyConfig_SetBytesArgv(&config, 0, nil)
    if PyStatus_Exception(status) != 0 {
        print("Unable to configure argc/argv: \(String(cString: status.err_msg))")
        PyConfig_Clear(&config)
        Py_ExitStatusException(status)
    }

    print("Initializing Python runtime...")
    status = Py_InitializeFromConfig(&config)
    if PyStatus_Exception(status) != 0 {
        print("Unable to initialize Python interpreter: \(String(cString: status.err_msg))")
        PyConfig_Clear(&config)
        Py_ExitStatusException(status)
    }
    
    let sys = Python.import("sys")
    print("Python Version: \(sys.version_info.major).\(sys.version_info.minor)")
    print("Python Encoding: \(sys.getdefaultencoding().upper())")
    print("Python Path: \(sys.path)")
    let platform = Python.import("platform")
    print(platform.system())*/
}
