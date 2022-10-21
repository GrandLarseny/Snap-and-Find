//
//  SnapStore.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import Archivable
import PencilKit
import PhotosUI
import SwiftUI

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

    func update(snap: SnapModel) {
        save()
//        guard let snapIndex = snaps.firstIndex(of: snap) else { return }
//
//        Task {
//            let canvasView = PKCanvasView()
//            let imageView = UIImageView(image: snap.image)
//
//            canvasView.contentSize = imageView.intrinsicContentSize
//
//            let format = UIGraphicsImageRendererFormat.default()
//            format.opaque = false
//            let image = UIGraphicsImageRenderer(size: imageView.intrinsicContentSize, format: format).image { context in
//                imageView.image?.draw(at: .zero)
//                canvasView.drawing.image(from: imageView.frame, scale: UIScreen.main.scale).draw(at: .zero)
//            }
//
//            if let imageData = image.pngData() {
//                snaps[snapIndex].imageData = imageData
//            }
//
//            save()
//        }
    }

    func store(image: UIImage) {
        guard let data = image.pngData() else {
            debugPrint("Failed to create PNG data for image, which is odd")
            return
        }

        let newSnap = SnapModel(imageData: data)
        snaps.append(newSnap)

        save()
    }

    func load(item: PhotosPickerItem) async {
        do {
            if let imageData = try await item.loadTransferable(type: Data.self) {
                let newSnap = SnapModel(imageData: imageData)
                snaps.append(newSnap)
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
}
