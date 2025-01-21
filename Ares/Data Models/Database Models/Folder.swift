//
//  Folder.swift
//  Ares
//
//  Created by Joao Pires on 21/01/2025.
//

import Foundation
import SwiftData

class Folder {
    @Attribute(.unique) var name: String
    
    init(name: String, feeds: [Feed] = []) {
        self.name = name
        self.feeds = feeds
    }
}
