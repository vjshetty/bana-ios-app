//
//  HotspotOverlayView.swift
//  bana
//
//  Renders hotspot markers over the zoomable map; hit-testing is done by the parent.
//

import SwiftUI

/// Overlay that draws hotspot rectangles in image coordinate space, scaled by zoom and offset.
struct HotspotOverlayView: View {
    let hotspots: [Hotspot]
    let state: ZoomableImageState?
    let imageSize: CGSize

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            ZStack(alignment: .topLeading) {
                ForEach(hotspots) { hotspot in
                    let rect = viewRect(for: hotspot, in: size)
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(BANATheme.accent, lineWidth: 2)
                        .background(RoundedRectangle(cornerRadius: 6).fill(BANATheme.accent.opacity(0.2)))
                        .frame(width: max(24, rect.width), height: max(24, rect.height))
                        .position(x: rect.midX, y: rect.midY)
                }
            }
        }
        .allowsHitTesting(false)
    }

    /// Convert hotspot rect (normalized) to view rect: content point = image point * zoomScale, view point = content - contentOffset.
    private func viewRect(for hotspot: Hotspot, in viewSize: CGSize) -> CGRect {
        guard let state = state, state.zoomScale > 0, imageSize.width > 0, imageSize.height > 0 else {
            return .zero
        }
        let r = hotspot.hotspotRectNormalized
        let imageW = imageSize.width
        let imageH = imageSize.height
        let x = CGFloat(r.x) * imageW * state.zoomScale - state.contentOffset.x
        let y = CGFloat(r.y) * imageH * state.zoomScale - state.contentOffset.y
        let w = CGFloat(r.width) * imageW * state.zoomScale
        let h = CGFloat(r.height) * imageH * state.zoomScale
        return CGRect(x: x, y: y, width: w, height: h)
    }
}

extension CGRect {
    var midX: CGFloat { minX + width / 2 }
    var midY: CGFloat { minY + height / 2 }
}
