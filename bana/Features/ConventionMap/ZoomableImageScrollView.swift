//
//  ZoomableImageScrollView.swift
//  bana
//
//  UIScrollView-backed zoomable and pannable image view.
//

import SwiftUI
import UIKit

/// Zoom and pan state reported to the host for hit-testing and overlay layout.
struct ZoomableImageState {
    var contentOffset: CGPoint
    var zoomScale: CGFloat
    var contentSize: CGSize
    var imageSize: CGSize
}

/// Converts a tap in scroll view coordinates to image (content) coordinates.
func imagePoint(fromScrollViewTap tap: CGPoint, contentOffset: CGPoint, zoomScale: CGFloat) -> CGPoint {
    guard zoomScale > 0 else { return .zero }
    return CGPoint(
        x: (contentOffset.x + tap.x) / zoomScale,
        y: (contentOffset.y + tap.y) / zoomScale
    )
}

final class ZoomableImageScrollViewCoordinator: NSObject, UIScrollViewDelegate {
    var onStateChange: ((ZoomableImageState) -> Void)?
    var onTapInImage: ((CGPoint) -> Void)?
    private weak var scrollView: UIScrollView?
    private var imageSize: CGSize = .zero

    func setImageSize(_ size: CGSize) {
        imageSize = size
    }

    func setScrollView(_ sv: UIScrollView?) {
        scrollView = sv
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        reportState(scrollView: scrollView)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        reportState(scrollView: scrollView)
    }

    private func reportState(scrollView: UIScrollView) {
        onStateChange?(ZoomableImageState(
            contentOffset: scrollView.contentOffset,
            zoomScale: scrollView.zoomScale,
            contentSize: scrollView.contentSize,
            imageSize: imageSize
        ))
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let sv = scrollView, gesture.state == .ended else { return }
        let tap = gesture.location(in: sv)
        let imagePoint = imagePoint(
            fromScrollViewTap: tap,
            contentOffset: sv.contentOffset,
            zoomScale: sv.zoomScale
        )
        onTapInImage?(imagePoint)
    }

    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let sv = scrollView else { return }
        if sv.zoomScale > sv.minimumZoomScale + 0.01 {
            sv.setZoomScale(sv.minimumZoomScale, animated: true)
        } else {
            let center = gesture.location(in: sv)
            let rect = CGRect(x: center.x - 40, y: center.y - 40, width: 80, height: 80)
            sv.zoom(to: rect, animated: true)
        }
    }
}

struct ZoomableImageScrollView: UIViewRepresentable {

    let image: UIImage?
    @Binding var state: ZoomableImageState?
    var onTapInImage: ((CGPoint) -> Void)?
    @Binding var recenterTrigger: Bool
    @Binding var centerOnHyattTrigger: Bool

    func makeCoordinator() -> ZoomableImageScrollViewCoordinator {
        let c = ZoomableImageScrollViewCoordinator()
        c.onTapInImage = onTapInImage
        return c
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 4.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bouncesZoom = true

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.tag = 100

        scrollView.addSubview(imageView)
        context.coordinator.setScrollView(scrollView)

        if let img = image {
            let size = img.size
            context.coordinator.setImageSize(size)
            imageView.frame = CGRect(origin: .zero, size: size)
            scrollView.contentSize = size
            scrollView.zoomScale = 1.0
        }

        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(ZoomableImageScrollViewCoordinator.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tap)

        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(ZoomableImageScrollViewCoordinator.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)

        context.coordinator.onStateChange = { [weak scrollView] newState in
            DispatchQueue.main.async {
                state = newState
            }
        }

        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        guard let imageView = scrollView.viewWithTag(100) as? UIImageView else { return }
        if imageView.image != image {
            imageView.image = image
            if let img = image {
                let size = img.size
                context.coordinator.setImageSize(size)
                imageView.frame = CGRect(origin: .zero, size: size)
                scrollView.contentSize = size
            }
        }

        if recenterTrigger {
            recenterTrigger = false
            fitToBounds(scrollView: scrollView, imageView: imageView)
        }
        if centerOnHyattTrigger, let img = image {
            centerOnHyattTrigger = false
            let rect = HotspotRectNormalized(x: 0.42, y: 0.38, width: 0.12, height: 0.08)
            let centerX = (rect.x + rect.width / 2) * img.size.width
            let centerY = (rect.y + rect.height / 2) * img.size.height
            centerOn(scrollView: scrollView, imageSize: img.size, imagePointX: CGFloat(centerX), imagePointY: CGFloat(centerY))
        }
    }

    private func fitToBounds(scrollView: UIScrollView, imageView: UIImageView) {
        let bounds = scrollView.bounds.size
        let size = imageView.image?.size ?? imageView.frame.size
        guard size.width > 0, size.height > 0 else { return }
        let scaleW = bounds.width / size.width
        let scaleH = bounds.height / size.height
        let scale = min(scaleW, scaleH, 1.0)
        scrollView.minimumZoomScale = min(0.5, scale)
        scrollView.setZoomScale(scale, animated: true)
        scrollView.contentOffset = .zero
    }

    private func centerOn(scrollView: UIScrollView, imageSize: CGSize, imagePointX: CGFloat, imagePointY: CGFloat) {
        let scale = scrollView.zoomScale
        let targetX = imagePointX * scale - scrollView.bounds.width / 2
        let targetY = imagePointY * scale - scrollView.bounds.height / 2
        let offset = CGPoint(
            x: max(0, min(targetX, scrollView.contentSize.width - scrollView.bounds.width)),
            y: max(0, min(targetY, scrollView.contentSize.height - scrollView.bounds.height))
        )
        scrollView.setContentOffset(offset, animated: true)
    }
}
