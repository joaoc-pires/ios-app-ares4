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
        let newFeed = Feed(from: feed, and: [])
    }

    /**
     Fetches all Feed objects from the context.
     - Parameter context: The ModelContext to perform the operation.
     - Returns: An array of Feed objects.
     - Throws: An error if fetching from the context fails.
     */
    func fetchFeeds(in context: ModelContext) async throws -> [Feed] {
        return []
    }

    /**
     Deletes a Feed object from the context.
     - Parameters:
       - feed: The Feed object to delete.
       - context: The ModelContext to perform the operation.
     - Throws: An error if saving to the context fails.
     */
    func deleteFeed(_ feed: Feed, in context: ModelContext) async throws {

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

    }

    /**
     Fetches all Folder objects from the context.
     - Parameter context: The ModelContext to perform the operation.
     - Returns: An array of Folder objects.
     - Throws: An error if fetching from the context fails.
     */
    func fetchFolders(in context: ModelContext) async throws -> [Folder] {
        []
    }

    /**
     Deletes a Folder object from the context.
     - Parameters:
       - folder: The Folder object to delete.
       - context: The ModelContext to perform the operation.
     - Throws: An error if saving to the context fails.
     */
    func deleteFolder(_ folder: Folder, in context: ModelContext) async throws {

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

    }

    /**
     Fetches all Entry objects from the context.
     - Parameter context: The ModelContext to perform the operation.
     - Returns: An array of Entry objects.
     - Throws: An error if fetching from the context fails.
     */
    func fetchEntries(in context: ModelContext) async throws -> [Entry] {
        return []
    }

    /**
     Deletes an Entry object from the context.
     - Parameters:
       - entry: The Entry object to delete.
       - context: The ModelContext to perform the operation.
     - Throws: An error if saving to the context fails.
     */
    func deleteEntry(_ entry: Entry, in context: ModelContext) async throws {

    }
}
