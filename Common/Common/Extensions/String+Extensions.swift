//
//  String+Extensions.swift
//  Common
//
//  Created by J Manenschijn on 16/08/2022.
//

import Foundation

public extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle(for: LocalResources.self), value: "", comment: "")
    }
}
