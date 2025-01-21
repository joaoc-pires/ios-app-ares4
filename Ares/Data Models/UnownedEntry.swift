//
//  UnownedEntry.swift
//  Ares
//
//  Created by Joao Pires on 21/01/2025.
//

import Foundation
import AresCore

public typealias UnownedEntry = ARSCEntry

extension UnownedEntry {
    var displayTitle: String { title?.htmlDecoded ?? String() }
    var displayContent: String { content ?? String() }
    var displayAuthor: String { author ?? String() }
    var pubDate: Date { publishedDate ?? Date() }
    var baseURL: URL? {
        URL(string: "https://\(URL(string: publisherID)?.host() ?? String())")
    }
    var thumbnailURL: URL? {
        if let urlString = thumbnail?.replacingOccurrences(of: "http://", with: "https://"), let url = URL(string: urlString) {
            return url
        }
        return nil
    }
    
    var iconURL: URL? {
        if let linkURL = URL(string: publisherID),
           let host = linkURL.host(),
           let icon = URL(string: "https://icons.duckduckgo.com/ip3/\(host).ico") {
            return icon
        }
        return nil
    }
    
    public static func == (lhs: UnownedEntry, rhs: UnownedEntry) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var isVideo: Bool {
        return id.contains("https://www.youtube.com")
    }
}

extension UnownedEntry: VideoEntry {
    var videoId: String {
        var newId = id.replacingOccurrences(of: "yt:video:", with: "")
        newId = newId.replacingOccurrences(of: "https://www.youtube.com/watch?v=", with: "")
        return newId
    }
}
