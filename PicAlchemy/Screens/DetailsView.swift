//
//  DetailsView.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/4/25.
//

import Foundation
import SwiftUI

struct DetailsView: View {
    @ObservedObject var selectedVM: ImageSelectorVM
    
    var body: some View {
        Group {
            if let image = selectedVM.selectedImage {
                Image(uiImage: image).resizable().scaledToFit().frame(width: 300, height: 300)
            } else {
                Image(systemName: "photo").resizable().scaledToFit().frame(width: 300, height: 300)
            }
        }
    }
    
}

#Preview {
    DetailsView(selectedVM: .init())
}
