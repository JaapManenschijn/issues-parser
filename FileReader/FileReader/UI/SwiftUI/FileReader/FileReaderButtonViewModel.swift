//
//  FileReaderViewModel.swift
//  FileReader
//
//  Created by J Manenschijn on 15/08/2022.
//

import Foundation
import Combine

class FileReaderButtonViewModel: ObservableObject {
    
    @Published var isPresented: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    func onButtonAction() {
        guard !isPresented else { return }
        
        isPresented = true
    }
    
    func onFilesPicked(urls: [URL]) async throws -> [FileReadResult] {        
        return await readDataFromFiles(urls: urls)
    }
    
    /// Asynchronously reads data from the given file URLs.
    /// - Parameter urls: The (file) URLs to read data from
    /// - Returns: The array with results
    private func readDataFromFiles(urls: [URL]) async -> [FileReadResult] {
        // Using a task group to read the files on parallel
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
    
    /// Asynchronous read of the file data for the given URL
    /// - Parameter url: The URL to read data from
    /// - Returns: The read result
    private func readFileData(url: URL) async -> FileReadResult {
        do {
            let data = try Data(contentsOf: url)
            return FileReadResult(url: url, result: .success(data))
        } catch let error {
            return FileReadResult(url: url, result: .failure(error))
        }
    }
}
