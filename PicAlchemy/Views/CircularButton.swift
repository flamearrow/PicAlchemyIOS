//
//  CircularButton.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/9/25.
//

import Foundation
import SwiftUI

struct CircularButton: View {
    enum Style {
        case small
        case large
    }
    let systemImage: String
    let style: Style
    let disabled: Bool
    let action: () -> Void
    
    let largeSize: CGFloat = 60
    let largePadding: CGFloat = 14
    
    let smallSize: CGFloat = 40
    let smallPadding: CGFloat = 10
    
    var body: some View {
        switch(style) {
        case .small:
            Button(action: action) {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .padding(smallPadding)
                    .frame(width: smallSize, height: smallSize)
                    .foregroundColor(.white)
                    .background(disabled ? Color.gray : Color("AccentColor"))
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }.disabled(disabled)
        case .large:
            Button(action: action) {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .padding(largePadding)
                    .frame(width: largeSize, height: largeSize)
                    .foregroundColor(.white)
                    .background(disabled ? Color.gray : Color("AccentColor"))
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }.disabled(disabled)
        }
    }
}

#Preview("large") {
    CircularButton(systemImage: "star.leadinghalf.filled", style: .large, disabled: false){}
}
#Preview("small") {
    CircularButton(systemImage: "star.leadinghalf.filled", style: .small, disabled: true){}
}
