//
//  CameraPicker.swift
//  PicAlchemy
//
//  Created by Chen Cen on 2/6/25.
//

import SwiftUI

// Custom SwiftUI View to wrap UIImagePickerController to take a photo from camera
// It has a weired pattern to create a Coordinator to receive callbacks when camera is take/camera view is dismissed
struct CameraPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        
        init(parent: CameraPicker) {
            self.parent = parent
        }
        
        // Called when an image is selected - in this case from camera
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                self.parent.dismiss()
            }
        }
        
        // called when camera view is dismissed
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return .init(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        // only pick from camera
        picker.sourceType = .camera
        // use delegate to
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // no-op
    }
    
}

struct StarRating_Previews: PreviewProvider {
    static var previewBinding: Binding<UIImage?> {
            .constant(nil)
        }
    
    static var previews: some View {
        CameraPicker(image: previewBinding).ignoresSafeArea()
    }
}
