//
//  Logger+Extension.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/9/25.
//

import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
        private static var subsystem = Bundle.main.bundleIdentifier!

    static let alchemyVM = Logger(subsystem: subsystem, category: "alchemyVM")
}
