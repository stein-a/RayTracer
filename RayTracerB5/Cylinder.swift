//
//  Cylinder.swift
//  RayTracerB4
//
//  Created by Stein Alver on 27/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Cylinder: Shape {
    
    var minimum : Float
    var maximum : Float
    
    override init() {
        self.minimum = -999999999
        self.maximum = 999999999
        super.init()
    }
 
    override func local_intersect(ray: Ray) -> Intersections {
        let a = powf(ray.direction.x, 2) + powf(ray.direction.z, 2)
        if abs(a) < 0.0001 {
            // Ray is parallel to the y axis
            return Intersections([])
        }
        
        let b = 2 * ray.origin.x * ray.direction.x +
                2 * ray.origin.z * ray.direction.z
        let c = powf(ray.origin.x, 2) + powf(ray.origin.z, 2) - 1
        let disc = powf(b, 2) - 4 * a * c
        if disc < 0 {
            // ray does not intersect the cylinder
            return Intersections([])
        }

        let t0 = (-b - sqrtf(disc)) / (2 * a)
        let t1 = (-b + sqrtf(disc)) / (2 * a)

        let i0 = Intersection(t: t0, object: self)
        let i1 = Intersection(t: t1, object: self)
        
        return Intersections([i0, i1])
    }
    
    override func local_normal_at(p: Point) -> Vector {
        return Vector(x: p.x, y: 0, z: p.z)
    }
}
