//
//  Feed.swift
//  Ares
//
//  Created by Joao Pires on 21/01/2025.
//

import Foundation
import AresCore
import SwiftData

@Model
class Feed {
    @Attribute(.unique) var id: String
    var title: String?
    var link: String?
    var subTitle: String?
    var pubDate: Date?
    var image: String?
    var notify = false
    var entries: [Entry]
    
    var feedURL: String? { id }
    var displayName: String {
        return title ?? String()
    }
    
    var hasIcon: Bool {
        image != nil && !(image?.isEmpty ?? true)
    }
    
    var iconURL: URL? {
        if let link,
           let linkURL = URL(string: link),
           let host = linkURL.host(),
           let icon = URL(string: "https://icons.duckduckgo.com/ip3/\(host).ico") {
            return icon
        }
        return nil
    }
    
    init(from feed: UnownedFeed, and entries: [UnownedEntry]) {
        self.id = feed.id
        self.entries = entries.map { Entry(from: $0) }
        self.title = feed.title
        self.link = feed.link
        self.subTitle = feed.subTitle
        self.pubDate = feed.pubDate
        self.image = feed.image
    }
}
