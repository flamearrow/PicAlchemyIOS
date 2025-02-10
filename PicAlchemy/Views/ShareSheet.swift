//
//  ShareSheet.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/10/25.
//
import SwiftUI

// Share items to other apps, like the share intent on Android
//  this is used to share an UIImage to other apps
struct ShareSheet : UIViewControllerRepresentable {
    var activityItems: [Any]
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil)
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed.
    }
}
