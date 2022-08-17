//
//  ContentView.swift
//  RaboIssueParser
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI
import FileReader
import CSVParser
import Combine

struct ContentView: View {
    @State var readResults: [FileReadResult] = []
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                FileReader(types: [.commaSeparatedText], allowMultiple: true, result: $readResults, content: {
                    Text("Hello, world!")
                        .padding()
                })
                
                Text("Number of users: \(viewModel.results.count)")
            }
        }
        
        .onChange(of: readResults) { results in
            results.forEach { readResult in
                print("result for \(readResult.url): \(readResult.result)")
                switch readResult.result {
                case .success(let data):
                    Task {
                        await viewModel.onParseCsv(data: data)
                    }
                default:
                    break
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class ContentViewModel: ObservableObject {
    
    @Published private(set) var results: [User] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    func onParseCsv(data: Data) async {
        results = []
        
        let parser = CSVParser(data: data)
        do {
            for await user in try parser.parse() {
                await MainActor.run {
                    results.append(user)
                }
            }
        }
        catch let error {
            print(error)
        }
    }
}
