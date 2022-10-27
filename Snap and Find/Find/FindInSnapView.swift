//
//  FindInSnapView.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import PencilKit
import SwiftUI

struct FindInSnapView: View {

    @Binding var snap: SnapModel
    @State var showToolbar = false
    @State var drawing = PKDrawing()
    @EnvironmentObject var store: SnapStore

    @State var zoomScale: CGFloat = 1.0
    @State var zoomOffset: CGSize = .zero

    var body: some View {
        Image(uiImage: snap.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(zoomScale, anchor: .topLeading)
            .offset(zoomOffset)
            .clipped()
            .overlay {
                FindCanvasView(showToolbar: showToolbar,
                               drawing: drawing,
                               delegate: self)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack {

                        Button {
                            saveThumbnail()
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }

                        Button {
                            rotate()
                        } label: {
                            Image(systemName: "rotate.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }

                        Button {
                            resetSnap()
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }

                        Button {
                            showToolbar.toggle()
                        } label: {
                            Image(systemName: "pencil.and.outline")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(height: 32)
                    }
                }
            }
            .navigationTitle("Snapped on \(DateFormatter.localizedString(from: snap.captureDate, dateStyle: .short, timeStyle: .short))")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                do {
                    if let snapDrawing = snap.drawing {
                        drawing = try PKDrawing(data: snapDrawing)
                    }
                } catch {
                    debugPrint("Uh-oh, bad drawing data. Discarding.")
                }

                showToolbar = true
            }
            .onDisappear {
                Task {
                    debugPrint(" <<< Goodbye!")
                    snap.thumbnail = thumbnail.pngData()
                    store.reload(snap: snap)
                    store.save()
                }
            }
    }

    func rotate() {
        if let rotatedImage = snap.image.rotate(radians: .pi/2),
           let imageData = rotatedImage.pngData() {
            snap.imageData = imageData
            zoomScale = 2
            zoomScale = 1
        }
    }

    var thumbnail: UIImage {
        if let drawingData = snap.drawing,
           let drawing = try? PKDrawing(data: drawingData) {
            return drawing.draw(on: snap.image)
        } else {
            return snap.image
        }
    }

    func resetSnap() {
        drawing = PKDrawing()
    }

    private func saveThumbnail() {
        snap.thumbnail = thumbnail.pngData()

        UIImageWriteToSavedPhotosAlbum(thumbnail, nil, nil, nil)

        Task {
            store.save()
        }
    }
}

extension FindInSnapView: FindCanvasViewDelegate {

    func drawingDidChange(_ drawing: PKDrawing) {
        Task {
            snap.drawing = drawing.dataRepresentation()
        }
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        zoomScale = scrollView.zoomScale
        zoomOffset = CGSize(width: -scrollView.contentOffset.x, height: -scrollView.contentOffset.y)
    }
}

struct FindInSnapView_Previews: PreviewProvider {
    static var previews: some View {
        let findView = FindInSnapView(snap: .constant(SnapMockData().snaps.first!))

        return NavigationStack { findView }
    }
}
