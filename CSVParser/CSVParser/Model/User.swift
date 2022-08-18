//
//  User.swift
//  CSVParser
//
//  Created by J Manenschijn on 16/08/2022.
//

import Foundation

public struct User: Equatable, Hashable {
    public let id: UUID = UUID()
    public let firstName: String?
    public let surName: String?
    public let issueCount: Int
    public let dateOfBirth: Date?
}
