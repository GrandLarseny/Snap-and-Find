//
//  SnapSourceButtonView.swift
//  Snap and Find
//
//  Created by Daniel Larsen on 10/20/22.
//

import SwiftUI

struct SnapSourceButtonView: View {

    enum Source: String {
        case camera
        case library

        var image: Image {
            switch self {
            case .camera: return Image(systemName: "camera.fill")
            case .library: return Image(systemName: "photo")
            }
        }

        var foreground: Color {
            switch self {
            case .camera: return Color("forePurple")
            case .library: return Color("foreGreen")
            }
        }

        var background: Color {
            switch self {
            case .camera: return Color("lightPurple")
            case .library: return Color("lightGreen")
            }
        }

        @ViewBuilder
        var destination: some View {
            switch self {
            case .camera: CameraCaptureView()
            case .library: PhotoPickerSelectionView()
            }
        }
    }

    let source: Source

    var body: some View {
        VStack {
            Spacer()
            source.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 120)
            Text(source.rawValue.capitalized)
                .font(.title2)
            Spacer()
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .foregroundColor(source.foreground)
        .background {
            source.background
        }
        .cornerRadius(20)
        .shadow(color: Color("dropShadow"), radius: 9)
        .padding(30)
    }
}

struct SnapSourceButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            SnapSourceButtonView(source: .library)
            SnapSourceButtonView(source: .camera)
        }
    }
}
