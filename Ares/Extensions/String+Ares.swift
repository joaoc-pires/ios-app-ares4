//
//  String+Ares.swift
//  Ares
//
//  Created by Joao Pires on 21/01/2025.
//

import Foundation
import SwiftSoup
import SwiftUI

extension String {
    var htmlDecoded: String {
        var result = self.replacingOccurrences(of: "&amp;", with: "&")
        result = result.replacingOccurrences(of: "&apos;", with:  "'")
        result = result.replacingOccurrences(of: "&lt;"  , with:  "<")
        result = result.replacingOccurrences(of: "&gt;"  , with:  ">")
        return result
    }
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    var firstImageLink: String? {
        guard let document: Document = try? SwiftSoup.parse(self) else { return nil }
        guard let image: SwiftSoup.Element = try? document.select("img").first() else { return nil }
        return try? image.attr("src")
    }
    
    var canHaveBanner: Bool {
        guard let document: Document = try? SwiftSoup.parse(self) else { return false }
        guard let image: SwiftSoup.Element = try? document.select("img").first() else { return false }
        let widthString = try? image.attr("width")
        let heightString = try? image.attr("height")
        let width = Int(widthString ?? "0") ?? 0
        let height = Int(heightString ?? "0") ?? 0
        if (width > 100) && (height > 100) && width > height {
            return true
        }
        let imageURL = try? image.attr("src")
        var regexResult = matches(for: "[0-9]+x[0-9]+", in: imageURL ?? String())
        for result in regexResult {
            let components = result.components(separatedBy: "x")
            let width = Int(components.first ?? "0") ?? 0
            let height = Int(components.last ?? "0") ?? 0
            if (width > 100) && (height > 100) && width > height {
                return true
            }
        }
        regexResult = matches(for: "[0-9]+&height=[0-9]+", in: imageURL ?? String())
        for result in regexResult {
            let components = result.components(separatedBy: "&height=")
            let width = Int(components.first ?? "0") ?? 0
            let height = Int(components.last ?? "0") ?? 0
            if (width > 100) && (height > 100) && width > height {
                return true
            }
        }
        return false
    }
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    static func emptyHTMLString(with colorScheme: ColorScheme, andTheme theme: ThemeType) -> String {
        """
        <html>
            <head>
                <style>
                body {
                    color: \(colorScheme == .dark ? "rgb(255, 255, 255)" : "rgb(0, 0, 0)");
                    font-family: -apple-system-body, BlinkMacSystemFont, sans-serif;
                    padding-right: 8px;
                    padding-left: 8px;
                }
                h1 {
                    font-weight: 950;
                }
                blockquote {
                    border-left: 2px solid \(theme.htmlString);
                    margin: 0px;
                    padding-left: 8px;
                }
                ul {
                    list-style-type: none;
                    padding: 0;
                    margin: 0;
                }
                a { color: \(theme.htmlString) }
                img {
                    max-width: 100%;
                    max-height: 100%;
                    padding-top: 10px;
                }
                figure {
                    padding: 0;
                    margin: 0;
                }
                figcaption {
                    border-left: 2px solid \(theme.htmlString);
                    font-size: 80%;
                }
                .ares_metadata p {
                    margin: 0;
                    padding: 0;
                    padding-bottom: 0;
                    font-size: 75%;
                    display: flex;
                    justify-content: space-between;
                    opacity: 0.5;
                }
                .alignleft {
                }
                .alignright {
                }
                .ares_content {
                }
                .feedflare {
                    display: none;
                }
            </style>
            </head>
            <body>
                $TITLE_CONTENT
                <div class="ares_content">
                $CONTENT
                </div>
            </body>
        </html>
        """
    }
    
    static func emtyVideoString(with colorScheme: ColorScheme, andTheme theme: ThemeType) -> String {
        """
        <html>
            <head>
                <style>
                body {
                    color: \(colorScheme == .dark ? "rgb(255, 255, 255)" : "rgb(0, 0, 0)");
                    font-family: -apple-system-body, BlinkMacSystemFont, sans-serif;
                    padding-right: 8px;
                    padding-left: 8px;
                    font-size: 16px;
                }
                h1 {
                    font-weight: 950;
                }
                blockquote {
                    border-left: 2px solid \(theme.color.hexaRGB);
                    margin: 0px;
                    padding-left: 8px;
                }
                ul {
                    list-style-type: none;
                    padding: 0;
                    margin: 0;
                }
                a { color: \(theme.color.hexaRGB) }
                img {
                    max-width: 100%;
                    max-height: 100%;
                    padding-top: 10px;
                }
                iframe {
                    width: 100%;
                    margin: 0 auto;
                    display: block;
                    border-style:none;
                }
                figure {
                    padding: 0;
                    margin: 0;
                }
                figcaption {
                    border-left: 2px solid \(theme.color.hexaRGB);
                    font-size: 80%;
                }
                .ares_metadata p {
                    margin: 0;
                    padding: 0;
                    padding-bottom: 0;
                    font-size: 75%;
                    display: flex;
                    justify-content: space-between;
                    opacity: 0.5;
                }
                .alignleft {
                }
                .alignright {
                }
                .ares_content {
                }
                .feedflare {
                    display: none;
                }
            </style>
            </head>
            <body>
                $TITLE_CONTENT
                <div class="ares_content">
                $CONTENT
                </div>
            </body>
        </html>
        """
    }
    
}

extension Optional where Wrapped == String {
    var safe: String {
        return self ?? String()
    }
}
