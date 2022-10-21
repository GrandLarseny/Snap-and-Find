//
//  FindCanvasView.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import PencilKit
import SwiftUI
import GeneralUtilities

protocol FindCanvasViewDelegate {

    func userDidDraw(drawing data: Data)
}

struct FindCanvasView: UIViewRepresentable {

    let showToolbar: Bool
    let snap: SnapModel
    let delegate: FindCanvasViewDelegate

    func makeUIView(context: Context) -> PKCanvasView {
        context.coordinator.canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if showToolbar {
            context.coordinator.showToolbar()
        }

        context.coordinator.layoutImageSize()
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: PKCanvasView, context: Context) -> CGSize? {
        if let width = proposal.width,
           let height = proposal.height {
            let proposedSize = CGSize(width: width, height: height)
            context.coordinator.snapImageView?.frame = CGRect(origin: .zero, size: proposedSize)
        }

        return nil
    }

    func makeCoordinator() -> Coordinator { Coordinator(snap: snap, delegate: delegate) }

    class Coordinator: NSObject, PKCanvasViewDelegate {

        var canvas = PKCanvasView()
        var toolPicker = PKToolPicker()
        var snapImageView: UIImageView?
        let delegate: FindCanvasViewDelegate

        init(snap: SnapModel, delegate: FindCanvasViewDelegate) {
            self.delegate = delegate
            super.init()

            canvas.minimumZoomScale = 1
            canvas.maximumZoomScale = 5
            canvas.drawingPolicy = .anyInput
            canvas.tool = PKInkingTool(.marker, color: .yellow.withAlphaComponent(0.75), width: 26)
            canvas.backgroundColor = .clear
            canvas.delegate = self

            snapImageView = UIImageView(image: snap.image)
            snapImageView?.contentMode = .scaleAspectFit
            canvas.insertSubview(snapImageView!, at: 0)

            if let drawingData = snap.drawing {
                do {
                    let drawing = try PKDrawing(data: drawingData)
                    canvas.drawing = drawing
                } catch {
                    debugPrint("Warning: Couldn't recreate drawing data. \(error)")
                }
            }
        }

        func layoutImageSize() {
            snapImageView?.frame.size = canvas.contentSize
        }

        func showToolbar() {
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            layoutImageSize()
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            delegate.userDidDraw(drawing: canvasView.drawing.dataRepresentation())
        }
    }
}
