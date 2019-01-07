//
//  ObjFiles.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 07/01/2019.
//  Copyright © 2019 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class ObjFiles: XCTestCase {

    func testTeapot() {
        let world = World()
        
        let camera = Camera(hsize: 200, vsize: 200, field_of_view: .pi/2)
        camera.transform = Matrix.viewTransform(
            from: Point(x: -10, y: -20, z: -10),
            to: Point(x: 20, y: 20, z: 20),
            up: Vector(x: 0, y: 1, z: 0))
        
        let light = PointLight(pos: Point(x: -10, y: -10, z: -10),
                               int: Color(r: 1, g: 1, b: 1))
        world.light = light
        
        let file = try! String.init(contentsOfFile: "/Users/salver/Development/RayTracerB5/RayTracerB5Tests/OBJfiles/bigteapot.obj")
        let parser = Parser()
        parser.parseObj(file: file)
        let g = parser.ObjToGroup()
//        g.transform =   Matrix.rotation_z(r: .pi/2) *
        g.transform =   Matrix.rotation_y(r: .pi/4) *
                        Matrix.rotation_x(r: .pi/2)
        g.material.color = Color(r: 1, g: 0, b: 0)
        g.material.shininess = 300
        g.material.reflectivity = 0.8
        
        world.objects.append(g)
        
        let image = camera.render(world: world)
        
        let ppm = image.canvas_to_ppm()
        try! ppm.write(to: URL(fileURLWithPath: "B5Teapot.ppm"),
                       atomically: true, encoding: .utf8)

    }
}
