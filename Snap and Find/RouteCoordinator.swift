//
//  RouteCoordinator.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import Foundation

class RouteCoordinator: ObservableObject {

    @Published var path: [Route] = []

    func push(_ route: Route) {
        path.append(route)
    }

    func popToRoot() {
        path = []
    }
}
