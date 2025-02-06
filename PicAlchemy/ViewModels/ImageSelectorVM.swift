//
//  File.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/4/25.
//

import Foundation
import UIKit
import _PhotosUI_SwiftUI
import PhotosUI

// Keep track of selected Image and notify details page
class ImageSelectorVM: ObservableObject {
    @Published var pickedPhotoItem: PhotosPickerItem? = nil {
        didSet {
            Task {
                await loadImage()
            }
        }
    }
    
    @Published var selectedImage: UIImage? = nil
    
    @MainActor
    private func loadImage() async {
        guard let photoItem = pickedPhotoItem else {return}
        
        do {
            if let data = try await photoItem.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                selectedImage = image
            } else {
                selectedImage = nil
            }
        } catch {
            selectedImage = nil
        }
    }
}
