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
    
    @Published var targetState: TargetViewState
    
    @Published var showSavedMessage: Bool = false
    
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
        if case .idle(let contentImage) = targetState {
            content = contentImage
        } else if case .result(let contentImage, _) = targetState {
            content = contentImage
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
            let transformedContent = await content.transformedToScreenWidth()
            let resultImage = await styleTransferer.transferStyle(content: transformedContent, style: styleImage) // Off main thread, only calcualted once
            targetState = .result(contentImage: content, resultImage: resultImage)
        }
    }
}


private extension UIImage {
    
    func transformedToScreenWidth() async -> UIImage {
        let squareSize = await UIScreen.main.bounds.width - 20
        let targetSize = CGSize(width: squareSize, height: squareSize)
        return await transformed(to: targetSize)
    }
    
    // Creates a new UIImage with aspect fill scaling and rounded rectangle clipping on a separate thread
    private func transformed(to targetSize: CGSize) async -> UIImage {
        return await Task.detached(priority: .userInitiated) {
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { context in
                // Calculate the scale factor for aspect fill
                let scale = max(targetSize.width / self.size.width,
                                targetSize.height / self.size.height)
                let scaledWidth = self.size.width * scale
                let scaledHeight = self.size.height * scale
                
                // Center the image in the target rect
                let x = (targetSize.width - scaledWidth) / 2.0
                let y = (targetSize.height - scaledHeight) / 2.0
                
                let drawRect = CGRect(x: x, y: y, width: scaledWidth, height: scaledHeight)
                self.draw(in: drawRect)
            }
        }.value
    }
}
