//
//  FileContentViewModel.swift
//  IssuesUI
//
//  Created by J Manenschijn on 18/08/2022.
//

import Foundation
import CSVParser
import SwiftUI

@MainActor
class FileContentViewModel: ObservableObject {
    static let pageSize: Int = 50
    
    @Published var users: [UserModel] = []
    @Published var isLoading: Bool = false
    @Published var showingAlert = false
    var hasMoreData: Bool = false
    var errorMessage: String = "file_content_error".localized()
    
    let fileName: String?
    private let data: Data?
    private var parser: CSVParser?
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }
    
    init(data: Data?, fileName: String?) {
        self.data = data
        self.fileName = fileName
    }
    
    func loadData(limit: Int = FileContentViewModel.pageSize) async {
        guard let data = data else {
            showingAlert = true
            return
        }
        
        let loadingTask = Task {
            try await Task.sleep(nanoseconds: 250_000_000)
            await MainActor.run {
                isLoading = true
            }
        }
        
        do {
            let csvParser = try CSVParser(data: data)
            self.parser = csvParser
            await loadNextPage(limit: limit)
            loadingTask.cancel()
            
            self.isLoading = false
        } catch let error {
            if let parseError = error as? MalformedCSVError {
                errorMessage = parseError.message
            } else {
                errorMessage = "file_content_error".localized()
            }
            showingAlert = true
        }
    }
    
    func loadNextPage(limit: Int = FileContentViewModel.pageSize) async {
        var newUsers: [User] = []
        if let parser = parser {
            for await user in parser.getUsers(limit: limit, offset: users.count) {
                newUsers.append(user)
            }
            
            users.append(contentsOf: newUsers.map({ user in
                let name = [user.firstName ?? "", user.surName ?? ""].joined(separator: " ")
                let birthDate: String
                if let date = user.dateOfBirth {
                    birthDate = dateFormatter.string(from: date)
                } else {
                    birthDate = ""
                }
                return UserModel(id: user.id, name: name, issueCount: user.issueCount, birthDate: birthDate)
            }))
            hasMoreData = newUsers.count == limit
        }
    }
}
