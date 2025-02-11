//
//  StyleTransferer.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/9/25.
//

import UIKit
import CoreML
// Vision is stupid enough to not take two images as input, has to use the raw CoreML APi
//import Vision

// Run Image style tranformation on Style Transferer
//  Model from https://www.kaggle.com/models/google/arbitrary-image-stylization-v1/tensorFlow1
//  Converted to CoreML through transferModel.py
// UIImage extensions stolen from https://github.com/hollance/CoreMLHelpers
struct StyleTransferer {
    private let styleTransferModel: StyleTransfererModel
    private let inputSize = 512
    private let styleSize = 256 // use as trained for best result
    init() {
        guard let styleTransferer = try? StyleTransfererModel(configuration: .init()) else {
            fatalError("Failed to load style transfer model")
        }
        self.styleTransferModel = styleTransferer
        
    }
    func transferStyle(content: UIImage, style: UIImage) async -> UIImage  {
        return await Task.detached(priority: .userInitiated) { // run on a different thread
            guard let contentBuffer = content.pixelBuffer(width: inputSize, height: inputSize), let styleBuffer = style.pixelBuffer(width: styleSize, height: styleSize) else {
                fatalError("Failed to convert UIImage to pixel buffer")
            }
            
            guard let prediction = try? styleTransferModel.prediction(content: contentBuffer, style: styleBuffer) else {
                fatalError("Failed to run style transfer model")
            }
            
            // raw output is MLMultiArray with [1, 512, 512, 3],
            //  the extension takes axes that points to the (chanel, width, height) dimension of the output
            guard let image = prediction.Identity.image(min: 0, max: 1.0, axes: (3, 1, 2)) else {
                fatalError("Failed to convert prediction to UIImage")
            }
            return image
        }.value
    }
}
