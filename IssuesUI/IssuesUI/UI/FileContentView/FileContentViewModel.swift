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
    private let pageSize: Int = 50
    
    @Published var users: [UserModel] = []
    @Published var isLoading: Bool = false
    @Published var showingAlert = false
    var hasMoreData: Bool = true
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
    
    func loadData() async {
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
        
        Task {
            do {
                let csvParser = try CSVParser(data: data)
                await MainActor.run {
                    self.parser = csvParser
                }
                await loadNextPage()
                loadingTask.cancel()
                
                await MainActor.run {
                    self.isLoading = false
                }
            } catch let error {
                if let parseError = error as? MalformedCSVError {
                    errorMessage = parseError.message
                } else {
                    errorMessage = "file_content_error".localized()
                }
                showingAlert = true
            }
        }
    }
    
    func loadNextPage() async {
        var newUsers: [User] = []
        if let parser = parser {
            for await user in parser.getUsers(limit: pageSize, offset: users.count) {
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
            hasMoreData = newUsers.count == pageSize
        }
    }
}
