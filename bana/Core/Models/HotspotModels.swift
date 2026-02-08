//
//  HotspotModels.swift
//  bana
//
//  Convention Map (Illustrated) — hotspot model and category.
//

import Foundation
import CoreGraphics

// MARK: - Hotspot Category

enum HotspotCategory: String, Codable, CaseIterable {
    case hotel
    case restaurant
    case park
    case landmark

    var displayName: String {
        switch self {
        case .hotel: return "Hotels"
        case .restaurant: return "Restaurants"
        case .park: return "Parks"
        case .landmark: return "Landmarks"
        }
    }

    static var allCategory: String { "All" }
}

// MARK: - Normalized Rect (0..1)

struct HotspotRectNormalized: Codable, Equatable {
    let x: Double
    let y: Double
    let width: Double
    let height: Double

    /// Convert to absolute CGRect given image dimensions.
    func absoluteRect(imageWidth: CGFloat, imageHeight: CGFloat) -> CGRect {
        CGRect(
            x: x * imageWidth,
            y: y * imageHeight,
            width: width * imageWidth,
            height: height * imageHeight
        )
    }

    /// Hit-test: does normalized point (nx, ny) lie inside this rect?
    func containsNormalized(nx: Double, ny: Double) -> Bool {
        nx >= x && nx <= x + width && ny >= y && ny <= y + height
    }
}

// MARK: - Hotspot

struct Hotspot: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let category: HotspotCategory
    let address: String
    let description: String?
    let latitude: Double
    let longitude: Double
    let hotspotRectNormalized: HotspotRectNormalized

    /// Absolute rect for a given image size (for drawing or hit-test in image space).
    func absoluteRect(imageWidth: CGFloat, imageHeight: CGFloat) -> CGRect {
        hotspotRectNormalized.absoluteRect(imageWidth: imageWidth, imageHeight: imageHeight)
    }

    /// Hit-test in image coordinates: point (x, y) in image space.
    func contains(imagePointX: CGFloat, imagePointY: CGFloat, imageWidth: CGFloat, imageHeight: CGFloat) -> Bool {
        guard imageWidth > 0, imageHeight > 0 else { return false }
        let nx = Double(imagePointX / imageWidth)
        let ny = Double(imagePointY / imageHeight)
        return hotspotRectNormalized.containsNormalized(nx: nx, ny: ny)
    }
}

// MARK: - JSON Container

struct BellevueHotspotsPayload: Codable {
    let hotspots: [Hotspot]
}
