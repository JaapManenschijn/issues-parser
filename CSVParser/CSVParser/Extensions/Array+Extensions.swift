//
//  Array+Extensions.swift
//  CSVParser
//
//  Created by J Manenschijn on 16/08/2022.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}