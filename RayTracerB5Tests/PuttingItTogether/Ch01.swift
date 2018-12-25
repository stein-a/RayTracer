//
//  Ch01.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 25/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class Ch01: XCTestCase {

    func testPuttingItTogether() {
        var p = Projectile(position: Point(x: 0, y: 1, z: 0), velocity: Vector(x: 1, y: 1, z: 0).normalize())
        let e = Environment(gravity: Vector(x: 0, y: -0.1, z: 0), wind: Vector(x: -0.01, y: 0, z: 0))
        
        while p.position.y > 0 {
            p = e.tick(proj: p)
            print("Y = \(p.position.y)", "X = \(p.position.x)")
        }
    }
}
