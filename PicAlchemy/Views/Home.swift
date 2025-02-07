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
                    print("BGLM - selected image")
                    navPath.append("details")
                }
                .navigationDestination(for: String.self) { value in
                    switch(value) {
                    case "details":
                        AlchemyView(selectedVM: selectorVM)
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
