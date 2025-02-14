# SwiftwithPython

How to embed Python Framework into Swift Projects (currently iOS)

1. Create an empty Swift iOS Project

2. Download Compiled Python.xcframework for iOS target
https://github.com/beeware/Python-Apple-support/releases/tag/3.13-b3
- `Python-3.13-iOS-support.b3.tar.gz`
    - `./platform-site/sitecustomize.py` : use this file to custom download packages on targeted platform
    - `Python.xcframework`: this is what we need

3-8. Follow up the detail instructions on Python official website: [Using Python on iOS](https://docs.python.org/3.14/using/ios.html#adding-python-to-an-ios-project) (except the step 1, 4, 5, 10 in this document)

(I also have a more detailed version published on my Notion [Swift with Python Step by Step](https://frogcjn.notion.site/Python-3-13-on-iOS-1984959764ca80999f25cf9897df83bc), including the necessary steps posted on Python official website)

9. Create two file copies called `module.modulemap` inside

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
Step 3-9 are necessary steps to `import Python` in Swift, Xcode will search the module headers in `Python.framework`

10. `PythonKit` is not a requirement to use Python on iOS, but if you want to use the code in `testPythonKit()` in next step to test, then you should add `PythonKit` on the Xcode project settings, there is a Swift Package Manager configuration.

![Image](https://github.com/user-attachments/assets/e25a1ea8-586e-48a1-904c-78798755f2fa)

5. Add `init` func to the iOS Project App swift file
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

11. Also add a new `InitPython.swift` file to the target:

```Swift
import Foundation
import Python

// Python Init Part (Neccessary)
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

// test PythonKit Part (Optional)
import PythonKit
var version: String? = nil
func testPythonKit() {
    print("test PythonKit")
    
    let sys = Python.import("sys")
    version = "\(sys.version)"
    print("Python Version: \(sys.version_info.major).\(sys.version_info.minor)")
    print("Python Encoding: \(sys.getdefaultencoding().upper())")
    print("Python Path: \(sys.path)")
    let platform = Python.import("platform")
    print(platform.system())
}
```

12. Edit `ContentView.swift`
```Swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("🐍")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, Python \(version ?? "Not Available")!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

```

13. Final Result

![IMG_3538](https://github.com/user-attachments/assets/b15acf70-8987-48b3-b21a-7fe6780d5e3b)
