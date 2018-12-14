//
//  Cone.swift
//  RayTracerB5
//
//  Created by Stein Alver on 14/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Cone: Cylinder {
   
    override func local_intersect(ray: Ray) -> Intersections {
        var xs = [Intersection]()
        var xsCaps = [Intersection]()
        
        let a = powf(ray.direction.x, 2) - powf(ray.direction.y, 2) + powf(ray.direction.z, 2)
        let b = 2 * ray.origin.x * ray.direction.x - 2 * ray.origin.y * ray.direction.y + 2 * ray.origin.z * ray.direction.z
        let c = powf(ray.origin.x, 2) - powf(ray.origin.y, 2) +
            powf(ray.origin.z, 2)

        if (abs(a) < 0.000001) && (abs(b) < 0.000001) {
            // Ray misses
            xsCaps = intersectCaps(ray: ray)
            xs.append(contentsOf: xsCaps)
            return Intersections(xs)
        }
        
        if (abs(a) < 0.0001) {
            let t = -c / (2 * b)
            xs.append(Intersection(t: t, object: self))
            xsCaps = intersectCaps(ray: ray)
            xs.append(contentsOf: xsCaps)
            return Intersections(xs)
        }
        
        var disc = powf(b, 2) - 4 * a * c
        if (disc < 0) && abs(disc) > 0.0001 {
            // ray does not intersect the cone, just check Caps
            xsCaps = intersectCaps(ray: ray)
            xs.append(contentsOf: xsCaps)
            return Intersections(xs)
        }
        
        disc = abs(disc)
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
        
        xsCaps = intersectCaps(ray: ray)
        xs.append(contentsOf: xsCaps)
        return Intersections(xs)
    }
    
    // a helper function to reduce duplication.
    // checks to see if the intersection at `t` is within a radius
    // of 1 (the radius of your cylinders) from the y axis.
    func checkCap(ray: Ray, t: Float, r: Float) -> Bool {
        let x = ray.origin.x + t * ray.direction.x
        let z = ray.origin.z + t * ray.direction.z
        
        if (x * x) + (z * z) > (r * r) {
            return false
        } else {
            return true
        }
    }
    
    override func intersectCaps(ray: Ray) -> [Intersection] {
        var xsOut = [Intersection]()
        
        if (self.closed) && (abs(ray.direction.y) > 0) {
            let t0 = (self.minimum - ray.origin.y) / ray.direction.y
            if checkCap(ray: ray, t: t0, r: self.minimum) == true {
                xsOut.append(Intersection(t: t0, object: self))
            }
            
            let t1 = (self.maximum - ray.origin.y) / ray.direction.y
            if checkCap(ray: ray, t: t1, r: self.maximum) == true {
                xsOut.append(Intersection(t: t1, object: self))
            }
        }
        
        return xsOut
    }
    
    override func local_normal_at(p: Point) -> Vector {
        let dist = (p.x * p.x) + (p.z * p.z)
        
        if (dist < 1) && (p.y >= self.maximum - 0.0001) {
            return Vector(x: 0, y: 1, z: 0)
        }
        
        if (dist < 1) && (p.y <= self.minimum + 0.0001) {
            return Vector(x: 0, y: -1, z: 0)
        }
        
        var y = sqrtf(powf(p.x, 2) + powf(p.z, 2))
        if p.y > 0 { y = -y }
        
        return Vector(x: p.x, y: y, z: p.z)

    }
}
