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
    
    public init(data: Data) throws {
        if #available(iOS 15, *) {
            parser = try IOS15Parser(data: data)
        } else {
            parser = try PreIOS15Parser(data: data)
        }
    }
    
    public func getUsers(limit: Int, offset: Int) -> AsyncStream<User> {
        let safeOffset = max(0, offset)
        let safeLimit = max(0, limit)
        return parser.getUsers(limit: safeLimit, offset: safeOffset)
    }
    
}
