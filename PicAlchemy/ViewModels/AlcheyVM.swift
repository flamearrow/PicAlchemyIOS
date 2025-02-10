//
//  AlchemyViewModel.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/6/25.
//

import Foundation
import UIKit
import OSLog

class AlcheyVM: ObservableObject {
    @Published var styleFileName: String? = nil
        
    @Published var resultImage: UIImage? = nil
    
    @Published var targetState: TargetViewState
    
    private lazy var styleTransfererTask: Task<StyleTransferer, Never> = Task.detached(priority: .userInitiated) {
        return StyleTransferer()
    }
    
    init(content: UIImage?) {
        guard let content = content else {
            fatalError("invalid content image")
        }
        self.targetState = .idle(contentImage: content)
    }
    

    let presetStyleNames = [
        "style0",
        "style1",
        "style2",
        "style3",
        "style4",
        "style5",
        "style6",
        "style7",
        "style8",
        "style9",
        "style10",
        "style11",
        "style12",
        "style13",
        "style14",
        "style15",
        "style16",
        "style17",
        "style18",
        "style19",
        "style20",
        "style21",
        "style22",
        "style23",
        "style24",
        "style25"
    ]
    
    // Save image to local storage
    func saveImage() {
        
    }
    
    // share
    func share() {
        
    }
    
    // MainActor required because self.resultImage needs to be updated on main thread
    @MainActor
    func selectStyle(content: UIImage, styleName: String) {
        let content: UIImage
        if case .idle(let contentImage) = targetState {
            content = contentImage
        } else if case .result(let contentImage, _) = targetState {
            content = contentImage
        } else {
            Logger.alchemyVM.info("Tapped another style while transferring")
            return
            
        }
        targetState = .loading
        guard let styleImage = UIImage(named: styleName) else {
            fatalError("Faithless Error: Style Image not found!")
        }
        
        Task {
            let styleTransferer = await self.styleTransfererTask.value // Off main thread, only calcualted once
            let resultImage = await styleTransferer.transferStyle(content: content, style: styleImage) // Off main thread, only calcualted once
            targetState = .result(contentImage: content, resultImage: resultImage)
        }
    }
}
