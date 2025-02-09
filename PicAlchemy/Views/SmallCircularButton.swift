//
//  SmallCircularButton.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/9/25.
//

import Foundation
import SwiftUI

struct SmallCircularButton: View {
    let systemImage: String
    let disabled: Bool
    let action: () -> Void
    
    let smallSize: CGFloat = 40
    let smallPadding: CGFloat = 10
    
    var body: some View {
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
    }
}

#Preview {
    SmallCircularButton(systemImage: "star.leadinghalf.filled", disabled: true){}
}
