//
//  SmoothTriangle.swift
//  RayTracerB5
//
//  Created by Stein Alver on 16/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class SmoothTriangle : Triangle {
    
    var n1 : Vector
    var n2 : Vector
    var n3 : Vector
    
    init(p1: Point, p2: Point, p3: Point, n1: Vector, n2: Vector, n3: Vector) {
        self.n1 = n1
        self.n2 = n2
        self.n3 = n3
        super.init(p1: p1, p2: p2, p3: p3)
    }
    
    override func local_intersect(ray: Ray) -> Intersections {
        let dir_cross_e2 = ray.direction.cross(self.e2)
        let det = self.e1.dot(dir_cross_e2)
        
        if abs(det) < 0.0001 {
            return Intersections([])
        }
        
        let f = 1.0 / det
        let p1_to_origin = (ray.origin - self.p1).asVector()
        let u = f * (p1_to_origin.dot(dir_cross_e2))
        
        if (u < 0) || (u > 1) {
            return Intersections([])
        }
        
        let origin_cross_e1 = p1_to_origin.cross(self.e1)
        let v = f * ray.direction.dot(origin_cross_e1)
        
        if (v < 0) || (u + v > 1) {
            return Intersections([])
        }
        
        let t = f * self.e2.dot(origin_cross_e1)
        return Intersections([intersectionWithUV(t: t, object: self, u: u, v: v)])
    }
    
    override func local_normal_at(p: Point, hit: Intersection) -> Vector {
        let vec1 = self.n2 * hit.u
        let vec2 = self.n3 * hit.v
        let vec3 = self.n1 * (1 - hit.u - hit.v)
        return (vec1 + vec2 + vec3).asVector()
    }
}
