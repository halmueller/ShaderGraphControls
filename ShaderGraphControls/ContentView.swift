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
                // Could move this string to the View Model, maybe even the Entity loading too.
                if let scene = try? await Entity(named: "Pipeline", in: realityKitContentBundle) {
                    viewModel.rootEntity = scene
                    content.add(scene)
                }
            } update: { content in
                viewModel.updateParameters()
            }
            .padding(.bottom, 50)
            VStack {
                LabeledContent("Red") {
                    Slider(value: $viewModel.red, in: 0...1)
                }
                LabeledContent("Green") {
                    Slider(value: $viewModel.green, in: 0...1)
                }
                LabeledContent("Blue") {
                    Slider(value: $viewModel.blue, in: 0...1)
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
