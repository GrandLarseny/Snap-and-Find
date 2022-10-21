//
//  SnapStore.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import Archivable
import PhotosUI
import SwiftUI

struct SnapStoreArchive: Archivable {

    static var location: ArchiveLocation { .filesystem(directory: .documents) }

    var snaps: [SnapModel] = []
}

@MainActor
class SnapStore: ObservableObject {

    @Published var snaps: [SnapModel]

    init() {
        if let archivedSnaps = SnapStoreArchive.retrieve() {
            snaps = archivedSnaps.snaps
        } else {
            snaps = []
        }
    }

    func store(image: UIImage) {
        guard let data = image.pngData() else {
            debugPrint("Failed to create PNG data for image, which is odd")
            return
        }

        let newSnap = SnapModel(captureDate: Date(), imageData: data)
        snaps.append(newSnap)

        do {
            try SnapStoreArchive(snaps: snaps).archive()
        } catch {
            debugPrint("Couldn't archive the snap. \(error)")
        }
    }

    func load(item: PhotosPickerItem) async {
        do {
            if let imageData = try await item.loadTransferable(type: Data.self) {
                let newSnap = SnapModel(captureDate: Date(), imageData: imageData)
                snaps.append(newSnap)
            }

            try SnapStoreArchive(snaps: snaps).archive()
        } catch {
            debugPrint("Couldn't load image. \(error)")
        }
    }
}
