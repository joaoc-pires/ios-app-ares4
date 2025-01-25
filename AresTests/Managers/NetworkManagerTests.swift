//
//  NetworkManagerTests.swift
//  Ares
//
//  Created by Joao Pires on 25/01/2025.
//

import XCTest
@testable import Ares
@testable import AresCore

final class NetworkManagerTests: XCTestCase {
    // MARK: - Properties
    var sut: NetworkManager!
    var notificationCenter: NotificationCenter!
    var expectation: XCTestExpectation!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        sut = NetworkManager.shared
        notificationCenter = .default
        expectation = XCTestExpectation(description: "Network operation")
    }
    
    override func tearDown() {
        sut = nil
        notificationCenter = nil
        expectation = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testRefreshAllFeeds() {
        // Given
        let feeds = ["https://example1.com/feed", "https://example2.com/feed"]
        var receivedFeeds: [UnownedFeed]?
        
        // When
        notificationCenter.addObserver(forName: NotificationName.didFinishRefreshingAllFeeds, object: nil, queue: nil) { notification in
            receivedFeeds = notification.object as? [UnownedFeed]
            self.expectation.fulfill()
        }
        
        notificationCenter.post(name: NotificationName.refreshAllFeeds, object: feeds)
        
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(receivedFeeds)
        XCTAssertEqual(receivedFeeds?.count, feeds.count)
    }
    
    func testRefreshSingleFeed() {
        // Given
        let feed = "https://example.com/feed"
        var receivedFeed: UnownedFeed?
        
        // When
        notificationCenter.addObserver(forName: NotificationName.didFinishRefreshingFeed, object: nil, queue: nil) { notification in
            receivedFeed = notification.object as? UnownedFeed
            self.expectation.fulfill()
        }
        
        notificationCenter.post(name: NotificationName.refreshFeed, object: feed)
        
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(receivedFeed, "Received feed should not be nil")
    }
    
    func testRefreshFeedFailure() {
        // Given
        let invalidFeed = "invalid-url"
        var receivedError: Error?
        
        // When
        notificationCenter.addObserver(forName: NotificationName.didFailRefreshing, object: nil, queue: nil) { notification in
            receivedError = notification.object as? Error
            self.expectation.fulfill()
        }
        
        notificationCenter.post(name: NotificationName.refreshFeed, object: invalidFeed)
        
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(receivedError)
    }
}
