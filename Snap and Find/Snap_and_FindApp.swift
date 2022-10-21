//
//  Snap_and_FindApp.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import SwiftUI

@main
struct Snap_and_FindApp: App {

    @StateObject var snapStore: SnapStore = SnapStore()

    var body: some Scene {
        WindowGroup {
            SnapGridView(snaps: snapStore.snaps)
                .environmentObject(snapStore)
#if DEBUG
                .task {
//                    snapStore.snaps = SnapMockData().snaps
                }
#endif
        }
    }
}
