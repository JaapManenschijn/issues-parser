//
//  FileDataHolder.swift
//  FileReader
//
//  Created by J Manenschijn on 15/08/2022.
//

import Foundation

public struct FileReadResult: Equatable {
    public init(url: URL, result: Result<Data, Error>) {
        self.url = url
        self.result = result
    }
    
    public static func == (lhs: FileReadResult, rhs: FileReadResult) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    public let uuid: UUID = UUID()
    public let url: URL
    public let result: Result<Data, Error>
}
