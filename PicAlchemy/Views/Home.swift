//
//  ContentView.swift
//  PicAlchemy
//
//  Created by Chen Cen on 1/21/25.
//

import SwiftUI
import SwiftData

// hosting image selection view and alchemy view
struct Home: View {
    
    @StateObject var selectorVM = ImageSelectorVM()
    
    @State var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ImageSelectorScreen(selectorVM: selectorVM)
                .onChange(of: selectorVM.selectedImage) {
                    guard selectorVM.selectedImage != nil else { return }
                    navPath.append("details")
                }
                .onChange(of: selectorVM.zoomResultImage) {
                    guard selectorVM.zoomResultImage != nil else { return }
                    navPath.append("zoomResultImage")
                }
                .navigationDestination(for: String.self) { value in
                    switch(value) {
                    case "details":
                        AlchemyView(selectedVM: selectorVM)
                            .navigationBarBackButtonHidden(false)
                    case "zoomResultImage":
                        FullscreenImageView(image: selectorVM.zoomResultImage!)
                            .navigationBarBackButtonHidden(false)
                            .onDisappear {
                                selectorVM.zoomResultImage = nil
                            }
                    default:
                        Text("Blah")
                    }
                }
        }
        
    }
}

#Preview {
    Home()
}
