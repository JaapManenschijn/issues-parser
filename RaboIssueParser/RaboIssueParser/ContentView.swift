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
                    viewModel.onParseCsv(data: data)
                default:
                    break
                }
            }
        }
        .onChange(of: viewModel.results) { newValue in
            print("got new users: \(newValue.count)")
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
    
    func onParseCsv(data: Data) {
        CSVParserPublisher(data: data)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { users in
                self.results = users
            }
            .store(in: &cancellables)
    }
}
