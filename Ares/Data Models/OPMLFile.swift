//
//  OPMLFile.swift
//  Ares
//
//  Created by Joao Pires on 26/01/2025.
//


import SwiftUI
import UniformTypeIdentifiers

struct OPMLFile: FileDocument {
    static var readableContentTypes = [UTType.opml]
    
    var text = ""
    
    init(initialText: String = "") {
        text = initialText
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}