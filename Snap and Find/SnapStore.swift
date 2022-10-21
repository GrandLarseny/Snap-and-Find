//
//  SnapStore.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import Archivable
import CoreImage.CIFilterBuiltins
import PencilKit
import PhotosUI
import SwiftUI
import Vision

struct SnapStoreArchive: Archivable {

    static var location: ArchiveLocation { .filesystem(directory: .documents) }

    var snaps: [SnapModel] = []
}

@MainActor
class SnapStore: ObservableObject {

    @Published var snaps: [SnapModel]

    init(_ snaps: [SnapModel] = []) {
        if let archivedSnaps = SnapStoreArchive.retrieve() {
            self.snaps = archivedSnaps.snaps
        } else {
            self.snaps = snaps
        }
    }

    func store(image: UIImage) {
        guard let data = image.pngData() else {
            debugPrint("Failed to create PNG data for image, which is odd")
            return
        }

        addImage(data: data)

        save()
    }

    func load(item: PhotosPickerItem) async {
        do {
            if let imageData = try await item.loadTransferable(type: Data.self) {
                addImage(data: imageData)
            }
        } catch {
            debugPrint("Couldn't load image. \(error)")
        }

        save()
    }

    func save() {
        Task {
            do {
                try SnapStoreArchive(snaps: snaps).archive()
            } catch {
                debugPrint("Couldn't archive the snaps. \(error)")
            }
        }
    }

    private func addImage(data: Data) {
        var imageData = data

        if let cgImage = SnapProcessing.resizedToFitHeight(with: data, height: 1024) {
            let ciImage = CIImage(cgImage: cgImage)
            let outlineImage = SnapProcessing.detectVisionContours(cgImage: cgImage, ciImage: ciImage)!
            let noirFilter = CIFilter.photoEffectNoir()
            noirFilter.inputImage = CIImage(image: outlineImage)

            if let noirImage = noirFilter.outputImage,
               let uiImageData = UIImage(ciImage: noirImage).pngData() {
                imageData = uiImageData
            }
        }
        //        if let ciImage = CIImage(data: data),
        //           let noirImage = CIFilter(name: "CIPhotoEffectNoir", parameters: [kCIInputImageKey: ciImage])?.outputImage,
        //           let edgeImage = CIFilter(name: "CIEdgeWork", parameters: [kCIInputImageKey: ciImage, kCIInputRadiusKey: 5])?.outputImage {
        //            let blackEdgeImage = edgeImage.applyingFilter("CIColorInvert", parameters: [kCIInputImageKey: edgeImage])
        //            let combinedImage = CIFilter(name: "CISourceOverCompositing", parameters: [kCIInputBackgroundImageKey: noirImage, kCIInputImageKey: blackEdgeImage])
        //
        //            if let coloringImage = combinedImage?.outputImage,
        //               let uiImageData = UIImage(ciImage: coloringImage).pngData() {
        //                imageData = uiImageData
        //            }
        //        }

        let newSnap = SnapModel(imageData: imageData)
        snaps.append(newSnap)
    }
}
