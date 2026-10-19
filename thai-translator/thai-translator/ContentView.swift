//
//  ContentView.swift
//  thai-translator
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Thai Translator")
                .font(.largeTitle.bold())
            Text("สวัสดี")
                .font(.title)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
