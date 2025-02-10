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
        VStack {
            // Compute the width available for the image.
            Group {
                switch(alchemyVM.targetState) {
                case .idle(let contentImage):
                    Image(uiImage: contentImage).alchemySqr()
                case .loading:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle()) // Spinner style
                        .fullScreenSqr()
                case .result(let contentImage, let resultImage):
                    if showOriginal {
                        Image(uiImage: contentImage).alchemySqr()
                    } else {
                        Image(uiImage: resultImage).alchemySqr()
                    }
                }
            }
            
            Spacer()
            
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
                    // no-op - toggle showOriginal
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
            .padding(.leading, 40)
            .padding(.trailing, 40)
            
            Spacer()
            
            ScrollView(.horizontal) {
                LazyHGrid(
                    rows: [
                        GridItem(.fixed(80)),
                        GridItem(.fixed(80))
                    ],
                    alignment: .top,
                    spacing: 8
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
                                .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                        }
                    }
                }
                .padding(.leading, 6)
                .padding(.trailing, 6)
                .frame(height: 172) // 2 rows + 1 spacing btn + 1 spacing below
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
    func alchemySqr()  -> some View {
        return self
            .resizable()
            .scaledToFill()
            .fullScreenSqr()
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private extension View {
    func fullScreenSqr() -> some View {
        let squareSize = UIScreen.main.bounds.width - 20
        return self.frame(width: squareSize, height: squareSize)
    }
}

#Preview {
    AlchemyView(selectedVM: .init(
        selectedImage: UIImage(named: "tora")
    ))
}
