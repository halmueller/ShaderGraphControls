//
//  ViewModel.swift
//  ShaderGraphControls
//
//  Created by Hal Mueller on 4/5/24.
//

import Foundation
import Observation
import RealityKit

@Observable
final class ViewModel {
    var rootEntity: Entity? = nil

    var red: Float = 1.0 {
        didSet {
            update(parameter: "red", newValue: red)
        }
    }
    
    var green: Float = 1.0 {
        didSet {
            update(parameter: "green", newValue: green)
        }
    }
    var blue: Float = 1.0 {
        didSet {
            update(parameter: "blue", newValue: blue)
        }
    }
    
    func updateParameters() {
        // Using an Enum here would be cleaner. The parameter name strings must match the input nodes' names as defined in Pipeline.usda.
        update(parameter: "red", newValue: red)
        update(parameter: "green", newValue: green)
        update(parameter: "blue", newValue: blue)
    }
    
    func update(parameter: String, newValue: Float) {
        guard let cube = rootEntity?.findEntity(named: "Cube") else { return }
        guard var modelComponent = cube.components[ModelComponent.self] else { return }
        guard var shaderGraphMaterial = modelComponent.materials.first
                as? ShaderGraphMaterial else { return }
        
        do {
            try shaderGraphMaterial.setParameter(name: parameter, value: .float(newValue))
            modelComponent.materials = [shaderGraphMaterial]
            cube.components.set(modelComponent)
        } catch {
            print("unhandled error")
        }
    }
}
