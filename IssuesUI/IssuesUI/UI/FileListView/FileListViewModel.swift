//
//  FileListViewModel.swift
//  IssuesUI
//
//  Created by J Manenschijn on 18/08/2022.
//

import Foundation
import FileReader

struct FileModel {
    let id: UUID
    let name: String
}

class FileListViewModel: ObservableObject {
    @Published var showingAlert = false
    @Published var shouldNavigate: Bool = false
    
    private let files: [FileReadResult]
    var selectedFileData: Data?
    var selectedFileName: String?
    
    var succesfullReads: [FileModel] {
        getFileModels(successfullReads: true)
    }
    
    var errorReads: [FileModel] {
        getFileModels(successfullReads: false)
    }
    
    init(files: [FileReadResult]) {
        self.files = files
    }
    
    private func getFileModels(successfullReads: Bool) -> [FileModel] {
        let filtered = files.filter({
            switch $0.result {
            case .success(_):
                return successfullReads
            default:
                return !successfullReads
            }
        })
        
        return filtered.map { readResult -> FileModel in
            let fileName = readResult.url.lastPathComponent
            return FileModel(id: readResult.uuid, name: fileName)
        }
    }
    
    func onRowClickAction(_ id: UUID) {
        if let file = files.first(where: { $0.uuid == id }) {
            switch file.result {
            case .success(let data):
                // pass the data to next screen?
                selectedFileName = file.url.lastPathComponent
                selectedFileData = data
                shouldNavigate = true
            case .failure(_):
                showingAlert = true
            }
        }
    }
}
