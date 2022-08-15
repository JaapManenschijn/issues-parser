//
//  FileReaderViewModel.swift
//  FileReader
//
//  Created by J Manenschijn on 15/08/2022.
//

import Foundation

class FileReaderViewModel: ObservableObject {
    @Published var isPresented: Bool = false
    
    func onButtonAction() {
        guard !isPresented else { return }
        
        isPresented = true
    }
    
    func onFilesPicked(urls: [URL]) {
        
    }
}
