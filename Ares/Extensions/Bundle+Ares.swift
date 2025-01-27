//
//  Bundle+Ares.swift
//  Ares
//
//  Created by Joao Pires on 26/01/2025.
//

import Foundation

extension Bundle {
    
    var releaseVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? String()
    }
    
    var buildVersion: String {
        infoDictionary?["CFBundleVersion"] as? String  ?? String()
    }
    
    var currentVersion: String {
        var version = infoDictionary?["CFBundleShortVersionString"] as? String ?? String()
        version = version.replacingOccurrences(of: ".", with: "-")
        return version
    }
}
