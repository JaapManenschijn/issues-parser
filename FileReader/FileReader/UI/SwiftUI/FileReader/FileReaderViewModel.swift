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
    
    private var cancellables: Set<AnyCancellable> = []
    
    func onButtonAction() {
        guard !isPresented else { return }
        
        isPresented = true
    }
    
    func onFilesPicked(urls: [URL]) async throws -> [FileReadResult] {        
        return await readDataFromFiles(urls: urls)
    }
    
    private func readDataFromFiles(urls: [URL]) async -> [FileReadResult] {
        return await withTaskGroup(of: FileReadResult.self) { group in
            var results: [FileReadResult] = []
            
            for url in urls {
                group.addTask {
                    return await self.readFileData(url: url)
                }
            }
            
            for await readResult in group {
                results.append(readResult)
            }
            
            return results
        }
    }
    
    private func readFileData(url: URL) async -> FileReadResult {
        do {
            let data = try Data(contentsOf: url)
            return FileReadResult(url: url, result: .success(data))
        } catch let error {
            return FileReadResult(url: url, result: .failure(error))
        }
    }
}
