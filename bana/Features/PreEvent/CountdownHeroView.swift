//
//  CountdownHeroView.swift
//  bana
//
//  Pre-Event home: countdown to BANA 2026 Seattle and primary CTAs.
//

import SwiftUI

struct CountdownHeroView: View {
    let convention: ConventionInfo
    var onRegister: (() -> Void)?
    var onHotel: (() -> Void)?
    var onMeetCommunity: (() -> Void)?

    private var daysText: String {
        let days = convention.daysUntilStart
        if days > 0 {
            return "\(days)"
        } else if days == 0 {
            return "0"
        } else {
            return "—"
        }
    }

    private var subtitleText: String {
        if convention.daysUntilStart > 0 {
            return convention.daysUntilStart == 1 ? "Day to go!" : "Days to go"
        } else if convention.daysUntilStart == 0 {
            return "It's here!"
        } else {
            return "See you next time"
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Hero: countdown
                VStack(spacing: 8) {
                    Text(convention.name)
                        .font(BANATheme.Fonts.title2)
                        .foregroundColor(BANATheme.textPrimary)
                        .multilineTextAlignment(.center)

                    Text(convention.tagline)
                        .font(BANATheme.Fonts.callout)
                        .foregroundColor(BANATheme.textSecondary)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(daysText)
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundColor(BANATheme.accent)
                        Text(subtitleText)
                            .font(BANATheme.Fonts.title3)
                            .foregroundColor(BANATheme.textSecondary)
                    }
                    .padding(.top, 8)

                    Text("\(convention.venueName), \(convention.venueCity)")
                        .font(BANATheme.Fonts.caption)
                        .foregroundColor(BANATheme.textSecondary)
                }
                .padding(.vertical, 24)

                // CTAs
                VStack(spacing: 12) {
                    Button(action: { onRegister?() }) {
                        Label("Register — Early Bird $\(convention.earlyBirdPriceAdult)/adult", systemImage: "person.badge.plus")
                    }
                    .buttonStyle(BANAPrimaryButtonStyle())

                    Button(action: { onHotel?() }) {
                        Label("Hotel — Hyatt Regency Bellevue", systemImage: "bed.double")
                    }
                    .buttonStyle(BANASecondaryButtonStyle())

                    Button(action: { onMeetCommunity?() }) {
                        Label("Meet the Community", systemImage: "person.3")
                    }
                    .buttonStyle(BANASecondaryButtonStyle())
                }
                .padding(.horizontal, 24)
            }
        }
        .background(BANATheme.backgroundPrimary)
    }
}

#Preview {
    CountdownHeroView(convention: .seattle2026)
}
