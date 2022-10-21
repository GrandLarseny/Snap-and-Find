//
//  Route.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import SwiftUI

enum Route: Hashable {
    case cameraCapture
    case createSnap
    case findInSnap(Binding<SnapModel>)

    @ViewBuilder
    var destination: some View {
        switch self {
        case .cameraCapture: CameraCaptureView().edgesIgnoringSafeArea(.all)
        case .createSnap: SnapCreationView()
        case .findInSnap(let model): FindInSnapView(snap: model)
        }
    }
}
