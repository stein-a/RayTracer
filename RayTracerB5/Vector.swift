//
//  Vector.swift
//  RayTracerB4
//
//  Created by Stein Alver on 14/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Vector: Tuple {
    init(x: Float, y: Float, z: Float) {
        super.init(x: x, y: y, z: z, w: 0.0)
    }
    
    static func - (lhs: Vector, rhs: Vector) -> Vector {
        return (Tuple(v: lhs) - Tuple(v: rhs)).asVector()
    }
    
    static prefix func -(_ v: Vector) -> Vector {
        let x = -v.x
        let y = -v.y
        let z = -v.z
        return Vector(x: x, y: y, z: z)
    }
    
    func magnitude() -> Float {
        return sqrtf((self.x * self.x) + (self.y * self.y) + (self.z * self.z) + (self.w * self.w))
    }

    func normalize() -> Vector {
        let x = self.x / self.magnitude()
        let y = self.y / self.magnitude()
        let z = self.z / self.magnitude()
        return Vector(x: x, y: y, z: z)
    }
    
    func dot(_ other: Vector) -> Float {
        return  self.x * other.x +
                self.y * other.y +
                self.z * other.z +
                self.w * other.w
    }
    
    func cross(_ other: Vector) -> Vector {
        let x = self.y * other.z - self.z * other.y
        let y = self.z * other.x - self.x * other.z
        let z = self.x * other.y - self.y * other.x
        return Vector(x: x, y: y, z: z)
    }
    
    func reflect(normal: Vector) -> Vector {
        return (self - normal * 2 * self.dot(normal)).asVector()
    }
}
