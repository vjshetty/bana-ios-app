//
//  MapContainerView.swift
//  bana
//
//  Container with segmented control: Live Map | Convention Map (Illustrated).
//

import SwiftUI

enum MapMode: String, CaseIterable {
    case live = "Live Map"
    case convention = "Convention Map"
}

struct MapContainerView: View {
    @State private var selectedMode: MapMode = .convention

    var body: some View {
        VStack(spacing: 0) {
            Picker("Map", selection: $selectedMode) {
                ForEach(MapMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            switch selectedMode {
            case .live:
                LiveMapPlaceholderView()
            case .convention:
                ConventionMapIllustratedScreen()
            }
        }
        .navigationTitle(selectedMode == .convention ? "Convention Map" : "Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Placeholder for future MapKit live map.
private struct LiveMapPlaceholderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "map.fill")
                .font(.system(size: 60))
                .foregroundColor(BANATheme.textSecondary)
            Text("Live Map")
                .font(BANATheme.Fonts.title3)
            Text("MapKit live map can be added here.")
                .font(BANATheme.Fonts.caption)
                .foregroundColor(BANATheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BANATheme.backgroundSecondary)
    }
}
