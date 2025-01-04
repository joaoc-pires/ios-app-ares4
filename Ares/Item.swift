//
//  Item.swift
//  Ares
//
//  Created by Joao Pires on 04/01/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
