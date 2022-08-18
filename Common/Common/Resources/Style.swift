//
//  Style.swift
//  Common
//
//  Created by J Manenschijn on 15/08/2022.
//

import SwiftUI
import UIKit

class LocalResources {
    // We're only using this class as a reference for the correct bundle
}

public extension Color {
    static var primaryText: Color {
        Color("Colors/Text/Primary", bundle: Bundle(for: LocalResources.self))
    }
    
    static var titleText: Color {
        Color("Colors/Text/Title", bundle: Bundle(for: LocalResources.self))
    }
    
    static var buttonText: Color {
        Color("Colors/Text/Button", bundle: Bundle(for: LocalResources.self))
    }
    
    static var primaryBackground: Color {
        Color("Colors/Background/Primary", bundle: Bundle(for: LocalResources.self))
    }
    
    static var primaryShadow: Color {
        Color("Colors/Shadow/Primary", bundle: Bundle(for: LocalResources.self))
    }
    
    static var navigationBackground: Color {
        Color("Colors/Background/Navigation", bundle: Bundle(for: LocalResources.self))
    }
}

public extension UIColor {
    static var navigationBackground: UIColor {
        UIColor(.navigationBackground)
    }
    
    static var titleText: UIColor {
        UIColor(.titleText)
    }
}
