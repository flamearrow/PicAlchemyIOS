//
//  AlchemyView.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/4/25.
//

import Foundation
import SwiftUI

struct AlchemyView: View {
    @ObservedObject var selectedVM: ImageSelectorVM
    
    @StateObject var alchemyVM: AlcheyVM = .init()
    @State var showOriginal: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Compute the width available for the image.
                Group {
                    if let resultImage = alchemyVM.resultImage {
                        // MLGB - this is black
                        Image(uiImage: resultImage).alchemySqr(geometry: geometry)
                    } else {
                        
                        if showOriginal {
                            if let image = selectedVM.selectedImage {
                                Image(uiImage: image).alchemySqr(geometry: geometry)
                            } else {
                                Image("tora").alchemySqr(geometry: geometry)
                            }
                        } else {
                            Image(alchemyVM.styleFileName!).alchemySqr(geometry: geometry)
                            
                        }
                    }
                }
                HStack {
                    CircularButton(systemImage:"square.and.arrow.down", style: .large) {
                        alchemyVM.saveImage()
                    }
                    
                    Spacer()
                    
                    CircularButton(systemImage: "star.leadinghalf.filled", style: .small)
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    if !showOriginal {
                                        showOriginal = true
                                    }
                                }
                                .onEnded { _ in
                                    showOriginal = false
                                }
                        )
                    
                    Spacer()
                    CircularButton(systemImage:"square.and.arrow.up", style: .large) {
                        alchemyVM.share()
                    }
                }
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [
                        GridItem(.fixed(100)),
                        GridItem(.fixed(100))
                    ],spacing: 6
                    ) {
                        ForEach(alchemyVM.presetStyleNames, id:\.self) { name in
                            Button(action: {
                                alchemyVM.selectStyle(
                                    content: selectedVM.selectedImage!,
                                    styleName: name
                                )
                            }
                            ) {
                                Image(name)
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                            }
                        }
                    }.padding()
                }
            }
        }.navigationBarHidden(true)
    }
    
}

private struct SquareImageModifier: ViewModifier {
    let imageWidth: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: imageWidth, height: imageWidth)
            .clipped() // Ensures any excess image content is cut off.
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
}

private extension Image {
    func alchemySqr(geometry: GeometryProxy)  -> some View {
        let imageWidth = geometry.size.width - (2 * 10)
        return self.resizable().modifier(SquareImageModifier(imageWidth: imageWidth))
    }
}

#Preview {
    AlchemyView(selectedVM: .init())
}
