//
//  banaApp.swift
//  bana
//
//  BANA 2026 Seattle — app entry point with global theme.
//

import SwiftUI

@main
struct banaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(BANATheme.accent)
        }
    }
}
