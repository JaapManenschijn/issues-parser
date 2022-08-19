//
//  ParserProtocol.swift
//  CSVParser
//
//  Created by J Manenschijn on 18/08/2022.
//

import Foundation

protocol ParserProtocol {
    init(data: Data) throws
    func getUsers(limit: Int, offset: Int) -> AsyncStream<User>
}

extension ParserProtocol {
    var firstNameColumn: String {
        "First name"
    }
    var surNameColumn: String {
        "Sur name"
    }
    var issueCountColumn: String {
        "Issue count"
    }
    var dateOfBirthColumn: String {
        "Date of birth"
    }
    
    var dateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter
    }
}
