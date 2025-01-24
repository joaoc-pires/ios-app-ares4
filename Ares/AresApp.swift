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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Entry.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
