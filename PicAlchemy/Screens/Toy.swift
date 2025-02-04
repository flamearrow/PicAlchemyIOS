//
//  Toy.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/4/25.
//

import Foundation
import SwiftUI

struct Toy: View {
    @ObservedObject var toyVm: ToyVM = .init()
//    @State var count = 0
    var body: some View {
        VStack {
            Text("Toy \(toyVm.counter)")
            Button("AddOne") {
                self.toyVm.counter += 1
//                count += 1
            }
        }
    }
}

#Preview {
    Toy()
}

