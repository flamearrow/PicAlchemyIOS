//
//  DetailsView.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/4/25.
//

import Foundation
import SwiftUI

struct DetailsView: View {
    @Binding var item: ImageItem
    var body: some View {
        Text("item: \(item.name)")
    }
}

#Preview {
    var previewBinding: Binding<ImageItem> {
        .constant(.init(id: UUID(), name: "test123"))
    }
    DetailsView(item: previewBinding)
}


//struct Detilas_Previews: PreviewProvider {
//    static var previewBinding: Binding<ImageItem> {
//        .constant(.init(id: UUID(), name: "testItem"))
//    }
//
//    static var previews: some View {
//        DetailsView(item: previewBinding)
//    }
//}
