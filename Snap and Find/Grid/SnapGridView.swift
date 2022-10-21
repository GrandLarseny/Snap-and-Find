//
//  SnapGridView.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import SwiftUI

struct SnapGridView: View {

    var snaps: [SnapModel]
    @StateObject private var routeCoordinator = RouteCoordinator()

    var body: some View {
        NavigationStack(path: $routeCoordinator.path) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))],
                          alignment: .center,
                          spacing: 50) {
                    ForEach(snaps) { snap in
                        NavigationLink(value: Route.findInSnap(snap)) {
                            SnapGridItemView(snap: snap)
                                .padding(.horizontal)
                        }
                    }

                    NavigationLink(value: Route.createSnap) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                route.destination
            }
            .navigationTitle("Snap and Find")
        }
        .environmentObject(routeCoordinator)
        .task {
            if snaps.isEmpty {
                routeCoordinator.push(.createSnap)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SnapGridView(snaps: SnapMockData().snaps)
    }
}
