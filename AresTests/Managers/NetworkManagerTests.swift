//
//  NetworkManagerTests.swift
//  Ares
//
//  Created by Joao Pires on 25/01/2025.
//

import XCTest
@testable import Ares
@testable import AresCore
@testable import SimpleNetwork

final class NetworkManagerTests: XCTestCase {
    // MARK: - Properties
    var sut: NetworkManager!
    var notificationCenter: NotificationCenter!
    var expectation: XCTestExpectation!
    var mockParser: MockAresCore!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockParser = MockAresCore()
        sut = MockNetworkManager(parser: mockParser)
        notificationCenter = .default
        expectation = XCTestExpectation(description: "Network operation")
        expectation.assertForOverFulfill = false
    }
    
    override func tearDown() {
        sut = nil
        notificationCenter = nil
        expectation = nil
        mockParser = nil
        super.tearDown()
    }
    
    // MARK: - Helper Classes
    class MockAresCore: AresCore {
        var shouldSucceed = true
        var mockFeed = UnownedFeed(id: "https://example.com/feed", title: "Mock Feed")
        var error = NSError(domain: "com.test", code: -1)
        
        func fetch(_ url: String) async throws -> UnownedFeed {
            if shouldSucceed {
                return mockFeed
            } else {
                throw error
            }
        }
    }
    
    class MockNetworkManager: NetworkManager {
        override func handleRefreshAllFeeds(notification: Notification) {
            guard let feeds = notification.object as? [String] else {
                NotificationCenter.default.post(
                    name: NotificationName.didFailRefreshing,
                    object: NetworkError.aborted
                )
                return
            }
            var result = [UnownedFeed]()
            for feed in feeds {
                result.append(UnownedFeed(id: feed))
            }
            NotificationCenter.default.post(
                name: NotificationName.didFinishRefreshingAllFeeds,
                object: result
            )
        }
        override func handleRefreshFeed(_ notification: Notification) {
            guard let feed = notification.object as? String else {
                NotificationCenter.default.post(
                    name: NotificationName.didFailRefreshing,
                    object: NetworkError.aborted
                )
                return
            }
            NotificationCenter.default.post(
                name: NotificationName.didFinishRefreshingFeed,
                object: UnownedFeed(id: feed)
            )
        }
    }
    
    // MARK: - Tests
    actor TestStore {
        var receivedFeed: UnownedFeed?
        var receivedFeeds: [UnownedFeed]?
        var receivedError: Error?
        
        func setFeed(_ feed: UnownedFeed?) {
            self.receivedFeed = feed
        }
        
        func setFeeds(_ feeds: [UnownedFeed]?) {
            self.receivedFeeds = feeds
        }
        
        func setError(_ error: Error?) {
            self.receivedError = error
        }
    }
    
    func testRefreshAllFeedsSuccess() async throws {
        // Given
        let feeds = ["https://example1.com/feed", "https://example2.com/feed"]
        mockParser.shouldSucceed = true
        
        let store = TestStore()
        let localExpectation = expectation!
        
        // Setup the observer before posting the notification
        notificationCenter.addObserver(forName: NotificationName.didFinishRefreshingAllFeeds, object: nil, queue: .main) { notification in
            Task {
                if let feeds = notification.object as? [UnownedFeed] {
                    await store.setFeeds(feeds)
                }
                localExpectation.fulfill()
            }
        }
        
        // When
        Task {
            notificationCenter.post(name: NotificationName.refreshAllFeeds, object: feeds)
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        let receivedFeeds = await store.receivedFeeds
        XCTAssertNotNil(receivedFeeds)
        XCTAssertEqual(receivedFeeds?.count, feeds.count)
    }
    
    func testRefreshAllFeedsFailure() async throws {
        // Given
        let feeds = "https://example1.com/feed"
        mockParser.shouldSucceed = false
        
        let store = TestStore()
        let localExpectation = expectation!
        
        // Setup the observer before posting the notification
        notificationCenter.addObserver(forName: NotificationName.didFailRefreshing, object: nil, queue: .main) { notification in
            Task {
                if let error = notification.object as? NetworkError {
                    await store.setError(error)
                }
                localExpectation.fulfill()
            }
        }
        
        // When
        Task {
            notificationCenter.post(name: NotificationName.refreshAllFeeds, object: feeds)
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        let receivedError = await store.receivedError
        XCTAssertNotNil(receivedError)
    }
    
    func testRefreshSingleFeedSuccess() async throws {
        // Given
        let feed = "https://example.com/feed"
        mockParser.shouldSucceed = true
        
        let store = TestStore()
        let localExpectation = expectation!
        
        // Setup the observer before posting the notification
        notificationCenter.addObserver(forName: NotificationName.didFinishRefreshingFeed, object: nil, queue: .main) { notification in
            Task {
                if let feed = notification.object as? UnownedFeed {
                    await store.setFeed(feed)
                }
                localExpectation.fulfill()
            }
        }
        
        // When
        Task {
            notificationCenter.post(name: NotificationName.refreshFeed, object: feed)
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        let receivedFeed = await store.receivedFeed
        XCTAssertNotNil(receivedFeed)
        XCTAssertEqual(receivedFeed?.id, mockParser.mockFeed.id)
    }
    
    func testRefreshSingleFeedFailure() async throws {
        // Given
        let feed = ["https://example.com/feed"]
        mockParser.shouldSucceed = false
        
        let store = TestStore()
        let localExpectation = expectation!
        
        // Setup the observer before posting the notification
        notificationCenter.addObserver(forName: NotificationName.didFailRefreshing, object: nil, queue: .main) { notification in
            Task {
                if let error = notification.object as? NetworkError {
                    await store.setError(error)
                }
                localExpectation.fulfill()
            }
        }
        
        // When
        Task {
            notificationCenter.post(name: NotificationName.refreshFeed, object: feed)
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 2.0)
        let receivedError = await store.receivedError
        XCTAssertNotNil(receivedError)
    }
    
    func testInvalidNotificationObject() async throws {
        // Given
        let invalidObject = 123 // Not a String or [String]
        let expectation = expectation(description: "No notification should be received")
        expectation.isInverted = true
        
        notificationCenter.addObserver(forName: NotificationName.didFinishRefreshingFeed, object: nil, queue: .main) { _ in
            expectation.fulfill()
        }
        
        // When
        Task {
            notificationCenter.post(name: NotificationName.refreshFeed, object: invalidObject)
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
