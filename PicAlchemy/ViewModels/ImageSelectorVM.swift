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
    @Published var selectedImage: PhotosPickerItem? = nil {
        didSet {
//            print("BGLM - selected! \(selectedImage)")
        }
    }
    
    
    
}
