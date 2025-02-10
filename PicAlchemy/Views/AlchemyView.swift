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
    
    func isResult() -> Bool {
        switch self {
        case .result:
            return true
        default:
            return false
        }
    }
    
    func getContentImage() -> UIImage? {
        switch self {
        case .idle(let contentImage):
            return contentImage
        case .result(let contentImage, _):
            return contentImage
        default:
            return nil
        }
    }
    
    func getResultImage() -> UIImage? {
        switch self {
        case .result(_, let resultImage):
            return resultImage
        default:
            return nil
        }
    }
}

struct AlchemyView: View {
    @ObservedObject var selectedVM: ImageSelectorVM
    @StateObject var alchemyVM: AlcheyVM
    @State var showOriginal: Bool
    @State var shareResult: Bool
    init(selectedVM: ImageSelectorVM) {
        self._selectedVM = ObservedObject(wrappedValue: selectedVM)
        self._alchemyVM = StateObject(wrappedValue: AlcheyVM(content: selectedVM.selectedImage))
        self.showOriginal = false
        self.shareResult = false
    }
    
    var body: some View {
        ZStack {
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
                    CircularButton(
                        systemImage:"square.and.arrow.down",
                        style: .large,
                        disabled: !alchemyVM.targetState.isResult()
                    ) {
                        alchemyVM.saveImage()
                    }
                    
                    Spacer()
                    
                    CircularButton(
                        systemImage: "star.leadinghalf.filled",
                        style: .small,
                        disabled: !alchemyVM.targetState.isResult()
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
                    CircularButton(
                        systemImage:"square.and.arrow.up",
                        style: .large,
                        disabled: !alchemyVM.targetState.isResult()
                    ) {
                        shareResult = true
                    }
                }
                .padding(.leading, 40)
                .padding(.trailing, 40)
                
                Spacer()
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: true) {
                        LazyHGrid(
                            rows: [
                                GridItem(.fixed(80)),
                                GridItem(.fixed(80))
                            ],
                            alignment: .top,
                            spacing: 8
                        ) {
                            ForEach(Array(alchemyVM.presetStyleNames.enumerated()), id:\.element) { index, name in
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
                                }.onAppear {
                                    print("")
                                }
                                .id(index)
                            }
                        }
                        .padding(.leading, 6)
                        .padding(.trailing, 6)
                        .frame(height: 172) // 2 rows + 1 spacing btn + 1 spacing below
                    }.onAppear {
                        Task {
                            try await Task.sleep(for: .seconds(0.2))
                            // Calculate the center index (adjust as needed)
                            let centerIndex = alchemyVM.presetStyleNames.count / 2
                            // Animate the scroll to the center cell
                            withAnimation {
                                proxy.scrollTo(centerIndex, anchor: .center)
                            }
                        }
                    }
                }
            }.sheet(isPresented: $shareResult) {
                if let resultImage = alchemyVM.targetState.getResultImage() {
                    ShareSheet(activityItems: [resultImage])
                } else {
                    Text("No result available")
                }
            }
            if alchemyVM.showSavedMessage {
                Toast(msg: "Saved!")
            }
        }.animation(.easeInOut, value: alchemyVM.showSavedMessage)
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
