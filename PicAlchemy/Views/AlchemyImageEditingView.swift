//
//  AlchemyImageView.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/12/25.
//

import SwiftUI


/// Fixed image view that zoom/moves the image
struct AlchemyImageEditingView: View {
    let uiImage: UIImage
    @ObservedObject var alchemyVM: AlchemyVM
    var body: some View {
        InnerImage(uiImage: uiImage, alchemyVM: alchemyVM)
            .fullScreenSqr()
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private struct InnerImage: View {
        let uiImage: UIImage
        @ObservedObject var alchemyVM: AlchemyVM
        
        var body: some View {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .scaleEffect(alchemyVM.scale)
                .offset(alchemyVM.offset)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / alchemyVM.lastScale
                            alchemyVM.lastScale = value
                            alchemyVM.scale *= delta
                        }
                        .onEnded { _ in
                            alchemyVM.lastScale = 1.0
                            resetOffsetIfNeeded()
                        }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            alchemyVM.offset = CGSize(
                                width: alchemyVM.lastOffset.width + value.translation.width,
                                height: alchemyVM.lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { value in
                            alchemyVM.lastOffset = alchemyVM.offset
                            resetOffsetIfNeeded()
                        }
                )
                .onTapGesture {
                    // Reset to original size and position on double tap
                    withAnimation {
                        alchemyVM.scale = 1.0
                        alchemyVM.offset = .zero
                        alchemyVM.lastScale = 1.0
                        alchemyVM.lastOffset = .zero
                    }
                }
        }
        
        // Reset Offset If More Than Half of Image Moves Out of Screen
        private func resetOffsetIfNeeded() {
            // Container (square view) side length.
            let squareSize = UIScreen.main.bounds.width - 20
            
            // Get the image’s intrinsic size.
            let imageSize = uiImage.size
            
            // Compute the factor used by scaledToFill so the image completely fills the square.
            let factor = max(squareSize / imageSize.width, squareSize / imageSize.height)
            
            // Calculate the displayed dimensions after applying scaledToFill and your scale effect.
            let imageWidth = imageSize.width * factor * alchemyVM.scale
            let imageHeight = imageSize.height * factor * alchemyVM.scale
            
            // If the image becomes too small to cover the square view, reset to defaults.
            if imageWidth < squareSize || imageHeight < squareSize {
                withAnimation {
                    alchemyVM.scale = 1.0
                    alchemyVM.offset = .zero
                    alchemyVM.lastScale = 1.0
                    alchemyVM.lastOffset = .zero
                }
                return
            }
            
            // Compute the maximum allowed offset for each axis.
            let maxOffsetX = (imageWidth - squareSize) / 2
            let maxOffsetY = (imageHeight - squareSize) / 2
            
            // Clamp the current offset values.
            var newOffset = alchemyVM.offset
            newOffset.width = min(max(alchemyVM.offset.width, -maxOffsetX), maxOffsetX)
            newOffset.height = min(max(alchemyVM.offset.height, -maxOffsetY), maxOffsetY)
            
            // Animate the adjustment if necessary.
            if newOffset != alchemyVM.offset {
                withAnimation {
                    alchemyVM.offset = newOffset
                    alchemyVM.lastOffset = newOffset
                }
            }
        }
    }
}

#Preview {
    AlchemyImageEditingView(uiImage: UIImage(named:"tora")!, alchemyVM: .init(content: UIImage(named:"tora")!))
}

