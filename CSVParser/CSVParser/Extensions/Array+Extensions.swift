//
//  Array+Extensions.swift
//  CSVParser
//
//  Created by J Manenschijn on 16/08/2022.
//

import Foundation

extension Array {
    
    subscript(safe range: Range<Index>) -> ArraySlice<Element> {
        return self[Swift.min(range.startIndex, self.endIndex)..<Swift.min(range.endIndex, self.endIndex)]
    }
}
