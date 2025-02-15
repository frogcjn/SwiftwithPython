//
//  iOSwithPythonApp.swift
//  iOSwithPython3.13
//
//  Created by Cao, Jiannan on 2/12/25.
//

import SwiftUI

@main
struct iOSwithPythonApp: App {
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
