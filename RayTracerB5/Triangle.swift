//
//  Triangle.swift
//  RayTracerB5
//
//  Created by Stein Alver on 14/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Triangle : Shape {
    var p1 : Point
    var p2 : Point
    var p3 : Point
    var e1 : Vector
    var e2 : Vector
    var normal : Vector
    
    init(p1: Point, p2: Point, p3: Point) {
        self.p1 = p1
        self.p2 = p2
        self.p3 = p3
        self.e1 = self.p2 - self.p1
        self.e2 = self.p3 - self.p1
        self.normal = e2.cross(e1).normalize()
        super.init()
    }

    override func local_normal_at(p: Point, hit: Intersection) -> Vector {
        return self.normal
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
        return Intersections([Intersection(t: t, object: self)])
    }
    
    func intersectionWithUV(t: Float, object: Shape, u: Float, v: Float) -> Intersection {
        let i = Intersection(t: t, object: object)
        i.u = u
        i.v = v
        return i
    }
}
