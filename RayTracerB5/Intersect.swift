//
//  Intersect.swift
//  RayTracerB4
//
//  Created by Stein Alver on 16/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//


// NB! This has been replaced by the intersect function inside Sphere NB!

import Foundation

class Intersect {
    
    var sphere: Sphere
    var ray: Ray
    var count: Int
    var hits: [Float]
    
    init(sphere: Sphere, ray: Ray) {
        self.sphere = sphere
        self.ray = ray
        self.count = 0
        self.hits = []

        find_hits()
    }
    
    func find_hits() {
        // the vector from the sphere's center, to the ray origin
        // remember: the sphere is centered at the world origin
        let sphere_to_ray : Vector = ray.origin - Point(x: 0, y: 0, z: 0)
        let a = ray.direction.dot(ray.direction)
        let b = 2 * (ray.direction.dot(sphere_to_ray))
        let c = sphere_to_ray.dot(sphere_to_ray) - 1
        
        let discriminant = b * b - 4 * a * c
        
        if discriminant < 0 {
            self.count = 0
            self.hits = []
        } else {
            let t1 = (-b - sqrtf(discriminant)) / (2 * a)
            let t2 = (-b + sqrtf(discriminant)) / (2 * a)
            self.count = 2
            self.hits = [t1, t2]
        }
    }
}
