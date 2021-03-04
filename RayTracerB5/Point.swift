//
//  Point.swift
//  RayTracerB4
//
//  Created by Stein Alver on 14/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Point: Tuple {
    init(x: Double, y: Double, z: Double) {
        super.init(x: x, y: y, z: z, w: 1.0)
    }
    
    static func - (lhs: Point, rhs: Point) -> Vector {
        return (Tuple(p: lhs) - Tuple(p: rhs)).asVector()
    }
    
    static func - (lhs: Point, rhs: Vector) -> Point {
        return (Tuple(p: lhs) - Tuple(v: rhs)).asPoint()
    }

}
