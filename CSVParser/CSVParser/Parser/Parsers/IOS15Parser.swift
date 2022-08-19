//
//  IOS15Parser.swift
//  CSVParser
//
//  Created by J Manenschijn on 18/08/2022.
//

import Foundation
import TabularData

@available(iOS 15, *)
class IOS15Parser: ParserProtocol {
    private let data: Data
    private var didParse: Bool = false
    private var allLines: [DataFrame.Row] = []
    private var firstNameIndex: Int?
    private var surNameIndex: Int?
    private var issueCountIndex: Int?
    private var dateOfBirthIndex: Int?
    
    required init(data: Data) throws {
        self.data = data
        try parseData()
    }
    
    func getUsers(limit: Int, offset: Int) -> AsyncStream<User> {
        // To 'simulate' pagination, we're using a subset of the array with all lines
        let rows = allLines[safe: offset..<(offset + limit)]
        
        // Create the async stream that parses the requested rows into User objects
        return AsyncStream<User> { continuation in
            Task {
                for row in rows {
                    let firstName = row[safe: firstNameIndex!] as? String
                    let surName = row[safe: surNameIndex!] as? String
                    let issueCount = row[safe: issueCountIndex!] as? Int
                    let dateOfBirthString = row[safe: dateOfBirthIndex!] as? String
                    var dateOfBirth: Date?
                    if let dateOfBirthString = dateOfBirthString {
                        dateOfBirth = self.dateFormatter.date(from: dateOfBirthString)
                    }
                    
                    let user = User(firstName: firstName, surName: surName, issueCount: issueCount ?? 0, dateOfBirth: dateOfBirth)
                    continuation.yield(user)
                }
                continuation.finish()
            }
        }
    }
    
    func parseData() throws {
        // Since iOS15, iOS has some built in support for parsing CSV data. Let's use it when we can
        var importerTable: DataFrame = [:]
        
        // Just like in the pre iOS15 parse function, we expect the existence of a header row & use a comma as delimiter
        let options = CSVReadingOptions(hasHeaderRow: true, delimiter: ",")
        
        // Try to parse the data with the constructed options. If it fails, return the error
        importerTable = try DataFrame(
            csvData: data, columns: nil, rows: nil, types: [:], options: options)
        
        // Find the correct indices for the expected columns. If not all columns are present, throw an error
        firstNameIndex = importerTable.indexOfColumn(firstNameColumn)
        surNameIndex = importerTable.indexOfColumn(surNameColumn)
        issueCountIndex = importerTable.indexOfColumn(issueCountColumn)
        dateOfBirthIndex = importerTable.indexOfColumn(dateOfBirthColumn)
        
        guard firstNameIndex != nil,
              surNameIndex != nil,
              issueCountIndex != nil,
              dateOfBirthIndex != nil else {
            var message = "Malformed CSV. Missing columns:\n"
            
            [
                firstNameColumn: firstNameIndex,
                surNameColumn: surNameIndex,
                issueCountColumn: issueCountIndex,
                dateOfBirthColumn: dateOfBirthIndex
            ].forEach { (columnName, index) in
                if index == nil {
                    message += columnName + "\n"
                }
            }
            throw MalformedCSVError(message: message)
        }
        
        // Save a reference to the array with all lines
        allLines = importerTable.rows.map({ $0 })
    }
}
