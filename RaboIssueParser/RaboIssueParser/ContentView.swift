//
//  ContentView.swift
//  RaboIssueParser
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI
import FileReader
import CSVParser

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
                switch readResult.result {
                case .success(let data):
                    let result = CSVParser.importTable(data: data)
                    parseResult(result)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func parseResult(_ result: Result<[User], Error>) {
        switch result {
        case .success(let users):
            users.forEach { user in
                print(user)
            }
        case .failure(let error):
            print((error as? MalformedCSVError)?.message ?? "")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
