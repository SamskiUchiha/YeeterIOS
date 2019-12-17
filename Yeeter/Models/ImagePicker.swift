//
//  ImagePicker.swift
//  Yeeter
//
//  Created by sam laitha on 12/3/19.
//  Copyright © 2019 Antonio Vega Jr. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class ImagePicker : ObservableObject {
    
    static let shared : ImagePicker = ImagePicker()

    private init() {}  //force using the singleton: ImagePicker.shared
    let view = ImagePicker.View()
    let coordinator = ImagePicker.Coordinator()

    // Bindable Object part
    let willChange = PassthroughSubject<Image?, Never>()

    @Published var image: Image? = nil {
        didSet {
            if image != nil {
                willChange.send(image)
            }
        }
    }
}


extension ImagePicker {

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            
        // UIImagePickerControllerDelegate
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            ImagePicker.shared.image = Image(uiImage: uiImage)
            picker.dismiss(animated:true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated:true)
        }
    }


    struct View: UIViewControllerRepresentable {
        
        func makeCoordinator() -> Coordinator {
            ImagePicker.shared.coordinator
        }
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker.View>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController,
                                    context: UIViewControllerRepresentableContext<ImagePicker.View>) {
            
        }
        
    }
        
}
