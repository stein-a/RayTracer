//
//  Material.swift
//  RayTracerB4
//
//  Created by Stein Alver on 19/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Material: Equatable {
    static func == (lhs: Material, rhs: Material) -> Bool {
        return ( lhs.color == rhs.color &&
                lhs.ambient == rhs.ambient &&
                lhs.diffuse == rhs.diffuse &&
                lhs.specular == rhs.specular &&
                lhs.shininess == rhs.shininess )
    }
    
    
    var color: Color
    var ambient: Float
    var diffuse: Float
    var specular: Float
    var shininess: Float
    var reflectivity: Float
    var transparency: Float
    var refractiveIndex: Float
    var pattern: GeneralPattern?
    
    init() {
        self.color = Color(r: 1, g: 1, b: 1)
        self.ambient = 0.1
        self.diffuse = 0.9
        self.specular = 0.9
        self.shininess = 200
        self.reflectivity = 0.0
        self.transparency = 0.0
        self.refractiveIndex = 1.0
    }
    
    func lighting(light: PointLight, object: Shape, point: Point, eyev: Vector, normalv: Vector, in_shadow: Bool) -> Color {
        var ambient_c = Color(r: 0, g: 0, b: 0)
        var diffuse_c = Color(r: 0, g: 0, b: 0)
        var specular_c = Color(r: 0, g: 0, b: 0)
        var light_color = Color(r: 0, g: 0, b: 0)
        
        if let pattern = object.material.pattern {
            light_color = pattern.color(at: object, point: point)
        } else {
            light_color = object.material.color
        }

        let effective_color = light_color * light.intensity
        let lightv = (light.position - point).normalize()
        ambient_c = effective_color * object.material.ambient
        let light_dot_normal = lightv.dot(normalv)
        if (light_dot_normal < 0) {

        } else {
            diffuse_c = effective_color * object.material.diffuse * light_dot_normal
            let reflectv = (-lightv).reflect(normal: normalv)
            let reflect_dot_eye = reflectv.dot(eyev)
            
            if (reflect_dot_eye <= 0) {

            } else {
                let factor = powf(reflect_dot_eye, object.material.shininess)
                specular_c = light.intensity * object.material.specular * factor
            }
        }
        
        if (in_shadow) {
            light_color = ambient_c
        } else {
            light_color = ambient_c + diffuse_c + specular_c
        }
        return light_color
    }
}
