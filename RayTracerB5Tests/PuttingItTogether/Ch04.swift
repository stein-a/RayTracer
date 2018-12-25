//
//  Ch04.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 25/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class Ch04: XCTestCase {

    func testPuttingItTogether() {
        let c = Canvas(w: 800, h: 800)
        
        let twelve = Point(x: 0, y: 0, z: 1)
        c.write_pixel(x: 400, y: 700, color: Color(r: 1, g: 1, b: 1))
        
        for idx in 1...11 {
            let r = Matrix.rotation_y(r: .pi/6 * Float(idx))
            let pos = r * twelve
            c.write_pixel(x: 400 + Int(300 * pos.x), y: 400 + Int(300 * pos.z), color: Color(r: 1, g: 1, b: 1))
        }
        let ppm = c.canvas_to_ppm()
        try! ppm.write(to: URL(fileURLWithPath: "B5Chapter4.ppm"), atomically: true, encoding: .utf8)

    }
}
