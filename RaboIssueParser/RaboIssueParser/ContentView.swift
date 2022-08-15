//
//  ContentView.swift
//  RaboIssueParser
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI
import FileReader

struct ContentView: View {
    @State var readResults: [FileReadResult] = []
    
    var body: some View {
        FileReader(types: [.commaSeparatedText], allowMultiple: true, result: $readResults, content: {
            ZStack {
                Text("Hello, world!")
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
        .onChange(of: readResults) { results in
            results.forEach { readResult in
                print("result for \(readResult.url): \(readResult.result)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
