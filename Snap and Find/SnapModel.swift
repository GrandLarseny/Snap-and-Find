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

    let id: UUID
    let captureDate: Date
    var imageData: Data
    var drawing: Data?
    @Published var thumbnail: Data?

    init(_ id: UUID = UUID(), imageData: Data, captureDate: Date = Date()) {
        self.id = id
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
}

extension SnapModel: Identifiable, Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: SnapModel, rhs: SnapModel) -> Bool {
        lhs.id == rhs.id
    }
}
