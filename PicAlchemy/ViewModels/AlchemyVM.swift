//
//  AlchemyVM.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/6/25.
//

import Foundation
import UIKit
import OSLog

// NSObject is requried for UIImageWriteToSavedPhotosAlbum to work
class AlchemyVM: NSObject, ObservableObject {
    @Published var styleFileName: String? = nil
    
    @Published var targetState: AlchemyState
    
    @Published var showSavedMessage: Bool = false
    
    @Published var scale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    @Published var offset: CGSize = .zero
    @Published var lastOffset: CGSize = .zero
    
    private lazy var styleTransfererTask: Task<StyleTransferer, Never> = Task.detached(priority: .userInitiated) {
        return StyleTransferer()
    }
    
    init(content: UIImage?) {
        guard let content = content else {
            fatalError("invalid content image")
        }
        self.targetState = .idle(contentImage: content)
    }
    
    
    let presetStyleNames = (0...29).map { "style\($0)" }
    
    // Save image to local storage
    func saveImage(
    ) {
        guard let resultImage = targetState.getResultImage() else {
            return
        }
        Task.detached(priority: .background) {
            UIImageWriteToSavedPhotosAlbum(resultImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)

        }
        
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            Logger.alchemyVM.info("error saving result image \(error.localizedDescription)")
        } else {
            Task {
                await MainActor.run {
                    showSavedMessage = true
                }
                try await Task.sleep(for: .seconds(2))
                await MainActor.run {
                    showSavedMessage = false
                }
            }
        }
    }
    
    // MainActor required because self.resultImage needs to be updated on main thread
    @MainActor
    func selectStyle(content: UIImage, styleName: String) {
        let content: UIImage
        let shouldTransform: Bool
        if case .idle(let contentImage) = targetState {
            content = contentImage
            shouldTransform = true
        } else if case .result(let contentImage, _) = targetState {
            content = contentImage
            // don't transform for .result - content is already transformed, user clicked another style
            shouldTransform = false
        } else {
            Logger.alchemyVM.info("Tapped another style while transferring")
            return
            
        }
        targetState = .loading
        guard let styleImage = UIImage(named: styleName) else {
            fatalError("Faithless Error: Style Image not found!")
        }
        
        Task {
            let styleTransferer = await self.styleTransfererTask.value // Off main thread, only calcualted once
            let transformedContent = shouldTransform ? await content.transformedToDisplayed(scale, offset) : content
            let resultImage = await styleTransferer.transferStyle(content: transformedContent, style: styleImage) // Off main thread, only calcualted once
            targetState = .result(contentImage: transformedContent, resultImage: resultImage)
        }
    }
}


private extension UIImage {
    
    /// Transform original UIImage based on the current scale and offset of Image shown
    func transformedToDisplayed(_ scale: CGFloat, _ offset: CGSize) async -> UIImage {
        let squareSize = await UIScreen.main.bounds.width - 20
        let targetSize = CGSize(width: squareSize, height: squareSize)
        return await transformed(to: targetSize, scale, offset)
    }
    
    // Creates a new UIImage with aspect fill scaling and rounded rectangle clipping on a separate thread
    private func transformed(to targetSize: CGSize, _ scale: CGFloat, _ offset: CGSize) async -> UIImage {
        return await Task.detached(priority: .userInitiated) {
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { context in
                // Get the intrinsic size of the underlying image.
                let imageSize = self.size
                
                // Compute the factor needed by .scaledToFill.
                // This ensures the image completely covers the square.
                let fillFactor = max(targetSize.width / imageSize.width,
                                     targetSize.height / imageSize.height)
                
                // Multiply the fill factor with your custom scale.
                let finalScale = fillFactor * scale
                
                // Calculate the new dimensions of the image.
                let newWidth = imageSize.width * finalScale
                let newHeight = imageSize.height * finalScale
                
                // In SwiftUI, your image is centered in the square view
                // and then offset by `offset`. Replicate that here.
                let originX = (targetSize.width - newWidth) / 2 + offset.width
                let originY = (targetSize.height - newHeight) / 2 + offset.height
                let drawRect = CGRect(x: originX, y: originY, width: newWidth, height: newHeight)
                
                // Draw the image into the context with the computed rectangle.
                self.draw(in: drawRect)
            }
        }.value
    }
}
