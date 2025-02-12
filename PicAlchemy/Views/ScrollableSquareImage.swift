//
//  ScrollableSquareImage.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/12/25.
//

import SwiftUI

/// A Image with width of screen that corresponds to rotation, scaling and moving gesture and animates back to original when gesture released
struct ScrollableSquareImage: View {
    let uiImage: UIImage
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var rotation: Angle = .zero
    @State private var lastRotation: Angle = .zero
    
    
    var body: some View {
        Image(
            uiImage: uiImage
        )
        .alchemySqr()
        .scaleEffect(scale)
        .offset(offset)
        .rotationEffect(rotation)
        .simultaneousGesture(
            MagnificationGesture()
                .onChanged { value in
                    let delta = value / lastScale
                    scale *= delta
                    lastScale = value
                }
                .onEnded { _ in
                    withAnimation {
                        lastScale = 1.0
                        scale = 1.0
                    }
                }
        )
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    offset = CGSize(
                        width: lastOffset.width + value.translation.width,
                        height: lastOffset.height + value.translation.height
                    )
                }
                .onEnded { _ in
                    lastOffset = offset
                    withAnimation {
                        offset = .zero
                        lastOffset = .zero
                    }
                }
        )
        .simultaneousGesture(
            RotationGesture()
                .onChanged { value in
                    rotation = lastRotation + value
                }
                .onEnded { _ in
                    withAnimation {
                        rotation = .zero // Reset rotation when released
                    }
                    lastRotation = rotation
                }
        )
    }
}

#Preview {
    ScrollableSquareImage(uiImage: UIImage(named: "tora")!
    )
}
