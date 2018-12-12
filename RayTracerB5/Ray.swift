//
//  Ray.swift
//  RayTracerB4
//
//  Created by Stein Alver on 16/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Ray {
    var origin : Point
    var direction : Vector
    
    init(orig: Point, dir: Vector) {
        self.origin = orig
        self.direction = dir
    }
    
    func position(time: Float) -> Point {
        return (self.origin + self.direction * time).asPoint()
    }
    
    func transform(m: Matrix) -> Ray {
        let new_origin = (m * self.origin).asPoint()
        let new_direction = (m * self.direction).asVector()
        return Ray(orig: new_origin, dir: new_direction)
    }
}
