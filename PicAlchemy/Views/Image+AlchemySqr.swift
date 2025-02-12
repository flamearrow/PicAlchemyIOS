//
//  Image+AlchemySqr.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/12/25.
//

import SwiftUI

/// A square Image to occupy screen with and clip round corner
extension Image {
    func alchemySqr()  -> some View {
        return self
            .resizable()
            .scaledToFill()
            .fullScreenSqr()
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
