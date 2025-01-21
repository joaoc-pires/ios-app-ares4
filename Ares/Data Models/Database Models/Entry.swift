//
//  Entry.swift
//  Ares
//
//  Created by Joao Pires on 21/01/2025.
//

import Foundation
import SwiftData
import AresCore

@Model
class Entry {
    @Attribute(.unique) var id: String
    var entryURL: String?
    var title: String?
    var author: String?
    var content: String?
    var contentType: String?
    var publishedDate: Date?
    var thumbnail: String?
    var updatedDate: Date?
    var publisherID: String
    var read = false
    var saved = false
    
    var displayTitle: String { title?.htmlDecoded ?? String() }
    var displayContent: String { content ?? String() }
    var displayAuthor: String { author ?? String() }
    var pubDate: Date { publishedDate ?? Date() }
    var baseURL: URL? {
        URL(string: "https://\(URL(string: publisherID)?.host() ?? String())")
    }
    var thumbnailURL: URL? {
        guard (thumbnail != nil) else { return nil }
        if var urlString = thumbnail?.replacingOccurrences(of: "http://", with: "https://"), let url = URL(string: urlString) {
            if url.host() == nil, let host = URL(string: publisherID)?.host() {
                urlString = "https://\(host)/\(urlString)"
                return URL(string: urlString)
            }
            else {
                return url
            }
        }
        return nil
    }
    
    var isVideo: Bool {
        return entryURL?.contains("https://www.youtube.com") ?? false
    }

    init(from entry: UnownedEntry) {
        id = entry.id
        entryURL = entry.entryURL
        if let title = entry.title {
            self.title = title.htmlDecoded
        }
        author = entry.author
        content = entry.content
        contentType = entry.contentType
        publishedDate = entry.publishedDate
        thumbnail = entry.thumbnail
        updatedDate = entry.updatedDate
        publisherID = entry.publisherID
    }
}

extension Entry: VideoEntry {
    var videoId: String {
        var newId = id.replacingOccurrences(of: "yt:video:", with: "")
        newId = newId.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
        return newId
    }
}
