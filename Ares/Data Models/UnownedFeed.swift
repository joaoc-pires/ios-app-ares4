//
//  UnownedFeed.swift
//  Ares
//
//  Created by Joao Pires on 21/01/2025.
//

import Foundation
import AresCore

public typealias UnownedFeed = ARSCFeed

extension UnownedFeed {
   
    var siteURL: URL? {
        URL(string: link ?? String())
    }
    
    var feedURL: String? { id }
    
    var displayName: String {
        return title ?? String()
    }
    
    var hasIcon: Bool {
        image != nil && !(image?.isEmpty ?? true)
    }
    
    var iconURL: URL? {
        if let urlString = image?.replacingOccurrences(of: "http://", with: "https://"), let iconURL = URL(string: urlString) {
            return iconURL
        }
        return nil
    }
    
    public static func == (lhs: UnownedFeed, rhs: UnownedFeed) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
