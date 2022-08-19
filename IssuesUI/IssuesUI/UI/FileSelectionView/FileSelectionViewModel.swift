//
//  FileSelectionViewModel.swift
//  IssuesUI
//
//  Created by J Manenschijn on 18/08/2022.
//

import Foundation
import FileReader
import Combine

class FileSelectionViewModel: ObservableObject {
    @Published var shouldNavigate: Bool = false
    @Published var fileReaderResults: [FileReadResult] = []
    @Published var isLoading: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        $fileReaderResults
            .dropFirst()
            .filter({ $0.isEmpty == false })
            .sink { results in
                self.shouldNavigate = true
            }
            .store(in: &cancellables)
    }
}
