//
//  BANATheme.swift
//  bana
//
//  BANA 2026 Seattle — premium, culturally rich, high-contrast theme.
//

import SwiftUI

enum BANATheme {
    // Primary palette — professional yet warm
    static let accent = Color(red: 0.11, green: 0.36, blue: 0.55)      // Deep blue
    static let accentSecondary = Color(red: 0.55, green: 0.27, blue: 0.27) // Cultural maroon
    static let backgroundPrimary = Color(.systemBackground)
    static let backgroundSecondary = Color(.secondarySystemBackground)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary

    // High-contrast text (accessibility)
    static let textOnAccent = Color.white
    static let textOnDark = Color.white

    // Semantic
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red

    // Typography
    enum Fonts {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.semibold)
        static let title2 = Font.title2.weight(.semibold)
        static let title3 = Font.title3
        static let headline = Font.headline
        static let body = Font.body
        static let callout = Font.callout
        static let caption = Font.caption
        static let caption2 = Font.caption2
    }
}

// MARK: - View modifiers for consistent styling

struct BANAPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BANATheme.Fonts.headline)
            .foregroundColor(BANATheme.textOnAccent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(BANATheme.accent)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.9 : 1)
    }
}

struct BANASecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BANATheme.Fonts.headline)
            .foregroundColor(BANATheme.accent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(BANATheme.backgroundSecondary)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(BANATheme.accent, lineWidth: 1.5)
            )
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.9 : 1)
    }
}
