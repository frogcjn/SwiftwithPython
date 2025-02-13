//
//  ContentView.swift
//  iOSwithPython3.13
//
//  Created by Cao, Jiannan on 2/12/25.
//

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
