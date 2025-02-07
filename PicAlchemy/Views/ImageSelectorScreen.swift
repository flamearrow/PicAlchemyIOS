//
//  ImageSelectorScreen.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/4/25.
//

import Foundation
import SwiftUI
import PhotosUI

// Use an inline photos picker to show photos to select and take a picture from camera
struct ImageSelectorScreen : View {
    @ObservedObject var selectorVM: ImageSelectorVM
    @State private var showCamera: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PhotosPicker(
                selection: $selectorVM.pickedPhotoItem,
                matching: .images
            ) {
                Text("Select photos")
            }
            .photosPickerStyle(.inline)
            .photosPickerDisabledCapabilities(.selectionActions)
            .photosPickerAccessoryVisibility(.hidden, edges: .all)
            .ignoresSafeArea()
            
            Button(
                action: {
                    showCamera = true
                }
            ) {
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(16)
                    .foregroundColor(.white)
                    .background(Color("AccentColor"))
                    .clipShape(Circle())
            }
            .padding(36)
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker(image: $selectorVM.selectedImage).ignoresSafeArea()
        }
    }
}

#Preview {
    ImageSelectorScreen(selectorVM: .init())
}
