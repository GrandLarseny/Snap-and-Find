//
//  FindCanvasView.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import PencilKit
import SwiftUI

protocol FindCanvasViewDelegate {

    func drawingDidChange(_ drawing: PKDrawing)

    func scrollViewDidZoom(_ scrollView: UIScrollView)
}

struct FindCanvasView: UIViewRepresentable {

    let showToolbar: Bool
    let drawing: PKDrawing
    let delegate: FindCanvasViewDelegate?

    func makeUIView(context: Context) -> PKCanvasView {
        context.coordinator.canvas.drawing = drawing
        return context.coordinator.canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        context.coordinator.showToolbar = showToolbar
        context.coordinator.canvas.drawing = drawing
    }

    func makeCoordinator() -> Coordinator { Coordinator(delegate: delegate) }

    class Coordinator: NSObject, PKCanvasViewDelegate {

        var canvas = PKCanvasView()
        var toolPicker = PKToolPicker()
        var showToolbar: Bool {
            didSet {
                toolPicker.setVisible(showToolbar, forFirstResponder: canvas)
                toolPicker.addObserver(canvas)
                canvas.becomeFirstResponder()
            }
        }
        let delegate: FindCanvasViewDelegate?

        init(delegate: FindCanvasViewDelegate?) {
            showToolbar = true
            self.delegate = delegate

            super.init()

            canvas.minimumZoomScale = 1
            canvas.maximumZoomScale = 5
            canvas.drawingPolicy = .anyInput
            canvas.tool = PKInkingTool(.marker, color: .yellow.withAlphaComponent(0.75), width: 26)
            canvas.backgroundColor = .clear
            canvas.delegate = self
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            delegate?.drawingDidChange(canvasView.drawing)
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            delegate?.scrollViewDidZoom(scrollView)
        }
    }
}
