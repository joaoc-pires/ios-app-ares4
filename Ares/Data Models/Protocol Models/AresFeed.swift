//
//  AresFeed.swift
//  Ares
//
//  Created by Joao Pires on 21/01/2025.
//

import Foundation

protocol AresFeed: Equatable, Hashable {
    var id: String { get }
    var displayName: String { get }
    var siteURL: URL? { get }
}
