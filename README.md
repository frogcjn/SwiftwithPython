# SwiftwithPython
How to embed Python Framework into Swift Projects
@kostrykin 

1. Follow up the detail instructions on Python official website:
https://docs.python.org/3.14/using/ios.html#adding-python-to-an-ios-project

Create two file copies called `module.modulemap` inside

- `Python.xcframework/ios-arm64/Python.framework/Headers/` and

- `Python.xcframework/ios-arm64_x86_64-simulator/Python.framework/Headers/`
    
containing the same code below:
```
module Python {
    umbrella header "Python.h"
    export *
    link "Python"
}
```

2. Add `init` func to the app swift file
```Swift
import SwiftUI

@main
struct SwiftPythonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        initPythonSimpleVersion()
        testPythonKit()
    }
}
```

3. Also add a new `InitPython.swift` file to the target:

```Swift
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

func testPythonKit() {
    print("test PythonKit")
    
    let sys = Python.import("sys")
    print("Python Version: \(sys.version_info.major).\(sys.version_info.minor)")
    print("Python Encoding: \(sys.getdefaultencoding().upper())")
    print("Python Path: \(sys.path)")
    let platform = Python.import("platform")
    print(platform.system())
}
```
![IMG_3538](https://github.com/user-attachments/assets/b15acf70-8987-48b3-b21a-7fe6780d5e3b)
