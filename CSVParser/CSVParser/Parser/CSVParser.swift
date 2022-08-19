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

/// The CSV parser. Uses different parsnig methods based on the iOS version
public class CSVParser {
    
    private var lock = NSLock()
    private let parser: ParserProtocol
    
    /// Initializes the CSVParser with the given data
    /// - Parameter data: The data to parse
    public init(data: Data) throws {
        // Due to iOS 15 having added support for parsing CSV data, check which parser to use
        if #available(iOS 15, *) {
            parser = try IOS15Parser(data: data)
        } else {
            parser = try PreIOS15Parser(data: data)
        }
    }
    
    /// Get the users from the parser
    /// - Parameters:
    ///   - limit: The amount of users you want to get
    ///   - offset: The offset in the list of all users
    /// - Returns: An AsyncStream that will notify any time a user is parsed and finishes when the limit is reached
    public func getUsers(limit: Int, offset: Int) -> AsyncStream<User> {
        let safeOffset = max(0, offset)
        let safeLimit = max(0, limit)
        return parser.getUsers(limit: safeLimit, offset: safeOffset)
    }
    
}
