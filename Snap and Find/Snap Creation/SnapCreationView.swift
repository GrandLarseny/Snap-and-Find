//
//  SnapCreationView.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import SwiftUI

struct SnapCreationView: View {
    
    var body: some View {
        HStack() {
            PhotoPickerSelectionView()

            NavigationLink(value: Route.cameraCapture) {
                SnapSourceButtonView(source: .camera)
            }
        }
        .padding(.vertical, 26)
        .navigationTitle("Find Your Snap")
    }
}

struct SnapCreationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SnapCreationView()
        }
    }
}
