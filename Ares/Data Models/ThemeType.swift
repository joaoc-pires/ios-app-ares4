//
//  ThemeType.swift
//  Ares
//
//  Created by Joao Pires on 21/01/2025.
//


import Foundation
import UIKit
import SwiftUI

enum ThemeType: String, CaseIterable {
    case red
    case orange
    case yellow
    case green
    case mint
    case teal
    case cyan
    case blue
    case indigo
    case purple
    case pink
    case brown
    
    var color: Color {
        switch self {
            case .red: return Color(uiColor: .systemRed)
            case .orange: return Color(uiColor: .systemOrange)
            case .yellow: return Color(uiColor: .systemYellow)
            case .green: return Color(uiColor: .systemGreen)
            case .mint: return Color(uiColor: .systemMint)
            case .teal: return Color(uiColor: .systemTeal)
            case .cyan: return Color(uiColor: .systemCyan)
            case .blue: return Color(uiColor: .systemBlue)
            case .indigo: return Color(uiColor: .systemIndigo)
            case .purple: return Color(uiColor: .systemPurple)
            case .pink: return Color(uiColor: .systemPink)
            case .brown: return Color(uiColor: .systemBrown)
        }
    }
    
    var uiColor: UIColor {
        switch self {
            case .red: return  .systemRed
            case .orange: return .systemOrange
            case .yellow: return .systemYellow
            case .green: return .systemGreen
            case .mint: return .systemMint
            case .teal: return .systemTeal
            case .cyan: return .systemCyan
            case .blue: return .systemBlue
            case .indigo: return .systemIndigo
            case .purple: return .systemPurple
            case .pink: return .systemPink
            case .brown: return .systemBrown
        }
    }
    
    var iconName: String {
        switch self {
            case .red: return "AppIconRed"
            case .orange: return "AppIconOrange"
            case .yellow: return "AppIconYellow"
            case .green: return "AppIconGreen"
            case .mint: return "AppIconMint"
            case .teal: return "AppIconTeal"
            case .cyan: return "AppIconCyan"
            case .blue: return "AppIconBlue"
            case .indigo: return "AppIconIndigo"
            case .purple: return "AppIconPurple"
            case .pink: return "AppIconPink"
            case .brown: return "AppIconBrown"
        }
    }
    
    var iconPreview: UIImage {
        UIImage(named: iconName + "-Preview") ?? UIImage()
    }
    
    var htmlString: String {
        switch self {
            case .red: return "rgb(255, 59, 48)"
            case .orange: return "rgb(255, 149, 0)"
            case .yellow: return "rgb(255, 204, 0)"
            case .green: return "rgb(52, 199, 89)"
            case .mint: return "rgb(0, 199, 190)"
            case .teal: return "rgb(48, 176, 199)"
            case .cyan: return "rgb(50, 173, 230)"
            case .blue: return "rgb(0, 122, 255)"
            case .indigo: return "rgb(88, 86, 214)"
            case .purple: return "rgb(175, 82, 222)"
            case .pink: return "rgb(255, 45, 85)"
            case .brown: return "rgb(162, 132, 94)"
        }
    }
    
    var label: String {
        switch self {
            case .red: return "red".capitalized
            case .orange: return "orange".capitalized
            case .yellow: return "yellow".capitalized
            case .green: return "green".capitalized
            case .mint: return "mint".capitalized
            case .teal: return "teal".capitalized
            case .cyan: return "cyan".capitalized
            case .blue: return "blue".capitalized
            case .indigo: return "indigo".capitalized
            case .purple: return "purple".capitalized
            case .pink: return "pink".capitalized
            case .brown: return "brown".capitalized
        }
    }
}