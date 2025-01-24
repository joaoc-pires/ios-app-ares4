//
//  NotificationName.swift
//  Ares
//
//  Created by Joao Pires on 24/01/2025.
//

import Foundation

enum NotificationName {
    static let refreshAllFeeds = Notification.Name("NetworkManager.refreshAllFeeds")
    static let refreshFeed = Notification.Name("NetworkManager.refreshFeed")
    static let didFinishRefreshingAllFeeds = Notification.Name("NetworkManager.didFinishRefreshingAllFeeds")
    static let didFinishRefreshingFeed = Notification.Name("NetworkManager.didFinishRefreshingFeed")
    static let didFailRefreshing = Notification.Name("NetworkManager.didFailRefreshing")
}
