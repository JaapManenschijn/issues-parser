//
//  Style.swift
//  Common
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI

class LocalResources {
    // We're only using this class as a reference for the correct bundle
}

public extension Color {
    static var primaryText: Color {
        Color("Colors/Text/Primary", bundle: Bundle(for: LocalResources.self))
    }
    
    static var primaryBackground: Color {
        Color("Colors/Background/Primary", bundle: Bundle(for: LocalResources.self))
    }
    
    static var primaryShadow: Color {
        Color("Colors/Shadow/Primary", bundle: Bundle(for: LocalResources.self))
    }
}
