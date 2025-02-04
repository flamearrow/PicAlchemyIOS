//
//  ImageSelectorScreen.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/4/25.
//

import Foundation
import SwiftUI

struct ImageItem: Identifiable {
    let id: UUID
    let name: String
}

struct ImageSelectorScreen : View {
    @ObservedObject var vm = ImageSelectorVM()
    
    @State
    private var colums: [ImageItem] = [
        .init(id: .init(), name: "mlgb11"),
        .init(id: .init(), name: "mlgb12"),
        .init(id: .init(), name: "mlgb13"),
        .init(id: .init(), name: "mlgb21"),
        .init(id: .init(), name: "mlgb22"),
        .init(id: .init(), name: "mlgb23"),
        .init(id: .init(), name: "mlgb31"),
        .init(id: .init(), name: "mlgb32"),
        .init(id: .init(), name: "mlgb33"),
        .init(id: .init(), name: "mlgb41"),
        .init(id: .init(), name: "mlgb42"),
        .init(id: .init(), name: "mlgb43"),
        .init(id: .init(), name: "mlgb51"),
        .init(id: .init(), name: "mlgb52"),
        .init(id: .init(), name: "mlgb53"),
        .init(id: .init(), name: "mlgb61"),
        .init(id: .init(), name: "mlgb62"),
        .init(id: .init(), name: "mlgb63"),
        
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(
                    repeating:
                        GridItem(.flexible(minimum: 100)),
                    count: 3
                ),
                spacing: 100
            ) {
                ForEach($colums) { $item in
                    NavigationLink(
                        destination: DetailsView(
                            item: $item
                        )
                    ) {
                        Text("\(item.name)")
                            .padding()
                            .background(.red, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }
}

#Preview {
    ImageSelectorScreen()
}
