//
//  Cube.swift
//  RayTracerB4
//
//  Created by Stein Alver on 27/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Cube: Shape {

    override func local_normal_at(p: Point) -> Vector {
        let maxc = max(abs(p.x), abs(p.y), abs(p.z))
        
        if maxc == abs(p.x) {
            return Vector(x: p.x, y: 0, z: 0)
        } else if maxc == abs(p.y) {
            return Vector(x: 0, y: p.y, z: 0)
        }
        return Vector(x: 0, y: 0, z: p.z)
    }
    
    override func local_intersect(ray: Ray) -> Intersections {
        let (xtmin, xtmax) = self.checkAxis(origin: ray.origin.x,
                                            direction: ray.direction.x)
        let (ytmin, ytmax) = self.checkAxis(origin: ray.origin.y,
                                            direction: ray.direction.y)
        let (ztmin, ztmax) = self.checkAxis(origin: ray.origin.z,
                                            direction: ray.direction.z)
        let tmin = max(xtmin, ytmin, ztmin)
        let tmax = min(xtmax, ytmax, ztmax)
        
        if tmin > tmax {
            return Intersections([])
        }
        
        let i0 = Intersection(t: tmin, object: self)
        let i1 = Intersection(t: tmax, object: self)
        return Intersections([i0, i1])
    }
    
    func checkAxis(origin: Float, direction: Float) -> (Float, Float) {
        let EPSILON : Float = 0.00001
        let INFINITY: Float = 9999999999
        
        let tmin_num = (-1 - origin)
        let tmax_num = (1 - origin)
        
        var tmin : Float = 0
        var tmax : Float = 0
        
        
        if abs(direction) >= EPSILON {
            tmin = tmin_num / direction
            tmax = tmax_num / direction
        } else {
            tmin = tmin_num * INFINITY
            tmax = tmax_num * INFINITY
        }
        
        if tmin > tmax {
            swap(&tmin, &tmax)
        }
        
        return (tmin, tmax)
    }
}
