//
//  View+Fullscreen.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/12/25.
//

import SwiftUI

extension View {
    func fullScreenSqr() -> some View {
        let squareSize = UIScreen.main.bounds.width - 20
        return self.frame(width: squareSize, height: squareSize)
    }
}
