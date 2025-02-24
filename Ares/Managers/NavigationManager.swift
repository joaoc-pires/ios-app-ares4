//
//  NavigationManager.swift
//  Ares
//
//  Created by Joao Pires on 24/02/2025.
//

import SwiftUI

@Observable
class NavigationManager: ObservableObject {
    var mainStack: [AresNavigationStack] = []
    var settingsStack: [AresNavigationStack] = []
    
    var showSettings = false
    var showFeed = false
}
