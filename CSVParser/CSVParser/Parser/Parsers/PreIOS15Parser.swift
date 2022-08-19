//
//  PreIOS15Parser.swift
//  CSVParser
//
//  Created by J Manenschijn on 18/08/2022.
//

import Foundation

class PreIOS15Parser: ParserProtocol {
    private let data: Data
    private var allLines: [String] = []
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
                    let rowColumns = self.sanitize(row.split(separator: ",", omittingEmptySubsequences: false).map({ String($0) }))

                    let firstName = rowColumns[safe: firstNameIndex!] as? String
                    let surName = rowColumns[safe: surNameIndex!] as? String
                    let issueCountString = rowColumns[safe: issueCountIndex!] as? String
                    let issueCount = Int(issueCountString ?? "0")
                    let dateOfBirthString = rowColumns[safe: dateOfBirthIndex!] as? String
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
        // First, create a string from the data and split it into an array of lines
        let csvString = String(data: data, encoding: .utf8)
        var lines = csvString?.split(whereSeparator: \.isNewline)
        
        // A header line is expected to be present. If it isn't (there are no lines...), return an error
        guard let headerLine = lines?.removeFirst() else {
            throw MalformedCSVError(message: "Missing header line")
        }
        
        // Split the header line into columns by splitting on comma. Afterwards, sanitize the result
        let headers = String(headerLine).split(separator: ",").map({ String($0) })
        let columns = sanitize(headers).map({ $0 as? String ?? "" })
        
        // Find the correct indices for the expected columns. If not all columns are present, throw an error
        firstNameIndex = columns.firstIndex(of: firstNameColumn)
        surNameIndex = columns.firstIndex(of: surNameColumn)
        issueCountIndex = columns.firstIndex(of: issueCountColumn)
        dateOfBirthIndex = columns.firstIndex(of: dateOfBirthColumn)
        
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
        
        // Save a reference to the array of all lines
        allLines = lines?.compactMap({ String($0) }) ?? []
    }
    
    /// Sanitizes the given array, meaning it merges string elements together in case they were splitted due to a comma being in the middle of the string
    /// For example, strings in a column will be in the following format: "John Doe"
    /// If there would be an extra comma in there, parsing would not have the expected result: "John, Doe" would result into 2 elements when splitting on comma's, so we need to fix this
    /// - Parameter array: The list of elements to be sanitized
    /// - Returns: The sanitized list
    private func sanitize(_ array: [Any]) -> [Any] {
        var result: [Any] = []
        var mutableArray = array
        
        // Loop over the provided array until it's empty. Once it's empty, it means everything is sanitized
        while !mutableArray.isEmpty {
            
            // Fetch the first element by removing it from the array and check if it's a string & start with a ". If it's not, simply append it to the results and move on
            let first = mutableArray.removeFirst()
            if let text = first as? String, text.starts(with: "\"") {
                
                // The string started with ", now let's check if it ends with " as well. If it does, it means we have the entire string we're looking for, so append it to the result array (and strip the " from begin and end)
                if text.last == "\"" {
                    result.append(text.replacingOccurrences(of: "\"", with: ""))
                } else {
                    // There was a comma in a column so they accidentally split into additional columns. Let's fix it by finding the next element where the string ends with a ", as that is the expected end of our desired total string
                    if let endIndex = mutableArray.firstIndex(where: { element in
                        return (element as? String)?.last == "\""
                    }) {
                        
                        // We found the index of the last element that should be part of this string. Let's put all elements together into a single string and append it to the results array
                        var elementsToCombine = mutableArray.prefix(endIndex + 1).map({ ($0 as? String) ?? "" })
                        elementsToCombine.insert(text, at: 0)
                        result.append(elementsToCombine.joined(separator: ",").replacingOccurrences(of: "\"", with: ""))
                        
                        // To prevent an endless loop, we need to remove the elements we used from the array. If we used all elements, just create an empty array
                        if (endIndex + 1) < mutableArray.count {
                            mutableArray = Array(mutableArray.suffix(from: endIndex + 1))
                        } else {
                            mutableArray = []
                        }
                    } else {
                        // Somehow there was no other element to end the string with. We'll treat it as an element that doesn't need sanitizing in that case.
                        result.append(text.replacingOccurrences(of: "\"", with: ""))
                    }
                }
            } else {
                result.append(first)
            }
        }
        
        return result
    }

}
