//
//  ContentView.swift
//  RaboIssueParser
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI
import FileReader

struct ContentView: View {
    var body: some View {
        FileReader(types: [.commaSeparatedText], allowMultiple: true) { result in
            //ignore
        } content: {
            ZStack {
                Text("Hello, world!")
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
