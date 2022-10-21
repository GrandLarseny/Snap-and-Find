//
//  PhotoPickerSelectionView.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import PhotosUI
import SwiftUI

struct PhotoPickerSelectionView: View {

    @EnvironmentObject var store: SnapStore
    @State var selectedItem: PhotosPickerItem?
    @EnvironmentObject var routeCoordinator: RouteCoordinator

    var body: some View {
        PhotosPicker(selection: $selectedItem,
                     matching: .images,
                     preferredItemEncoding: .compatible) {
            SnapSourceButtonView(source: .library)
        }.onChange(of: selectedItem) { newValue in
            Task {
                if let selectedItem = selectedItem {
                    await store.load(item: selectedItem)
                    routeCoordinator.popToRoot()
                }
            }
        }
        .environment(\.horizontalSizeClass, .compact)
    }
}

struct PhotoPickerSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerSelectionView()
            .environmentObject(SnapStore())
    }
}
