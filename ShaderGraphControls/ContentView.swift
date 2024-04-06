//
//  ContentView.swift
//  ShaderGraphControls
//
//  Created by Hal Mueller on 3/26/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var viewModel: ViewModel

    var body: some View {
        @Bindable var viewModel = viewModel

        VStack {
            RealityView { content in
                if let scene = try? await Entity(named: "Pipeline", in: realityKitContentBundle) {
                    viewModel.rootEntity = scene
                    content.add(scene)
//                    viewModel.updateGray()
                }
            } update: { content in
                // See https://stackoverflow.com/questions/77705497/reality-composer-pro-material-texture-not-shown-when-using-generatetext-in-visi/77705804#77705804
                // guard let scene = content.entities.first else { return }
                viewModel.updateGray()
            }
            .padding(.bottom, 50)
            VStack {
                LabeledContent("Gray") {
                    Slider(value: $viewModel.gray, in: 0...1)
                }
            }
            .padding(.horizontal, 300)
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView(viewModel: ViewModel())
}
