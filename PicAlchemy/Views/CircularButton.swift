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
    
    
    
    var body: some View {
        switch(style) {
        case .large:
            Button(action: action) {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .padding(14)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                    .background(Color("AccentColor"))
                    .clipShape(Circle())
                    .padding(40)
                    .shadow(radius: 10)
            }
        case .small:
            Button(action: action) {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .padding(10)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                    .background(Color("AccentColor"))
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
        }
    }
}
