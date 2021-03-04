//
//  Vector.swift
//  RayTracerB4
//
//  Created by Stein Alver on 14/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation
import simd

class Vector: Tuple {
    var vector3: simd_double3
    
    init(x: Double, y: Double, z: Double) {
        self.vector3 = simd_double3(x, y, z)
        super.init(x: x, y: y, z: z, w: 0.0)
    }
    
    init(vector: simd_double3) {
        self.vector3 = vector
        super.init(vector: simd_make_double4(vector, 0.0))
    }
    
    static func - (lhs: Vector, rhs: Vector) -> Vector {
        return Vector(vector: lhs.vector3 - rhs.vector3)
    }
    
    static prefix func -(_ v: Vector) -> Vector {
        return Vector(vector: -v.vector3)
    }
    
    func magnitude() -> Double {
        return simd_length(self.vector3)
    }

    func normalize() -> Vector {
        return Vector(vector: simd_normalize(self.vector3))
    }
    
    func dot(_ other: Vector) -> Double {
        return simd_dot(self.vector3, other.vector3)
    }
    
    func cross(_ other: Vector) -> Vector {
        return Vector(vector: simd_cross(self.vector3, other.vector3))
    }
    
    func reflect(normal: Vector) -> Vector {
        return Vector(vector: simd_reflect(self.vector3, normal.vector3))
    }
}
