//
//  Ch02.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 25/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class Ch02: XCTestCase {

    func testPuttingItTogether() {
        let c = Canvas(w: 900, h: 550)
        let start = Point(x: 0, y: 1, z: 0)
        let vel_tup = Vector(x: 1, y: 1.8, z: 0).normalize() * 11.25
        let velocity = Vector(x: vel_tup.x, y: vel_tup.y, z: vel_tup.z)
        
        let e = Environment(gravity: Vector(x: 0, y: -0.1, z: 0), wind: Vector(x: -0.01, y: 0, z: 0))
        var p = Projectile(position: start, velocity: velocity)
        
        while p.position.y > 0 {
            p = e.tick(proj: p)
            c.write_pixel(x: Int(p.position.x), y: (550 - Int(p.position.y)), color: Color(r: 1, g: 0, b: 0))
        }
        
        let ppm = c.canvas_to_ppm()
        try! ppm.write(to: URL(fileURLWithPath: "B5Chapter2.ppm"), atomically: true, encoding: .utf8)
    }
}
