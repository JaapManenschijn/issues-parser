//
//  FileReaderViewModel.swift
//  FileReader
//
//  Created by J Manenschijn on 15/08/2022.
//

import Foundation
import Combine

class FileReaderViewModel: ObservableObject {
    
    @Published var isPresented: Bool = false
    @Published private(set) var isProcessing: Bool = false
    @Published private(set) var results: [FileReadResult] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    func onButtonAction() {
        guard !isPresented else { return }
        
        isPresented = true
    }
    
    func onFilesPicked(urls: [URL]) {
        isProcessing = true
        
        Publishers.MergeMany(urls.map({ URL in
            FileReadPublisher(fileURL: URL)
        }))
        .collect()
        .delay(for: .seconds(1), scheduler: RunLoop.main)
        .subscribe(on: DispatchQueue.global(qos: .background))
        .receive(on: DispatchQueue.main)
        .sink { [weak self] output in
            guard let self = self else { return }
            
            self.isProcessing = false
            self.results = output
        }
        .store(in: &cancellables)
    }
}
