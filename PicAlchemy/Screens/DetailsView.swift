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
    @State var uiImage: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = uiImage {
                Image(uiImage: image).resizable().scaledToFit().frame(width: 300, height: 300)
            } else {
                Image(systemName: "photo").resizable().scaledToFit().frame(width: 300, height: 300)
            }
        }
        .task {
            await loadImage()
        }

    }
    
    private func loadImage() async {
        guard let selectedImage = selectedVM.selectedImage else { return }
        do {
            
            if let data = try await selectedImage.loadTransferable(type: Data.self),
                let image = UIImage(data: data) {
                self.uiImage = image
            } else {
                self.uiImage = nil
            }
        } catch {
            // do nothing
            self.uiImage = nil
        }
        
    }
    
}

#Preview {
//    var previewBinding: Binding<ImageItem> {
//        .constant(.init(id: UUID(), name: "test123"))
//    }
    DetailsView(selectedVM: .init())
}


//struct Detilas_Previews: PreviewProvider {
//    static var previewBinding: Binding<ImageItem> {
//        .constant(.init(id: UUID(), name: "testItem"))
//    }
//
//    static var previews: some View {
//        DetailsView(item: previewBinding)
//    }
//}
