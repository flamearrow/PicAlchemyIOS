//
//  CircularButton.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/7/25.
//

import Foundation
import SwiftUI

struct CircularButton: View {
    enum Style {
        case large
        case small
    }
    let systemImage: String
    let style: Style
    var action: () -> Void = {}
    
    let largeSize: CGFloat = 60
    let largePadding: CGFloat = 14
    
    let smallSize: CGFloat = 40
    let smallPadding: CGFloat = 10
    
    var body: some View {
        switch(style) {
        case .large:
            Button(action: action) {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .padding(largePadding)
                    .frame(width: largeSize, height: largeSize)
                    .foregroundColor(.white)
                    .background(Color("AccentColor"))
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
        case .small:
            Button(action: action) {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .padding(smallPadding)
                    .frame(width: smallSize, height: smallSize)
                    .foregroundColor(.white)
                    .background(Color("AccentColor"))
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
        }
    }
}
