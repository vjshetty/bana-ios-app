//
//  ConventionMapIllustratedScreen.swift
//  bana
//
//  Illustrated Downtown Bellevue map with zoom, pan, and tappable hotspots.
//

import SwiftUI
import UIKit

struct ConventionMapIllustratedScreen: View {
    @StateObject private var viewModel = ConventionMapViewModel()
    @State private var scrollState: ZoomableImageState?
    @State private var recenterTrigger = false
    @State private var centerOnHyattTrigger = false

    private let mapImage = UIImage(named: "bellevue_downtown_map")
    private var imageSize: CGSize { mapImage?.size ?? .zero }

    var body: some View {
        ZStack(alignment: .top) {
            if let image = mapImage {
                ZoomableImageScrollView(
                    image: image,
                    state: $scrollState,
                    onTapInImage: handleTapInImage,
                    recenterTrigger: $recenterTrigger,
                    centerOnHyattTrigger: $centerOnHyattTrigger,
                    hyattRectNormalized: viewModel.hyattHotspot?.hotspotRectNormalized
                )
                .overlay(
                    HotspotOverlayView(
                        hotspots: viewModel.showHotspotsOverlay ? viewModel.filteredHotspots : [],
                        state: scrollState,
                        imageSize: imageSize
                    )
                )
            } else {
                placeholderContent
            }

            controlsOverlay
        }
        .sheet(item: $viewModel.selectedHotspot) { hotspot in
            PlaceCardSheet(hotspot: hotspot) {
                viewModel.clearSelection()
            }
        }
    }

    private var placeholderContent: some View {
        VStack(spacing: 16) {
            Image(systemName: "map")
                .font(.system(size: 60))
                .foregroundColor(BANATheme.textSecondary)
            Text("Add bellevue_downtown_map.png to Assets")
                .font(BANATheme.Fonts.body)
                .foregroundColor(BANATheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BANATheme.backgroundSecondary)
    }

    private var controlsOverlay: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.categoryOptions, id: \.self) { option in
                        Button(action: { viewModel.selectedCategory = option }) {
                            Text(option)
                                .font(BANATheme.Fonts.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(viewModel.selectedCategory == option ? BANATheme.accent : BANATheme.backgroundSecondary)
                                .foregroundColor(viewModel.selectedCategory == option ? BANATheme.textOnAccent : BANATheme.textPrimary)
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 8)

            HStack(spacing: 12) {
                Button(action: { recenterTrigger = true }) {
                    Label("Recenter", systemImage: "arrow.up.left.and.arrow.down.right")
                        .font(BANATheme.Fonts.caption)
                }
                .buttonStyle(BANASecondaryButtonStyle())

                Button(action: { centerOnHyattTrigger = true }) {
                    Label("Hyatt", systemImage: "building.2")
                        .font(BANATheme.Fonts.caption)
                }
                .buttonStyle(BANASecondaryButtonStyle())

                Toggle(isOn: $viewModel.showHotspotsOverlay) {
                    Text("Hotspots")
                        .font(BANATheme.Fonts.caption)
                }
                .toggleStyle(SwitchToggleStyle(tint: BANATheme.accent))
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(BANATheme.backgroundPrimary.opacity(0.95))
    }

    private func handleTapInImage(_ imagePoint: CGPoint) {
        guard let hotspot = viewModel.hotspot(
            atTapContentPoint: imagePoint.x,
            tapY: imagePoint.y,
            imageWidth: imageSize.width,
            imageHeight: imageSize.height
        ) else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        viewModel.selectHotspot(hotspot)
    }
}

