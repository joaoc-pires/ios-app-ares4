//
//  DataManager.swift
//  Ares
//
//  Created by Joao Pires on 21/01/2025.
//

import Foundation
import SwiftData
import Observation

@Observable
final class DataManager {
    // MARK: - Properties
    static let shared = DataManager()
    private let container: ModelContainer
    private let context: ModelContext

    // Add property to track updates
    private(set) var lastUpdate: Date = Date()

    // MARK: - Initialization
    private init() {
        do {
            let schema = Schema([Feed.self, Folder.self, Entry.self])
            let configuration = ModelConfiguration(schema: schema)
            container = try ModelContainer(for: schema, configurations: [configuration])
            context = ModelContext(container)
            context.autosaveEnabled = true
            setupNotificationObservers()
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    // Mark context as updated
    private func markAsUpdated() {
        lastUpdate = Date()
        context.processPendingChanges()
    }

    // MARK: - Setup
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            forName: NotificationName.didFinishRefreshingAllFeeds,
            object: nil,
            queue: nil,
            using: handleRefreshAllFeeds
        )
        NotificationCenter.default.addObserver(
            forName: NotificationName.didFinishRefreshingFeed,
            object: nil,
            queue: nil,
            using: handleRefreshFeed
        )
    }

    // MARK: - Notification Handlers
    private func handleRefreshAllFeeds(_ notification: Notification) {
        guard let unownedFeeds = notification.object as? [UnownedFeed] else { return }
        
        Task {
            do {
                var newFeeds: [UnownedFeed] = []
                
                for unownedFeed in unownedFeeds {
                    let feedId = unownedFeed.id
                    let descriptor = FetchDescriptor<Feed>(predicate: #Predicate<Feed> { existingFeed in
                        existingFeed.id == feedId
                    })
                    
                    let existingFeeds = try context.fetch(descriptor)
                    if existingFeeds.isEmpty {
                        try await insertFeed(unownedFeed, in: context)
                        newFeeds.append(unownedFeed)
                    }
                }
                
                if !newFeeds.isEmpty {
                    markAsUpdated()
                    NotificationCenter.default.post(
                        name: NotificationName.didInsertNewFeeds,
                        object: newFeeds
                    )
                }
            } catch {
                print("Error handling refresh all feeds: \(error)")
            }
        }
    }
    
    private func handleRefreshFeed(_ notification: Notification) {
        guard let unownedFeed = notification.object as? UnownedFeed else { return }
        
        Task {
            do {
                let feedId = unownedFeed.id
                let descriptor = FetchDescriptor<Feed>(predicate: #Predicate<Feed> { existingFeed in
                    existingFeed.id == feedId
                })
                
                let existingFeeds = try context.fetch(descriptor)
                if existingFeeds.isEmpty {
                    try await insertFeed(unownedFeed, in: context)
                    markAsUpdated()
                    NotificationCenter.default.post(
                        name: NotificationName.didInsertNewFeed,
                        object: unownedFeed
                    )
                }
            } catch {
                print("Error handling refresh feed: \(error)")
            }
        }
    }

    // MARK: - CRUD for Feed

    /**
     Inserts a Feed object if it does not already exist.
     - Parameters:
       - feed: The Feed object to insert.
       - context: The ModelContext to perform the operation.
     - Throws: An error if saving to the context fails.
     */
    func insertFeed(_ feed: UnownedFeed, in context: ModelContext) async throws {
        // 1. Get the feed ID before creating the predicate
        let feedId = feed.id
        
        // 2. Check if a feed with the same URL already exists
        let descriptor = FetchDescriptor<Feed>(predicate: #Predicate<Feed> { existingFeed in
            existingFeed.id == feedId
        })
        
        let existingFeeds = try context.fetch(descriptor)
        guard existingFeeds.isEmpty else { return }
        
        // 3. Create and insert the new feed
        let newFeed = Feed(from: feed, and: feed.entries)
        context.insert(newFeed)
        try context.save()
        markAsUpdated()
    }

    
    /**
     Fetches all Feed objects from the context.
     - Parameter context: The ModelContext to perform the operation.
     - Returns: An array of Feed objects.
     - Throws: An error if fetching from the context fails.
     */
    func fetchFeeds(in context: ModelContext) async throws -> [Feed] {
        let descriptor = FetchDescriptor<Feed>() // No predicate to fetch all feeds
        return try context.fetch(descriptor)
    }

    
    /**
     Deletes a Feed object from the context.
     - Parameters:
       - feed: The Feed object to delete.
       - context: The ModelContext to perform the operation.
     - Throws: An error if saving to the context fails.
     */
    func deleteFeed(_ feed: Feed, in context: ModelContext) async throws {
        // 1. Remove the feed from the context
        context.delete(feed)
        
        // 2. Save the context to persist the changes
        try context.save()
        markAsUpdated()
    }

    // MARK: - CRUD for Folder

    /**
     Inserts a Folder object if it does not already exist.
     - Parameters:
       - folder: The Folder object to insert.
       - context: The ModelContext to perform the operation.
     - Throws: An error if saving to the context fails.
     */
    func insertFolder(_ folder: Folder, in context: ModelContext) async throws {
        // 1. Get the folder name before creating the predicate
        let folderName = folder.name
        
        // 2. Check if a folder with the same name already exists
        let descriptor = FetchDescriptor<Folder>(predicate: #Predicate<Folder> { existingFolder in
            existingFolder.name == folderName
        })
        
        let existingFolders = try context.fetch(descriptor)
        guard existingFolders.isEmpty else { return }
        
        // 3. Insert the new folder
        context.insert(folder)
        try context.save()
        markAsUpdated()
    }

    
    /**
     Fetches all Folder objects from the context.
     - Parameter context: The ModelContext to perform the operation.
     - Returns: An array of Folder objects.
     - Throws: An error if fetching from the context fails.
     */
    func fetchFolders(in context: ModelContext) async throws -> [Folder] {
        let descriptor = FetchDescriptor<Folder>() // No predicate to fetch all folders
        return try context.fetch(descriptor)
    }

    
    /**
     Deletes a Folder object from the context.
     - Parameters:
       - folder: The Folder object to delete.
       - context: The ModelContext to perform the operation.
     - Throws: An error if saving to the context fails.
     */
    func deleteFolder(_ folder: Folder, in context: ModelContext) async throws {
        // 1. Remove the folder from the context
        context.delete(folder)
        
        // 2. Save the context to persist the changes
        try context.save()
        markAsUpdated()
    }

    // MARK: - CRUD for Entry

    /**
     Inserts an Entry object if it does not already exist.
     - Parameters:
       - entry: The Entry object to insert.
       - context: The ModelContext to perform the operation.
     - Throws: An error if saving to the context fails.
     */
    func insertEntry(_ entry: Entry, in context: ModelContext) async throws {
        // 1. Get the entry ID before creating the predicate
        let entryId = entry.id
        
        // 2. Check if an entry with the same ID already exists
        let descriptor = FetchDescriptor<Entry>(predicate: #Predicate<Entry> { existingEntry in
            existingEntry.id == entryId
        })
        
        let existingEntries = try context.fetch(descriptor)
        guard existingEntries.isEmpty else { return }
        
        // 3. Insert the new entry
        context.insert(entry)
        try context.save()
        markAsUpdated()
    }

    
    /**
     Fetches all Entry objects from the context.
     - Parameter context: The ModelContext to perform the operation.
     - Returns: An array of Entry objects.
     - Throws: An error if fetching from the context fails.
     */
    func fetchEntries(in context: ModelContext) async throws -> [Entry] {
        let descriptor = FetchDescriptor<Entry>() // No predicate to fetch all entries
        return try context.fetch(descriptor)
    }
    
    
    /**
     Deletes an Entry object from the context.
     - Parameters:
       - entry: The Entry object to delete.
       - context: The ModelContext to perform the operation.
     - Throws: An error if saving to the context fails.
     */
    func deleteEntry(_ entry: Entry, in context: ModelContext) async throws {
        // 1. Remove the entry from the context
        context.delete(entry)
        
        // 2. Save the context to persist the changes
        try context.save()
        markAsUpdated()
    }
}
