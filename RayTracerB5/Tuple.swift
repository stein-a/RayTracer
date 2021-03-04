//
//  Tuple.swift
//  RayTracerB4
//
//  Created by Stein Alver on 14/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation
import simd

class Tuple : Equatable, CustomStringConvertible {

    var x: Double
    var y: Double
    var z: Double
    var w: Double
    var vector4: simd_double4

    var description: String {
        return "x=\(x), y=\(y), z=\(z), w=\(w)"
    }
    

    init(x: Double, y: Double, z: Double, w: Double) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
        self.vector4 = simd_double4(x, y, z, w)
    }
    
    init(p: Point) {
        self.x = p.x
        self.y = p.y
        self.z = p.z
        self.w = 1.0
        self.vector4 = simd_double4(x, y, z, 1.0)
    }

    init(v: Vector) {
        self.x = v.x
        self.y = v.y
        self.z = v.z
        self.w = 0.0
        self.vector4 = simd_double4(x, y, z, 0.0)
    }
    
    init(vector: simd_double4) {
        self.x = vector.x
        self.y = vector.y
        self.z = vector.z
        self.w = vector.w
        self.vector4 = vector
    }

    func isPoint() -> Bool {
        return self.w == 1
    }
    
    func isVector() -> Bool {
        return self.w == 0
    }
    
    func asPoint() -> Point {
        return Point(x: self.x, y: self.y, z: self.z)
    }
    
    func asVector() -> Vector {
        return Vector(x: self.x, y: self.y, z: self.z)
    }

    static func == (lhs: Tuple, rhs: Tuple) -> Bool {
        let epsilon : Double = 0.0002
        if  abs(lhs.x - rhs.x) < epsilon &&
            abs(lhs.y - rhs.y) < epsilon &&
            abs(lhs.z - rhs.z) < epsilon &&
            lhs.w == rhs.w {
            return true
        } else {
            return false
        }
    }
    
    static func + (lhs: Tuple, rhs: Tuple) -> Tuple {
        return Tuple(vector: lhs.vector4 + rhs.vector4)
    }
    
    static func - (lhs: Tuple, rhs: Tuple) -> Tuple {
        return Tuple(vector: lhs.vector4 - rhs.vector4)
    }

    static func * (lhs: Tuple, rhs: Double) -> Tuple {
        return Tuple(vector: lhs.vector4 * rhs)
    }

    static func / (lhs: Tuple, rhs: Double) -> Tuple {
        return Tuple(vector: lhs.vector4 / rhs)
    }

    static prefix func -(_ t: Tuple) -> Tuple {
        return Tuple(vector: -t.vector4)
    }
}

