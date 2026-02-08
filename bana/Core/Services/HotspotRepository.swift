//
//  HotspotRepository.swift
//  bana
//
//  Loads hotspot data from bundled bellevue_hotspots.json.
//

import Foundation

enum HotspotRepositoryError: Error {
    case fileNotFound
    case decodeFailed(Error)
}

final class HotspotRepository {

    private let filename: String
    private let bundle: Bundle

    init(filename: String = "bellevue_hotspots", bundle: Bundle = .main) {
        self.filename = filename
        self.bundle = bundle
    }

    /// Load hotspots from Resources/bellevue_hotspots.json in the app bundle.
    func loadHotspots() throws -> [Hotspot] {
        guard let url = bundle.url(forResource: filename, withExtension: "json", subdirectory: "Resources"),
              let data = try? Data(contentsOf: url) else {
            guard let url = bundle.url(forResource: filename, withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                throw HotspotRepositoryError.fileNotFound
            }
            return try decode(data)
        }
        return try decode(data)
    }

    private func decode(_ data: Data) throws -> [Hotspot] {
        do {
            let payload = try JSONDecoder().decode(BellevueHotspotsPayload.self, from: data)
            return payload.hotspots
        } catch {
            throw HotspotRepositoryError.decodeFailed(error)
        }
    }
}
