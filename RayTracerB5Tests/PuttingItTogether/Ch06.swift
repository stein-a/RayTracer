//
//  Ch06.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 25/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class Ch06: XCTestCase {

    func testPuttingItTogether() {
        let canvas_pixels : Double = 100
        let wall_size : Double = 7.0
        let half : Double = wall_size / 2
        let pixel_size : Double = wall_size / canvas_pixels
        let wall_z : Double = 10
        let ray_origin = Point(x: 0, y: 0, z: -5)
        
        let canvas = Canvas(w: Int(canvas_pixels), h: Int(canvas_pixels))
        
        let sc = Color(r: 1, g: 0.2, b: 1)
        let s = Sphere()
        // s.transform = Matrix.scaling(x: 1, y: 0.5, z: 1)
        s.material.color = sc
        
        let light_position = Point(x: -10, y: 10, z: -10)
        let light_color = Color(r: 1, g: 1, b: 1)
        let light = PointLight(pos: light_position, int: light_color)
        
        for y in 0..<Int(canvas_pixels) {
            let world_y = half - pixel_size * Double(y)
            
            for x in 0..<Int(canvas_pixels) {
                let world_x = -half + pixel_size * Double(x)
                
                // describe the point on the wall that the ray will target
                let wall_point = Point(x: world_x, y: world_y, z: wall_z)
                
                let dir = (wall_point - ray_origin).normalize()
                let r = Ray(orig: ray_origin, dir: dir )
                let xs = s.intersect(ray: r)
                
                if let treff = xs.hit() {
                    let point = r.position(time: treff.t)
                    let normal = treff.object.normalAt(p: point, hit: treff)
                    let eye = -r.direction
                    let color = treff.object.material.lighting(light: light, object: s, point: point, eyev: eye, normalv: normal, in_shadow: false)
                    canvas.write_pixel(x: x, y: y, color: color)
                }
            }
        }
        let ppm = canvas.canvas_to_ppm()
        try! ppm.write(to: URL(fileURLWithPath: "B5Chapter6.ppm"), atomically: true, encoding: .utf8)
    }
}
