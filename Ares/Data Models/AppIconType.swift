//
//  AppIconType.swift
//  Ares
//
//  Created by Joao Pires on 21/01/2025.
//


import Foundation
import UIKit
import SwiftUI

enum AppIconType: String, CaseIterable {
    case appIcon
    case appIconFillDarkMode
    case appIconFill
    case appIconRainbow
    case appIconSixColors
    
    var iconName: String {
        switch self {
            case .appIcon: return "AppIcon"
            case .appIconFillDarkMode: return "AppIcon-Fill-Dark-Mode"
            case .appIconFill: return "AppIcon-Fill"
            case .appIconRainbow: return "AppIcon-Rainbow"
            case .appIconSixColors: return "AppIcon-Six-Colors"
        }
    }
    
    var label: String {
        switch self {
            case .appIcon: return "Default"
            case .appIconFillDarkMode: return "Filled Dark Mode"
            case .appIconFill: return "Filled"
            case .appIconRainbow: return "Rainbow"
            case .appIconSixColors: return "Six Colors"
        }
    }

}