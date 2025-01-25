//
//  NetworkManager.swift
//  Ares
//
//  Created by Joao Pires on 24/01/2025.
//

import Foundation
import AresCore
import SwiftData

class NetworkManager {
    // MARK: - Singleton
    static let shared = NetworkManager()
    
    // MARK: - Properties
    private let parser: AresCore

    // MARK: - Initialization
    init(parser: AresCore = AresCore()) {
        self.parser = parser
        setupNotificationObservers()
    }
    
    // MARK: - Setup
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(forName: NotificationName.refreshAllFeeds,   object: nil, queue: nil, using: handleRefreshAllFeeds)
        NotificationCenter.default.addObserver(forName: NotificationName.refreshFeed,       object: nil, queue: nil, using: handleRefreshFeed)
    }
    
    // MARK: - Notification Handlers
    func handleRefreshAllFeeds(notification: Notification) {
        guard let feeds = notification.object as? [String] else { return }
        refreshAllFeeds(feeds)
    }
    
    func handleRefreshFeed(_ notification: Notification) {
        guard let feed = notification.object as? String else { return }
        refreshFeed(feed)
    }
    
    // MARK: - Network Operations
    private func refreshAllFeeds(_ feeds: [String]) {
        Task {
            do {
                let unownedFeeds = try await withThrowingTaskGroup(of: UnownedFeed.self) { group in
                    for feedURL in feeds {
                        group.addTask {
                            return try await self.parser.fetch(feedURL)
                        }
                    }
                    
                    // Collect results
                    var results: [UnownedFeed] = []
                    for try await result in group {
                        results.append(result)
                    }
                    return results
                }
                NotificationCenter.default.post(
                    name: NotificationName.didFinishRefreshingAllFeeds,
                    object: unownedFeeds
                )
            } catch {
                NotificationCenter.default.post(
                    name: NotificationName.didFailRefreshing,
                    object: error
                )
            }
        }
    }
    
    private func refreshFeed(_ feedURL: String) {
        Task {
            do {
                let unownedFeed = try await parser.fetch(feedURL)
                NotificationCenter.default.post(
                    name: NotificationName.didFinishRefreshingFeed,
                    object: unownedFeed
                )
            } catch {
                NotificationCenter.default.post(
                    name: NotificationName.didFailRefreshing,
                    object: error
                )
            }
        }
    }
}
