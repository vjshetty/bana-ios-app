//
//  ConventionMapViewModel.swift
//  bana
//
//  View model for Convention Map (Illustrated): filtered hotspots, selection, UI state.
//

import Foundation
import SwiftUI

/// Hyatt Regency Bellevue — used for "Directions from Hyatt" and "Recenter to Hyatt".
enum ConventionMapConstants {
    static let hyattLatitude = 47.6163
    static let hyattLongitude = -122.2015
    static let hyattName = "Hyatt Regency Bellevue"
}

@MainActor
final class ConventionMapViewModel: ObservableObject {

    @Published private(set) var hotspots: [Hotspot] = []
    @Published var selectedCategory: String = HotspotCategory.allCategory
    @Published var selectedHotspot: Hotspot?
    @Published var showHotspotsOverlay: Bool = true
    @Published var errorMessage: String?

    private let repository: HotspotRepository

    var categoryOptions: [String] {
        [HotspotCategory.allCategory] + HotspotCategory.allCases.map(\.displayName)
    }

    var filteredHotspots: [Hotspot] {
        if selectedCategory == HotspotCategory.allCategory {
            return hotspots
        }
        return hotspots.filter { $0.category.displayName == selectedCategory }
    }

    var hyattHotspot: Hotspot? {
        hotspots.first { $0.id == "hyatt" }
    }

    init(repository: HotspotRepository = HotspotRepository()) {
        self.repository = repository
        loadHotspots()
    }

    func loadHotspots() {
        do {
            hotspots = try repository.loadHotspots()
            errorMessage = nil
        } catch {
            hotspots = []
            errorMessage = "Could not load map hotspots."
        }
    }

    func selectHotspot(_ hotspot: Hotspot?) {
        selectedHotspot = hotspot
    }

    func clearSelection() {
        selectedHotspot = nil
    }

    /// Resolve which hotspot (if any) was tapped. Tap is in scroll view content coordinates (same as image when zoom scale and offset are applied).
    /// - Parameters:
    ///   - tapX: tap location X in content (image) space
    ///   - tapY: tap location Y in content (image) space
    ///   - imageWidth: full image width
    ///   - imageHeight: full image height
    /// - Returns: First matching hotspot (front-most if overlapping), or nil.
    func hotspot(atTapContentPoint tapX: CGFloat, tapY: CGFloat, imageWidth: CGFloat, imageHeight: CGFloat) -> Hotspot? {
        filteredHotspots.first { $0.contains(imagePointX: tapX, imagePointY: tapY, imageWidth: imageWidth, imageHeight: imageHeight) }
    }
}
