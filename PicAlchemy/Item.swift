//
//  Item.swift
//  PicAlchemy
//
//  Created by Chen Cen on 1/21/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
