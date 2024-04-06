//
//  ShaderGraphControlsApp.swift
//  ShaderGraphControls
//
//  Created by Hal Mueller on 3/26/24.
//

import SwiftUI

@main
struct ShaderGraphControlsApp: App {
    @State private var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
