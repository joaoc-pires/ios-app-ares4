//
//  DataManager.swift
//  Ares
//
//  Created by Joao Pires on 21/01/2025.
//

import Foundation
import SwiftData

final class DataManager {
    static let shared = DataManager()

    private init() {}

    // MARK: - CRUD for Feed

    
    /**
     Inserts a Feed object if it does not already exist.
     - Parameters:
       - feed: The Feed object to insert.
       - context: The ModelContext to perform the operation.
     - Throws: An error if saving to the context fails.
     */
    func insertFeed(_ feed: UnownedFeed, in context: ModelContext) async throws {
        // 1. Check if a feed with the same URL already exists
        let descriptor = FetchDescriptor<Feed>(predicate: #Predicate<Feed> { existingFeed in
            existingFeed.id == feed.id
        })
        
        let existingFeeds = try context.fetch(descriptor)
        guard existingFeeds.isEmpty else { return }
        
        // 2. Create and insert the new feed by converting UnownedFeed to Feed
        let newFeed = Feed(from: feed, and: feed.entries)
        
        // 3. Insert into SwiftData context and save
        context.insert(newFeed)
        try context.save()
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
        // 1. Check if a folder with the same name or unique identifier already exists
        let descriptor = FetchDescriptor<Folder>(predicate: #Predicate<Folder> { existingFolder in
            existingFolder.id == folder.id
        })
        
        let existingFolders = try context.fetch(descriptor)
        guard existingFolders.isEmpty else { return }
        
        // 2. Insert the new folder
        context.insert(folder)
        
        // 3. Save the context to persist the changes
        try context.save()
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
        // 1. Check if an entry with the same unique identifier already exists
        let descriptor = FetchDescriptor<Entry>(predicate: #Predicate<Entry> { existingEntry in
            existingEntry.id == entry.id
        })
        
        let existingEntries = try context.fetch(descriptor)
        guard existingEntries.isEmpty else { return }
        
        // 2. Insert the new entry into the context
        context.insert(entry)
        
        // 3. Save the context to persist the changes
        try context.save()
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
    }
}
