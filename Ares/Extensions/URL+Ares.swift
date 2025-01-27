//
//  URL+Ares.swift
//  Ares
//
//  Created by Joao Pires on 26/01/2025.
//

import Foundation

extension URL {
    static var documents: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    static var logFile: URL? {
        documents?.appendingPathComponent("logs").appendingPathComponent("Ares.log")
    }
}
