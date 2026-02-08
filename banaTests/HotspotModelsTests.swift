//
//  HotspotModelsTests.swift
//  banaTests
//
//  Unit tests for hotspot JSON decoding and hit-testing.
//

import Foundation
import Testing
import CoreGraphics
@testable import bana

struct HotspotModelsTests {

    private static let minimalJSON = """
    {
      "hotspots": [
        {
          "id": "hyatt",
          "name": "Hyatt Regency Bellevue",
          "category": "hotel",
          "address": "900 Bellevue Way NE",
          "description": "Convention hotel",
          "latitude": 47.6163,
          "longitude": -122.2015,
          "hotspotRectNormalized": { "x": 0.4, "y": 0.3, "width": 0.1, "height": 0.08 }
        }
      ]
    }
    """

    @Test func decodeHotspotsJSON() throws {
        let data = Self.minimalJSON.data(using: .utf8)!
        let payload = try JSONDecoder().decode(BellevueHotspotsPayload.self, from: data)
        #expect(payload.hotspots.count == 1)
        #expect(payload.hotspots[0].id == "hyatt")
        #expect(payload.hotspots[0].category == HotspotCategory.hotel)
        #expect(payload.hotspots[0].hotspotRectNormalized.x == 0.4)
        #expect(payload.hotspots[0].hotspotRectNormalized.width == 0.1)
    }

    @Test func normalizedRectAbsoluteRect() {
        let r = HotspotRectNormalized(x: 0.2, y: 0.3, width: 0.15, height: 0.1)
        let abs = r.absoluteRect(imageWidth: 1000, imageHeight: 800)
        #expect(abs.origin.x == 200)
        #expect(abs.origin.y == 240)
        #expect(abs.width == 150)
        #expect(abs.height == 80)
    }

    @Test func normalizedRectContainsNormalized() {
        let r = HotspotRectNormalized(x: 0.2, y: 0.3, width: 0.2, height: 0.2)
        #expect(r.containsNormalized(nx: 0.25, ny: 0.35) == true)
        #expect(r.containsNormalized(nx: 0.2, ny: 0.3) == true)
        #expect(r.containsNormalized(nx: 0.4, ny: 0.5) == true)
        #expect(r.containsNormalized(nx: 0.41, ny: 0.5) == false)
        #expect(r.containsNormalized(nx: 0.1, ny: 0.35) == false)
    }

    @Test func hotspotHitTestMapsTapToSelection() {
        let r = HotspotRectNormalized(x: 0.4, y: 0.38, width: 0.12, height: 0.08)
        let hotspot = Hotspot(
            id: "hyatt",
            name: "Hyatt",
            category: .hotel,
            address: "900 Bellevue Way NE",
            description: nil,
            latitude: 47.6163,
            longitude: -122.2015,
            hotspotRectNormalized: r
        )
        let imageWidth: CGFloat = 1000
        let imageHeight: CGFloat = 800
        // Center of rect in image space
        let centerX: CGFloat = 460
        let centerY: CGFloat = 336
        #expect(hotspot.contains(imagePointX: centerX, imagePointY: centerY, imageWidth: imageWidth, imageHeight: imageHeight) == true)
        #expect(hotspot.contains(imagePointX: 100, imagePointY: 100, imageWidth: imageWidth, imageHeight: imageHeight) == false)
    }
}
