//
//  Sphere.swift
//  RayTracerB4
//
//  Created by Stein Alver on 16/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Sphere: Shape {
        
    override func local_intersect(ray: Ray) -> Intersections {
        // the vector from the sphere's center, to the ray origin
        // remember: the sphere is centered at the world origin
        let sphere_to_ray : Vector = ray.origin - Point(x: 0, y: 0, z: 0)
        let a = ray.direction.dot(ray.direction)
        let b = 2 * (ray.direction.dot(sphere_to_ray))
        let c = sphere_to_ray.dot(sphere_to_ray) - 1
        
        let discriminant = b * b - 4 * a * c
        
        if discriminant < 0 {
            return Intersections([])
        } else {
            let t1 = (-b - sqrt(discriminant)) / (2 * a)
            let t2 = (-b + sqrt(discriminant)) / (2 * a)
            
            let i1 = Intersection(t: t1, object: self)
            let i2 = Intersection(t: t2, object: self)
            return Intersections([i1, i2])
        }
    }
    
    override func local_normal_at(p: Point, hit: Intersection) -> Vector {
        return p - Point(x: 0, y: 0, z: 0)
    }
    
    class func glassSphere() -> Sphere {
        let s = Sphere()
        s.transform = Matrix4.identity()
        s.material.transparency = 1.0
        s.material.refractiveIndex = 1.5
        return s
    }
}
