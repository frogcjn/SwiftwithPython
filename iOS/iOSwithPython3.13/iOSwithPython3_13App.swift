//
//  iOSwithPython3_13App.swift
//  iOSwithPython3.13
//
//  Created by Cao, Jiannan on 2/12/25.
//

import SwiftUI

@main
struct iOSwithPython3_13App: App {
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
