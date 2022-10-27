//
//  SnapGridItemView.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import SwiftUI

struct SnapGridItemView: View {

    @ObservedObject var snap: SnapModel

    var body: some View {
        if let thumbnail = UIImage(data: snap.thumbnail ?? snap.imageData) {
            VStack {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
                    .cornerRadius(16)

                Text(DateFormatter.localizedString(from: snap.captureDate, dateStyle: .medium, timeStyle: .short))
                    .font(.caption)
            }
        }
    }
}

struct SnapGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        SnapGridItemView(snap: SnapMockData().snaps.first!)
    }
}
