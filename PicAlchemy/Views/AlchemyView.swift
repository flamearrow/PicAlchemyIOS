//
//  AlchemyView.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/4/25.
//

import Foundation
import SwiftUI

enum TargetViewState {
    case loading
    case idle(contentImage: UIImage)
    case result(contentImage: UIImage, resultImage: UIImage)
}

struct AlchemyView: View {
    @ObservedObject var selectedVM: ImageSelectorVM
    @StateObject var alchemyVM: AlcheyVM
    @State var showOriginal: Bool
    
    init(selectedVM: ImageSelectorVM) {
        self._selectedVM = ObservedObject(wrappedValue: selectedVM)
        self._alchemyVM = StateObject(wrappedValue: AlcheyVM(content: selectedVM.selectedImage))
        self.showOriginal = false
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Compute the width available for the image.
                Group {
                    let imageWidth = geometry.size.width - (2 * 10)
                    switch(alchemyVM.targetState) {
                    case .idle(let contentImage):
                        Image(uiImage: contentImage).alchemySqr(width: imageWidth)
                    case .loading:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle()) // Spinner style
                            .frame(width: imageWidth, height: imageWidth)
                    case .result(let contentImage, let resultImage):
                        if showOriginal {
                            Image(uiImage: contentImage).alchemySqr(width: imageWidth)
                        } else {
                            Image(uiImage: resultImage).alchemySqr(width: imageWidth)
                        }
                    }
                }
                HStack {
                    CircularButton(systemImage:"square.and.arrow.down", style: .large) {
                        alchemyVM.saveImage()
                    }
                    
                    Spacer()
                    
                    SmallCircularButton(
                        systemImage: "star.leadinghalf.filled",
                        disabled:
                            // wooonky sytax to just check the enum is of type result
                            {
                                switch alchemyVM.targetState {
                                case .result(_, _):
                                    return false
                                default: return true
                                }
                            }()
                    ) {
                        alchemyVM.toggle()
                    }
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
                .padding(
                    .init(top: 30, leading: 40, bottom: 20, trailing: 40)
                )
                
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
        }
    }
    
}

private struct SquareImageModifier: ViewModifier {
    let imageWidth: CGFloat
    
    func body(content: Content) -> some View {
        // Add this to avoid warning
        let safeImageWidth = imageWidth.isFinite && imageWidth > 0 ? imageWidth : 100
        content
            .scaledToFill()
            .frame(width: safeImageWidth, height: safeImageWidth)
            .clipped() // Ensures any excess image content is cut off.
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
}

private extension Image {
    func alchemySqr(width: CGFloat)  -> some View {
        return self.resizable().modifier(SquareImageModifier(imageWidth: width))
    }
}

#Preview {
    AlchemyView(selectedVM: .init(
        selectedImage: UIImage(named: "tora")
    ))
}
