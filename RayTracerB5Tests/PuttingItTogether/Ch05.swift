//
//  Ch05.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 25/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class Ch05: XCTestCase {

    func testPuttingItTogether() {
        let canvas_pixels : Double = 100
        let wall_size : Double = 7.0
        let half : Double = wall_size / 2
        let pixel_size : Double = wall_size / canvas_pixels
        let wall_z : Double = 10
        let ray_origin = Point(x: 0, y: 0, z: -5)
        
        let canvas = Canvas(w: Int(canvas_pixels), h: Int(canvas_pixels))
        let color = Color(r: 1, g: 0, b: 0)
        
        for y in 0..<Int(canvas_pixels) {
            let world_y = half - pixel_size * Double(y)
            
            for x in 0..<Int(canvas_pixels) {
                let world_x = -half + pixel_size * Double(x)
                
                let position = Point(x: world_x, y: world_y, z: wall_z)
                let dir = (position - ray_origin).normalize()
                let r = Ray(orig: ray_origin, dir: dir)
                let s = Sphere()
                // s.transform = Matrix.scaling(x: 1, y: 0.5, z: 1)
                let xs = s.intersect(ray: r)
                
                if xs.hit() != nil {
                    canvas.write_pixel(x: x, y: y, color: color)
                }
            }
        }
        let ppm = canvas.canvas_to_ppm()
        try! ppm.write(to: URL(fileURLWithPath: "B5Chapter5.ppm"), atomically: true, encoding: .utf8)

    }
}
