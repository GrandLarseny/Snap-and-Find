//
//  CameraCaptureView.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import PhotosUI
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct CameraCaptureView: UIViewControllerRepresentable {

    @EnvironmentObject var store: SnapStore
    @EnvironmentObject var routeCoordinator: RouteCoordinator

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.mediaTypes = [UTType.image.identifier]
        controller.sourceType = .camera
        return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        uiViewController.delegate = context.coordinator
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraCaptureView

        init(parent: CameraCaptureView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.store.add(image: image)
            }

            parent.routeCoordinator.popToRoot()
        }
    }
}
