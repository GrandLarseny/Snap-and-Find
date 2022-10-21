//
//  SnapModel.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import Archivable
import Foundation
import UIKit

struct SnapModel: Archivable, Identifiable, Hashable {

    static var location: ArchiveLocation { .filesystem(directory: .documents) }

    var id = UUID()
    let captureDate: Date
    let originalImageData: Data
    var imageData: Data
    var drawing: Data?

    init(imageData: Data, captureDate: Date = Date()) {
        self.captureDate = captureDate
        self.originalImageData = imageData
        self.imageData = imageData
    }

    var image: UIImage {
        if let image = UIImage(data: imageData) {
            return image
        } else {
            return UIImage(systemName: "questionmark.app")!
        }
    }
}
