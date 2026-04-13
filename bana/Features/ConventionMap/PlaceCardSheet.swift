//
//  PlaceCardSheet.swift
//  bana
//
//  Bottom sheet place card for Convention Map hotspot tap.
//

import SwiftUI

struct PlaceCardSheet: View {
    let hotspot: Hotspot
    var onDismiss: () -> Void

    private var walkingDirectionsURL: URL? {
        let saddr = "\(ConventionMapConstants.hyattLatitude),\(ConventionMapConstants.hyattLongitude)"
        let daddr = "\(hotspot.latitude),\(hotspot.longitude)"
        return URL(string: "http://maps.apple.com/?saddr=\(saddr)&daddr=\(daddr)&dirflg=w")
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(hotspot.name)
                        .font(BANATheme.Fonts.title2)
                        .foregroundColor(BANATheme.textPrimary)

                    Text(hotspot.category.displayName)
                        .font(BANATheme.Fonts.caption)
                        .foregroundColor(BANATheme.textSecondary)

                    if let desc = hotspot.description, !desc.isEmpty {
                        Text(desc)
                            .font(BANATheme.Fonts.body)
                            .foregroundColor(BANATheme.textPrimary)
                    }

                    Text(hotspot.address)
                        .font(BANATheme.Fonts.callout)
                        .foregroundColor(BANATheme.textSecondary)

                    HStack(spacing: 12) {
                        if let url = walkingDirectionsURL {
                            Button(action: {
                                UIApplication.shared.open(url)
                            }) {
                                Label("Directions", systemImage: "figure.walk")
                            }
                            .buttonStyle(BANAPrimaryButtonStyle())
                        }

                        Button(action: copyAddress) {
                            Label("Copy Address", systemImage: "doc.on.doc")
                        }
                        .buttonStyle(BANASecondaryButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDismiss()
                    }
                    .foregroundColor(BANATheme.accent)
                }
            }
        }
    }

    private func copyAddress() {
        UIPasteboard.general.string = hotspot.address
    }
}
