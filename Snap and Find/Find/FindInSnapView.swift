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

    var body: some View {
        FindCanvasView(showToolbar: showToolbar,
                       snap: snap,
                       drawing: $drawing)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack {
                    Button {
                        resetSnap()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }

                    Button {
                        showToolbar = true
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
        .onDisappear {
            snap.drawing = drawing.dataRepresentation()
            store.save()
        }
    }

    func resetSnap() {
        drawing = PKDrawing()
    }
}

struct FindInSnapView_Previews: PreviewProvider {
    static var previews: some View {
        let findView = FindInSnapView(snap: .constant(SnapMockData().snaps.first!))

        return NavigationStack { findView }
    }
}
