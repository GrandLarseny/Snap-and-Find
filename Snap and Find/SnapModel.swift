//
//  SnapModel.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import Archivable
import Foundation
import UIKit

class SnapModel: Archivable, ObservableObject {

    static var location: ArchiveLocation { .filesystem(directory: .documents) }

    var id = UUID()
    let captureDate: Date
    var imageData: Data
    var drawing: Data?
    var thumbnail: Data?

    init(imageData: Data, captureDate: Date = Date()) {
        self.captureDate = captureDate
        self.imageData = imageData
    }

    var image: UIImage {
        if let image = UIImage(data: imageData) {
            return image
        } else {
            return UIImage(systemName: "questionmark.app")!
        }
    }

    var thumbnailImage: UIImage {
        if let thumbnail = thumbnail,
           let thumbnailImage = UIImage(data: thumbnail) {
            return thumbnailImage
        } else {
            return image
        }
    }
}

extension SnapModel: Identifiable, Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: SnapModel, rhs: SnapModel) -> Bool {
        lhs.id == rhs.id
    }
}
