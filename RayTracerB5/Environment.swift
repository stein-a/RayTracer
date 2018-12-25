//
//  Environment.swift
//  RayTracerB4
//
//  Created by Stein Alver on 15/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Environment {
    
    var gravity: Vector
    var wind: Vector
    
    init(gravity: Vector, wind: Vector) {
        self.gravity = gravity
        self.wind = wind
    }
    
    func tick(proj: Projectile) -> Projectile {
        let pos_tuple = proj.position + proj.velocity
        let vel_tuple = proj.velocity + self.gravity + self.wind
        let new_pos = Point(x: pos_tuple.x, y: pos_tuple.y, z: pos_tuple.z)
        let new_vel = Vector(x: vel_tuple.x, y: vel_tuple.y, z: vel_tuple.z)
        return Projectile(position: new_pos, velocity: new_vel)
    }
}
