//
//  Ch07.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 25/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class Ch07: XCTestCase {

    func testPuttingItTogether() {
        let floor = Sphere()
        floor.transform = Matrix4.scaling(x: 10, y: 0.01, z: 10)
        floor.material = Material()
        floor.material.color = Color(r: 1, g: 0.9, b: 0.9)
        floor.material.specular = 0
        
        let left_wall = Sphere()
        left_wall.transform = Matrix4.translation(x: 0, y: 0, z: 5) *
            Matrix4.rotation_y(r: -.pi/4) * Matrix4.rotation_x(r: .pi/2) * Matrix4.scaling(x: 10, y: 0.01, z: 10)
        left_wall.material = floor.material
        
        let right_wall = Sphere()
        right_wall.transform = Matrix4.translation(x: 0, y: 0, z: 5) *
            Matrix4.rotation_y(r: .pi/4) * Matrix4.rotation_x(r: .pi/2) * Matrix4.scaling(x: 10, y: 0.01, z: 10)
        right_wall.material = floor.material
        
        let middle = Sphere()
        middle.transform = Matrix4.translation(x: -0.5, y: 1, z: 0.5)
        middle.material = Material()
        middle.material.color = Color(r: 0.1, g: 1, b: 0.5)
        middle.material.diffuse = 0.7
        middle.material.specular = 0.3
        
        let right = Sphere()
        right.transform = Matrix4.translation(x: 1.5, y: 0.5, z: -0.5) * Matrix4.scaling(x: 0.5, y: 0.5, z: 0.5)
        right.material = Material()
        right.material.color = Color(r: 0.5, g: 1, b: 0.1)
        right.material.diffuse = 0.7
        right.material.specular = 0.3
        
        let left = Sphere()
        left.transform = Matrix4.translation(x: -1.5, y: 0.5, z: -0.5) * Matrix4.scaling(x: 0.3, y: 0.3, z: 0.3)
        left.material = Material()
        left.material.color = Color(r: 1, g: 0, b: 0)
        left.material.diffuse = 0.7
        left.material.specular = 0.3
        
        let world = World()
        world.light = PointLight(pos: Point(x: -10, y: 10, z: -10), int: Color(r: 1, g: 1, b: 1))
        world.objects.append(floor)
        world.objects.append(left_wall)
        world.objects.append(right_wall)
        world.objects.append(middle)
        world.objects.append(right)
        world.objects.append(left)
        
        let camera = Camera(hsize: 1000, vsize: 500 , field_of_view: .pi/3)
        camera.transform = Matrix4.viewTransform(from: Point(x: 0, y: 1.5, z: -5),
                                                to: Point(x: 0, y: 1, z: 0), up: Vector(x: 0, y: 1, z: 0))
        let image = camera.render(world: world)
        
        let ppm = image.canvas_to_ppm()
        try! ppm.write(to: URL(fileURLWithPath: "B5Chapter7.ppm"), atomically: true, encoding: .utf8)

    }
}
