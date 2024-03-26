//
//  ShaderGraph_InOutApp.swift
//  ShaderGraph InOut
//
//  Created by Hal Mueller on 3/26/24.
//

import SwiftUI

@main
struct ShaderGraph_InOutApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
