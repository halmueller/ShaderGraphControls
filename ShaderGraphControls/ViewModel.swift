//
//  ViewModel.swift
//  ShaderGraph InOut
//
//  Created by Hal Mueller on 4/5/24.
//

import Foundation
import Observation
import RealityKit

@Observable
final class ViewModel {
    var rootEntity: Entity? = nil

    var gray: Float = 1.0 {
        didSet {
            updateGray()
        }
    }
    
    func updateGray() {
        print(#function, gray)
        guard let cube = rootEntity?.findEntity(named: "Cube") else {
            return }
        
        print(#line, cube)
        print(#line, cube.components)
        print(#line, cube.children)
        guard var modelComponent = cube.components[ModelComponent.self] else {
            return }
        guard var shaderGraphMaterial = modelComponent.materials.first
                as? ShaderGraphMaterial else {
            return }
        
        do {
            print(shaderGraphMaterial)
            print(modelComponent)
            try shaderGraphMaterial.setParameter(name: "gray", value: .float(gray))
            modelComponent.materials = [shaderGraphMaterial]
            cube.components.set(modelComponent)
            print("found it")
        } catch {
            print("unhandled error")
        }
/*
        @State private var sliderValue: Float = 0.0

        Slider(value: $sliderValue, in: (0.0)...(1.0))
            .onChange(of: sliderValue) { _, _ in
                guard let terrain = rootEntity.findEntity(named: "DioramaTerrain"),
                        var modelComponent = terrain.components[ModelComponent.self],
                        var shaderGraphMaterial = modelComponent.materials.first
                            as? ShaderGraphMaterial else { return }
                do {
                    try shaderGraphMaterial.setParameter(name: "Progress", value: .float(sliderValue))
                    modelComponent.materials = [shaderGraphMaterial]
                    terrain.components.set(modelComponent)
                } catch { }
            }
        }
 */
    }
}
