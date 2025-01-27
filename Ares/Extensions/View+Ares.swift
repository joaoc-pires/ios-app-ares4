//
//  View+Ares.swift
//  Ares
//
//  Created by Joao Pires on 26/01/2025.
//

import SwiftUI

extension View {
    /// This is a workaround for the weird state behaviour toggles have since SwiftUI 2.0
    ///
    /// https://stackoverflow.com/questions/72321705/swiftui-issue-with-state-with-toggle-sheet
    func bindToModalContext<V>(_ value: V) -> some View where V : Equatable {
        self.onChange(of: value, { _, _ in })
    }
}
