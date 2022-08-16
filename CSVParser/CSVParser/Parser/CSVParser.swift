//
//  CSVParser.swift
//  CSVParser
//
//  Created by J Manenschijn on 16/08/2022.
//

import Foundation
import TabularData
import Common

public struct MalformedCSVError: Error {
    public let message: String
}

public class CSVParser {
    static let firstNameColumn = "First name"
    static let surNameColumn = "Sur name"
    static let issueCountColumn = "Issue count"
    static let dateOfBirthColumn = "Date of birth"
    
    
    public static func importTable(data: Data) -> Result<[User], Error> {
        if #available(iOS 15, *) {
            return CSVParser.parseCSVIOS15(data: data)
        } else {
            return CSVParser.parseCSVPreIOS15(data: data)
        }
    }
    
    private static func parseCSVPreIOS15(data: Data) -> Result<[User], Error> {
        let csvString = String(data: data, encoding: .utf8)
        var lines = csvString?.split(whereSeparator: \.isNewline)
        guard let headerLine = lines?.removeFirst() else {
            return .failure(MalformedCSVError(message: "Missing header line"))
        }
        let headers = String(headerLine).split(separator: ",").map({ String($0) })
        let columns = sanitize(headers).map({ $0 as? String ?? "" })
        
        var users: [User] = []
        
        let firstNameIndex = columns.firstIndex(of: firstNameColumn)
        let surNameIndex = columns.firstIndex(of: surNameColumn)
        let issueCountIndex = columns.firstIndex(of: issueCountColumn)
        let dateOfBirthIndex = columns.firstIndex(of: dateOfBirthColumn)
        
        guard let firstNameIndex = firstNameIndex,
        let surNameIndex = surNameIndex,
        let issueCountIndex = issueCountIndex,
        let dateOfBirthIndex = dateOfBirthIndex else {
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
            return .failure(MalformedCSVError(message: message))
        }
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        
        let rows = lines?.compactMap({ String($0) })
        rows?.forEach { row in
            let rowColumns = sanitize(row.split(separator: ",").map({ String($0) }))
            
            let firstName = rowColumns[safe: firstNameIndex] as? String
            let surName = rowColumns[safe: surNameIndex] as? String
            let issueCountString = rowColumns[safe: issueCountIndex] as? String
            let issueCount = Int(issueCountString ?? "0")
            let dateOfBirthString = rowColumns[safe: dateOfBirthIndex] as? String
            var dateOfBirth: Date?
            if let dateOfBirthString = dateOfBirthString {
                dateOfBirth = dateFormatter.date(from: dateOfBirthString)
            }
            
            users.append(User(firstName: firstName, surName: surName, issueCount: issueCount ?? 0, dateOfBirth: dateOfBirth))
        }
        
        return .success(users)
    }
    
    @available(iOS 15, *)
    private static func parseCSVIOS15(data: Data) -> Result<[User], Error> {
        var importerTable: DataFrame = [:]
        
        let options = CSVReadingOptions(hasHeaderRow: true, delimiter: ",")
        do {
            importerTable = try DataFrame(
                csvData: data, columns: nil, rows: nil, types: [:], options: options)
            
            var users: [User] = []
            
            let firstNameIndex = importerTable.indexOfColumn(firstNameColumn)
            let surNameIndex = importerTable.indexOfColumn(surNameColumn)
            let issueCountIndex = importerTable.indexOfColumn(issueCountColumn)
            let dateOfBirthIndex = importerTable.indexOfColumn(dateOfBirthColumn)
            
            guard let firstNameIndex = firstNameIndex,
            let surNameIndex = surNameIndex,
            let issueCountIndex = issueCountIndex,
            let dateOfBirthIndex = dateOfBirthIndex else {
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
                return .failure(MalformedCSVError(message: message))
            }

            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withFullDate]
            
            importerTable.rows.forEach { row in
                let firstName = row[safe: firstNameIndex] as? String
                let surName = row[safe: surNameIndex] as? String
                let issueCount = row[safe: issueCountIndex] as? Int
                let dateOfBirthString = row[safe: dateOfBirthIndex] as? String
                var dateOfBirth: Date?
                if let dateOfBirthString = dateOfBirthString {
                    dateOfBirth = dateFormatter.date(from: dateOfBirthString)
                }
                
                users.append(User(firstName: firstName, surName: surName, issueCount: issueCount ?? 0, dateOfBirth: dateOfBirth))
            }
            
            return .success(users)
            
        } catch {
            return .failure(error)
        }
    }
    
    // Sanitizes the given array. Basically merges string elements together in case they were splitted due to a comma being in the middle of the string
    private static func sanitize(_ array: [Any]) -> [Any] {
        var result: [Any] = []
        var mutableArray = array
        
        while !mutableArray.isEmpty {
            let first = mutableArray.removeFirst()
            if let text = first as? String, text.starts(with: "\"") {
                if text.last == "\"" {
                    result.append(text.replacingOccurrences(of: "\"", with: ""))
                } else {
                    // There was a comma in a column so they accidentally split into additional columns. Let's fix it
                    if let endIndex = mutableArray.firstIndex(where: { element in
                        return (element as? String)?.last == "\""
                    }) {
                        var elementsToCombine = mutableArray.prefix(endIndex + 1).map({ ($0 as? String) ?? "" })
                        elementsToCombine.insert(text, at: 0)
                        result.append(elementsToCombine.joined(separator: ",").replacingOccurrences(of: "\"", with: ""))
                        if (endIndex + 1) < mutableArray.count {
                            mutableArray = Array(mutableArray.suffix(from: endIndex + 1))
                        } else {
                            mutableArray = []
                        }
                    }
                }
            } else {
                result.append(first)
            }
        }
        
        return result
    }
}
