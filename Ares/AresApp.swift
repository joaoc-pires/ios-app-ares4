//
//  AresApp.swift
//  Ares
//
//  Created by Joao Pires on 04/01/2025.
//

import SwiftUI
import SwiftData
import SwiftyBeaver

let log = SwiftyBeaver.self

@main
struct AresApp: App {
    // Create the container at the app level
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([Feed.self, Folder.self, Entry.self])
            let configuration = ModelConfiguration(schema: schema)
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container) // Inject the container into the environment
    }
}
