//
//  Tuple.swift
//  RayTracerB4
//
//  Created by Stein Alver on 14/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Tuple : Equatable, CustomStringConvertible {

    var x: Double
    var y: Double
    var z: Double
    var w: Double

    var description: String {
        return "x=\(x), y=\(y), z=\(z), w=\(w)"
    }
    

    init(x: Double, y: Double, z: Double, w: Double) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    init(p: Point) {
        self.x = p.x
        self.y = p.y
        self.z = p.z
        self.w = 1.0
    }

    init(v: Vector) {
        self.x = v.x
        self.y = v.y
        self.z = v.z
        self.w = 0.0
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
        let x = lhs.x + rhs.x
        let y = lhs.y + rhs.y
        let z = lhs.z + rhs.z
        let w = lhs.w + rhs.w
        return Tuple(x: x, y: y, z: z, w: w)
    }
    
    static func - (lhs: Tuple, rhs: Tuple) -> Tuple {
        let x = lhs.x - rhs.x
        let y = lhs.y - rhs.y
        let z = lhs.z - rhs.z
        let w = lhs.w - rhs.w
        return Tuple(x: x, y: y, z: z, w: w)
    }

    static func * (lhs: Tuple, rhs: Double) -> Tuple {
        let x = lhs.x * rhs
        let y = lhs.y * rhs
        let z = lhs.z * rhs
        let w = lhs.w * rhs
        return Tuple(x: x, y: y, z: z, w: w)
    }

    static func / (lhs: Tuple, rhs: Double) -> Tuple {
        let x = lhs.x / rhs
        let y = lhs.y / rhs
        let z = lhs.z / rhs
        let w = lhs.w / rhs
        return Tuple(x: x, y: y, z: z, w: w)
    }

    static prefix func -(_ t: Tuple) -> Tuple {
        let x = -t.x
        let y = -t.y
        let z = -t.z
        let w = -t.w
        return Tuple(x: x, y: y, z: z, w: w)
    }
}

