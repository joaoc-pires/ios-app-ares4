//
//  ContentView.swift
//  Ares
//
//  Created by Joao Pires on 04/01/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    // Use @Query to access your data
    @Query private var feeds: [Feed]
    
    // Access DataManager for operations
    let dataManager = DataManager.shared
        
    var body: some View {
        Button(action: { navigationManager.showSettings = true }) {
            Text("Open Settings")
        }
        .sheet(isPresented: $navigationManager.showSettings) {
            SettingsView()
        }
    }
}
