//
//  AresEntry.swift
//  Ares
//
//  Created by Joao Pires on 21/01/2025.
//

import Foundation

protocol AresEntry {
    var id: String { get }
    var displayContent: String { get }
    var displayTitle: String { get }
    var displayAuthor: String { get }
    var pubDate: Date { get }
    var thumbnail: String? { get }
    var baseURL: URL? { get }
    var isVideo: Bool { get }
}
