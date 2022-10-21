//
//  FindInSnapView.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import SwiftUI

struct FindInSnapView: View {

    let snap: SnapModel
    @State var showToolbar = false

    var body: some View {
        ZStack(alignment: .center) {
            FindCanvasView(showToolbar: showToolbar, snap: snap)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showToolbar = true
                } label: {
                    Image(systemName: "pencil.and.outline")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 32)
                        .padding()
                        .shadow(radius: 4)
                }
            }
        }
        .navigationTitle("Snapped on \(DateFormatter.localizedString(from: snap.captureDate, dateStyle: .short, timeStyle: .short))")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FindInSnapView_Previews: PreviewProvider {
    static var previews: some View {
        let findView = FindInSnapView(snap: SnapMockData().snaps.first!)
        //        findView.showToolbar = true
        return NavigationStack { findView }
    }
}
