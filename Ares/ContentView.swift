//
//  ContentView.swift
//  Ares
//
//  Created by Joao Pires on 04/01/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // Use @Query to access your data
    @Query private var feeds: [Feed]
    
    // Access DataManager for operations
    let dataManager = DataManager.shared
    
    var body: some View {
        List(feeds) { feed in
            Text(feed.title ?? String())
        }
    }
}
