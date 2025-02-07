//
//  AlchemyViewModel.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/6/25.
//

import Foundation
import UIKit

class AlcheyVM: ObservableObject {
    @Published var styleFileName: String? = nil
    
    let presetStyleNames = [
        "style0",
        "style1",
        "style2",
        "style3",
        "style4",
        "style5",
        "style6",
        "style7",
        "style8",
        "style9",
        "style10",
        "style11",
        "style12",
        "style13",
        "style14",
        "style15",
        "style16",
        "style17",
        "style18",
        "style19",
        "style20",
        "style21",
        "style22",
        "style23",
        "style24",
        "style25"
    ]
    
    var selectedStyle: UIImage? = nil {
        didSet {
            // trigger style transformation
        }
    }
    
    // Save image to local storage
    func saveImage() {
        
    }
    
    // toggle result and original image
    func toggle() {
        
    }
    
    // share
    func share() {
        
    }
    
    func selectStyle(styleName: String) {
        self.styleFileName = styleName
    }
}
