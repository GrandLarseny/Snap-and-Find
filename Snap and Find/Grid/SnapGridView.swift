//
//  SnapGridView.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import SwiftUI

struct SnapGridView: View {

    @EnvironmentObject var store: SnapStore
    @StateObject private var routeCoordinator = RouteCoordinator()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack(path: $routeCoordinator.path) {
            ScrollView {
                LazyVGrid(columns: columns,
                          alignment: .center,
                          spacing: 50) {
                    ForEach($store.snaps) { $snap in
                        NavigationLink(value: Route.findInSnap($snap)) {
                            SnapGridItemView(snap: snap)
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
            .navigationDestination(for: Binding<SnapModel>.self) { model in
                FindInSnapView(snap: model)
            }
            .navigationDestination(for: Route.self) { route in
                route.destination
                    .environmentObject(routeCoordinator)
            }
            .navigationTitle("Snap and Find")
            .environmentObject(routeCoordinator)
            .task {
                if store.snaps.isEmpty {
                    routeCoordinator.push(.createSnap)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SnapGridView()
            .environmentObject(SnapStore(SnapMockData().snaps))
    }
}
