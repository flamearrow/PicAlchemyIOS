//
//  Toast.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/10/25.
//

import SwiftUI

struct Toast: View {
    let msg: String
    var body: some View {
        Text(msg)
           .padding(.horizontal, 16)
           .padding(.vertical, 8)
           .background(Color.black.opacity(0.7))
           .foregroundColor(.white)
           .cornerRadius(8)
           .transition(.opacity)
           .zIndex(1)  // Ensure it appears above other views
    }
}
