//
//  Projectile.swift
//  RayTracerB4
//
//  Created by Stein Alver on 15/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Projectile {
    
    var position: Point
    var velocity: Vector
    
    init(position: Point, velocity: Vector) {
        self.position = position
        self.velocity = velocity
    }
}
