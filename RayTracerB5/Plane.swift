//
//  Plane.swift
//  RayTracerB4
//
//  Created by Stein Alver on 22/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Plane : Shape {
    
    override func local_normal_at(p: Point, hit: Intersection) -> Vector {
        return Vector(x: 0, y: 1, z: 0)
    }
    
    override func local_intersect(ray: Ray) -> Intersections {
        if (abs(ray.direction.y) < 0.0001) {
            return Intersections([])
        } else {
            let t = -Double(ray.origin.y) / Double(ray.direction.y)
            let intersect = Intersection(t: t, object: self)
            return Intersections([intersect])
        }

    }
}
