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
    var infinity : Float = 999999999.99
    var closed : Bool
    
    override init() {
        self.minimum = -infinity
        self.maximum = infinity
        self.closed = false
        super.init()
    }
 
    override func local_intersect(ray: Ray) -> Intersections {
        let a = powf(ray.direction.x, 2) + powf(ray.direction.z, 2)
        if abs(a) < 0.0001 {
            // Ray is parallel to the y axis
            return Intersections(intersectCaps(ray: ray))
        }
        
        let b = 2 * ray.origin.x * ray.direction.x +
                2 * ray.origin.z * ray.direction.z
        let c = powf(ray.origin.x, 2) + powf(ray.origin.z, 2) - 1
        let disc = powf(b, 2) - 4 * a * c
        if disc < 0 {
            // ray does not intersect the cylinder, just check Caps
            return Intersections(intersectCaps(ray: ray))
        }

        var xs = [Intersection]()
        
        var t0 = (-b - sqrtf(disc)) / (2 * a)
        var t1 = (-b + sqrtf(disc)) / (2 * a)
        if t0 > t1 { swap(&t0, &t1) }

        let y0 = ray.origin.y + t0 * ray.direction.y
        if (y0 > self.minimum) && (y0 < self.maximum) {
            xs.append(Intersection(t: t0, object: self))
        }
        
        let y1 = ray.origin.y + t1 * ray.direction.y
        if (y1 > self.minimum) && (y1 < self.maximum) {
            xs.append(Intersection(t: t1, object: self))
        }
        
        let xsCaps = intersectCaps(ray: ray)
        xs.append(contentsOf: xsCaps)
        
        return Intersections(xs)
    }
    
    override func local_normal_at(p: Point) -> Vector {
        let dist = (p.x * p.x) + (p.z * p.z)
        
        if (dist < 1) && (p.y >= self.maximum - 0.0001) {
            return Vector(x: 0, y: 1, z: 0)
        }

        if (dist < 1) && (p.y <= self.minimum + 0.0001) {
            return Vector(x: 0, y: -1, z: 0)
        }

        return Vector(x: p.x, y: 0, z: p.z)
    }
    
    // a helper function to reduce duplication.
    // checks to see if the intersection at `t` is within a radius
    // of 1 (the radius of your cylinders) from the y axis.
    func checkCap(ray: Ray, t: Float) -> Bool {
        let x = ray.origin.x + t * ray.direction.x
        let z = ray.origin.z + t * ray.direction.z

        if (x * x) + (z * z) > 1.0001 {
            return false
        } else {
            return true
        }
    }
    
    func intersectCaps(ray: Ray) -> [Intersection] {
        var xsOut = [Intersection]()
        
        if (self.closed) && (abs(ray.direction.y) > 0) {
            let t0 = (self.minimum - ray.origin.y) / ray.direction.y
            if checkCap(ray: ray, t: t0) == true {
                xsOut.append(Intersection(t: t0, object: self))
            }
            
            let t1 = (self.maximum - ray.origin.y) / ray.direction.y
            if checkCap(ray: ray, t: t1) == true {
                xsOut.append(Intersection(t: t1, object: self))
            }
        }
        
        return xsOut
    }
}
