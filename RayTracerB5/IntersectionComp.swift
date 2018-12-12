//
//  IntersectionComp.swift
//  RayTracerB4
//
//  Created by Stein Alver on 19/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class IntersectionComp {
   
    var t: Float
    var object: Shape
    var point: Point
    var eyeVector: Vector
    var normal: Vector
    var isInside: Bool
    var reflectv: Vector
    var n1: Float
    var n2: Float
    var overPoint: Point
    var underPoint: Point

    init(t: Float, object: Shape) {
        self.t = t
        self.object = object
        self.point = Point(x: 0, y: 0, z: 0)
        self.eyeVector = Vector(x: 0, y: 0, z: 0)
        self.normal = Vector(x: 0, y: 0, z: 0)
        self.isInside = false
        self.reflectv = Vector(x: 0, y: 0, z: 0)
        self.n1 = 1.0
        self.n2 = 1.0
        self.overPoint = self.point
        self.underPoint = self.point
    }
    
    func schlick() -> Float {
        // find the cosine of the angle between the eye and normal vectors
        var cos = self.eyeVector.dot(self.normal)
        
        // total internal reflection can only occur if n1 > n2
        if self.n1 > self.n2 {
            let n = self.n1 / self.n2
            let sin2_t = (n * n) * (1.0 - (cos * cos))
            if sin2_t > 1.0 {
                return 1.0
            }
            let cos_t = sqrtf(1.0 - sin2_t)
            cos = cos_t
        }
        
        let r0 = (self.n1 - self.n2)/(self.n1 + self.n2)
        let r2_0 = r0 * r0
        
        return r2_0 + (1 - r2_0) * powf((1 - cos), 5)
    }
}
