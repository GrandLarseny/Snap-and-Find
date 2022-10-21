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

        if let processedData = SnapProcessing.processImage(data: data) {
            imageData = processedData
        }

        let newSnap = SnapModel(imageData: imageData)
        snaps.append(newSnap)
    }
}
