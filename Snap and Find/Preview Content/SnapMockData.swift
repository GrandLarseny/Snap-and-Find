//
//  SnapMockData.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import UIKit

struct SnapMockData {

    var snaps: [SnapModel]

    init() {
        snaps = (0..<5).compactMap { imageNumber -> SnapModel? in
            guard let image = UIImage(named: "\(imageNumber)"),
            let imageData = image.jpegData(compressionQuality: 0.9) else {
                debugPrint("Huh, couldn't find the image for \(imageNumber)")
                return nil
            }

            guard let capture = Calendar.current.date(byAdding: .day, value: -1 * imageNumber, to: Date()) else { fatalError("I don't like the dates") }

            return SnapModel(imageData: imageData, captureDate: capture)
        }
    }
}
