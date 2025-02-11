//
//  FullscreenImageView.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/11/25.
//

import SwiftUI
import UIKit

struct FullscreenImageView: View {
    let image: UIImage
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var rotation: Angle = .zero
    @State private var lastRotation: Angle = .zero
    
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .aspectRatio(1, contentMode: .fit)
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
                            lastScale = 1.0
                            if scale < 1.0 {
                                scale = 1.0
                            } // Reset zoom if too small
                            if scale > 5.0 {
                                scale = 5.0
                            } // Limit max zoom
                            resetOffsetIfNeeded()
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
                            resetOffsetIfNeeded()
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
    
    // Reset Offset If More Than Half of Image Moves Out of Screen
    private func resetOffsetIfNeeded() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let imageWidth = screenWidth * scale
        let imageHeight = screenHeight * scale
        
        let maxOffsetX = (imageWidth - screenWidth) / 2
        let maxOffsetY = (imageHeight - screenHeight) / 2
        
        if abs(offset.width) > maxOffsetX / 2 || abs(offset.height) > maxOffsetY / 2 {
            withAnimation {
                offset = .zero
                lastOffset = .zero
            }
        }
    }
}

#Preview {
    FullscreenImageView(image: UIImage(named: "tora")!)
}
