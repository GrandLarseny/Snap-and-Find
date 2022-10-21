//
//  PKDrawing+Extension.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/21/22.
//

import PencilKit
import SwiftUI

extension PKDrawing {

    func draw(on background: UIImage) -> UIImage {
        let scaledDrawing = scale(by: UIScreen.main.scale)
        let image = scaledDrawing.image(from: scaledDrawing.bounds, scale: UIScreen.main.scale)

        return background.mergeImage(with: image, point: scaledDrawing.bounds.origin)
    }

    func scale(by scaleFactor: CGFloat) -> PKDrawing {
        let trasform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)

        return transformed(using: trasform)
    }
}

// MARK: Merge Image

extension UIImage {

    func mergeImage(with secondImage: UIImage, point: CGPoint? = nil) -> UIImage {

        let firstImage = self
        let newImageWidth = max(firstImage.size.width, secondImage.size.width)
        let newImageHeight = max(firstImage.size.height, secondImage.size.height)
        let newImageSize = CGSize(width: newImageWidth, height: newImageHeight)

        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.main.scale)

        let firstImagePoint = CGPoint(x: round((newImageSize.width - firstImage.size.width) / 2),
                                      y: round((newImageSize.height - firstImage.size.height) / 2))

        let secondImagePoint = point ?? CGPoint(x: round((newImageSize.width - secondImage.size.width) / 2),
                                                y: round((newImageSize.height - secondImage.size.height) / 2))

        firstImage.draw(at: firstImagePoint)
        secondImage.draw(at: secondImagePoint)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image ?? self
    }
}
