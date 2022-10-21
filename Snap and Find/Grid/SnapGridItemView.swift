//
//  SnapGridItemView.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import SwiftUI

struct SnapGridItemView: View {

    let snap: SnapModel

    var body: some View {
        VStack {
            Image(uiImage: snap.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(16)

            Text(DateFormatter.localizedString(from: snap.captureDate, dateStyle: .medium, timeStyle: .short))
                .font(.caption)
        }
    }
}

struct SnapGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        SnapGridItemView(snap: SnapMockData().snaps.first!)
    }
}
