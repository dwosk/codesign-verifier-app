//
//  ContentView.swift
//  Codesign Verifier
//
//  Created by David Wosk on 10/2/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TextView()
            .frame(width: 400, height: 600)
    }
}

struct TextView: View {
    var body: some View {
        Text("Hello, world!")
            .font(.largeTitle)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
    }
}
