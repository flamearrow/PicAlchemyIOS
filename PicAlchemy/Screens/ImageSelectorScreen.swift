//
//  ImageSelectorScreen.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/4/25.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImageItem: Identifiable {
    let id: UUID
    let name: String
}

// Use an inline photos picker to show photos to select
struct ImageSelectorScreen : View {
    @ObservedObject var selectorVM: ImageSelectorVM
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PhotosPicker(
                selection: $selectorVM.selectedImage,
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
                    print("BGLM - clicked")
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
        
        
//        ScrollView {
//            LazyVGrid(
//                columns: Array(
//                    repeating: .init(.flexible(minimum: 100)), count: 3
//                    ),
//                spacing: 100
//            ) {
//                ForEach($selection) { $item in
//                    
//                }
//            }
//        }
        
        
//        ScrollView {
//            LazyVGrid(
//                columns: Array(
//                    repeating:
//                        GridItem(.flexible(minimum: 100)),
//                    count: 3
//                ),
//                spacing: 100
//            ) {
//                ForEach($colums) { $item in
//                    NavigationLink(
//                        destination: DetailsView(
//                            item: $item
//                        )
//                    ) {
//                        Text("\(item.name)")
//                            .padding()
//                            .background(.red, in: RoundedRectangle(cornerRadius: 8))
//                    }
//                }
//            }
//        }
    }
}

#Preview {
    ImageSelectorScreen(selectorVM: .init())
}
