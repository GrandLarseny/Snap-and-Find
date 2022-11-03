//
//  SnapProcessing.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/21/22.
//

import Accelerate.vImage
import CoreImage.CIFilterBuiltins
import UIKit
import Vision

enum SnapProcessing {

    static func processImage(data: Data) -> Data? {
        let uiImage = UIImage(data: data)
        let originalOrientation = uiImage?.imageOrientation
        if let cgImage = resizedToFitHeight(with: data, height: 1024) {
            let ciImage = CIImage(cgImage: cgImage)
            let outlineImageObservation = detectVisionContours(cgImage: cgImage, ciImage: ciImage)

            let colorFilter = CIFilter.colorControls()
            colorFilter.inputImage = ciImage
            colorFilter.brightness = 0.5
            colorFilter.contrast = 2.0
            colorFilter.saturation = 0

            let ciContext = CIContext()

            if let noirImage = colorFilter.outputImage,
               let cgNoirImage = ciContext.createCGImage(noirImage, from: noirImage.extent),
               let outlineImageObservation = outlineImageObservation {
                let drawnUIImage = drawContours(contoursObservation: outlineImageObservation, sourceImage: cgNoirImage, originalOrientation: originalOrientation)
                return drawnUIImage.pngData()
            }
        }

        return nil
    }

    static func detectVisionContours(cgImage: CGImage, ciImage: CIImage) -> VNContoursObservation? {
        let contourRequest = VNDetectContoursRequest()
        contourRequest.revision = VNDetectContourRequestRevision1
//        contourRequest.contrastAdjustment = 1.0
        contourRequest.maximumImageDimension = 512
        contourRequest.detectsDarkOnLight = true

        let requestHandler = VNImageRequestHandler.init(ciImage: ciImage, options: [:])

        do {
            try requestHandler.perform([contourRequest])
            return contourRequest.results?.first as? VNContoursObservation
        } catch {
            debugPrint("Could not perform vision request. \(error)")
        }

        return nil
    }

    static func drawContours(contoursObservation: VNContoursObservation, sourceImage: CGImage, originalOrientation: UIImage.Orientation?) -> UIImage {
        let size = CGSize(width: sourceImage.width, height: sourceImage.height)
        let renderer = UIGraphicsImageRenderer(size: size)

        let renderedImage = renderer.image { (context) in
            let renderingContext = context.cgContext

            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
            renderingContext.concatenate(flipVertical)

            renderingContext.draw(sourceImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

            renderingContext.scaleBy(x: size.width, y: size.height)
            renderingContext.setLineWidth(5.0 / CGFloat(size.width))
            let blackUIColor = UIColor.black
            renderingContext.setStrokeColor(blackUIColor.cgColor)
            renderingContext.addPath(contoursObservation.normalizedPath)
            renderingContext.strokePath()
        }

        return renderedImage
    }

    static func resizedToFitHeight(with data: Data, height: CGFloat) -> CGImage? {

        // Decode the source image
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
              let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any],
              let imageWidth = properties[kCGImagePropertyPixelWidth] as? vImagePixelCount,
              let imageHeight = properties[kCGImagePropertyPixelHeight] as? vImagePixelCount
        else {
            return nil
        }

        // Fit the image size
        let aspectRatio = CGFloat(imageWidth) / CGFloat(imageHeight)
        let width = height * aspectRatio

        // Define the image format
        var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                          bitsPerPixel: 32,
                                          colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0,
                                          decode: nil,
                                          renderingIntent: .defaultIntent)

        var error: vImage_Error

        // Create and initialize the source buffer
        var sourceBuffer = vImage_Buffer()
        defer { sourceBuffer.data.deallocate() }
        error = vImageBuffer_InitWithCGImage(&sourceBuffer,
                                             &format,
                                             nil,
                                             image,
                                             vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }

        // Create and initialize the destination buffer
        var destinationBuffer = vImage_Buffer()
        error = vImageBuffer_Init(&destinationBuffer,
                                  vImagePixelCount(height),
                                  vImagePixelCount(width),
                                  format.bitsPerPixel,
                                  vImage_Flags(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }

        // Scale the image
        error = vImageScale_ARGB8888(&sourceBuffer,
                                     &destinationBuffer,
                                     nil,
                                     vImage_Flags(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }

        // Create a CGImage from the destination buffer
        guard let resizedImage =
                vImageCreateCGImageFromBuffer(&destinationBuffer,
                                              &format,
                                              nil,
                                              nil,
                                              vImage_Flags(kvImageNoAllocate),
                                              &error)?.takeRetainedValue(),
              error == kvImageNoError
        else {
            return nil
        }

        return resizedImage
    }
}
