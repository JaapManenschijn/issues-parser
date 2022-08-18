//
//  FileSelectionViewModel.swift
//  IssuesUI
//
//  Created by J Manenschijn on 18/08/2022.
//

import Foundation
import FileReader

class FileSelectionViewModel: ObservableObject {
    @Published var shouldNavigate: Bool = false
    @Published var fileReaderResults: [FileReadResult] = []
    
    func onFilesPicked(urls: [URL]) {
        
    }
}
