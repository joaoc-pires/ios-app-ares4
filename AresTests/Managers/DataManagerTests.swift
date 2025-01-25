//
//  DataManagerTests.swift
//  AresTests
//

import XCTest
import SwiftData
@testable import Ares

final class DataManagerTests: XCTestCase {
    var container: ModelContainer!
    var context: ModelContext!
    
    override func setUpWithError() throws {
        // Create an in-memory container for testing
        let schema = Schema([Feed.self, Folder.self, Entry.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        container = try ModelContainer(for: schema, configurations: [configuration])
        context = ModelContext(container)
    }
    
    override func tearDownWithError() throws {
        container = nil
        context = nil
    }
    
    // MARK: - Feed Tests
    
    func testInsertAndFetchFeed() async throws {
        // Create a test UnownedFeed
        let testFeed = UnownedFeed(id: "https://example.com/feed.xml", title: "Test Feed")
        
        // Insert the feed
        try await DataManager.shared.insertFeed(testFeed, in: context)
        
        // Fetch all feeds
        let feeds = try await DataManager.shared.fetchFeeds(in: context)
        
        // Verify
        XCTAssertEqual(feeds.count, 1)
        XCTAssertEqual(feeds.first?.id, testFeed.id)
        XCTAssertEqual(feeds.first?.title, testFeed.title)
    }
    
    func testDeleteFeed() async throws {
        // Create and insert a test feed
        let unownedFeed = UnownedFeed(id: "https://example.com/feed.xml", title: "Test Feed")
        let feed = Feed(from: unownedFeed, and: [])
        context.insert(feed)
        try context.save()
        
        // Delete the feed
        try await DataManager.shared.deleteFeed(feed, in: context)
        
        // Verify deletion
        let feeds = try await DataManager.shared.fetchFeeds(in: context)
        XCTAssertTrue(feeds.isEmpty)
    }
    
    // MARK: - Folder Tests
    
    func testInsertAndFetchFolder() async throws {
        // Create a test folder
        let folder = Folder(name: "Test Folder")
        
        // Insert the folder
        try await DataManager.shared.insertFolder(folder, in: context)
        
        // Fetch all folders
        let folders = try await DataManager.shared.fetchFolders(in: context)
        
        // Verify
        XCTAssertEqual(folders.count, 1)
        XCTAssertEqual(folders.first?.name, folder.name)
    }
    
    func testDeleteFolder() async throws {
        // Create and insert a test folder
        let folder = Folder(name: "Test Folder")
        context.insert(folder)
        try context.save()
        
        // Delete the folder
        try await DataManager.shared.deleteFolder(folder, in: context)
        
        // Verify deletion
        let folders = try await DataManager.shared.fetchFolders(in: context)
        XCTAssertTrue(folders.isEmpty)
    }
    
    // MARK: - Entry Tests
    
    func testInsertAndFetchEntry() async throws {
        // Create a test entry
        let unownedEntry = UnownedEntry(id: "test-entry", title: "Test Entry", publisherID: "https://example.com/publisher")
        let entry = Entry(from: unownedEntry)
        
        // Insert the entry
        try await DataManager.shared.insertEntry(entry, in: context)
        
        // Fetch all entries
        let entries = try await DataManager.shared.fetchEntries(in: context)
        
        // Verify
        XCTAssertEqual(entries.count, 1)
        XCTAssertEqual(entries.first?.id, entry.id)
        XCTAssertEqual(entries.first?.title, entry.title)
    }
    
    func testDeleteEntry() async throws {
        // Create and insert a test entry
        let unownedEntry = UnownedEntry(id: "test-entry", title: "Test Entry", publisherID: "https://example.com/publisher")
        let entry = Entry(from: unownedEntry)
        context.insert(entry)
        try context.save()
        
        // Delete the entry
        try await DataManager.shared.deleteEntry(entry, in: context)
        
        // Verify deletion
        let entries = try await DataManager.shared.fetchEntries(in: context)
        XCTAssertTrue(entries.isEmpty)
    }
}
