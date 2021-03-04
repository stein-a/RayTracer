//
//  Fresnel.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 13/12/2020.
//  Copyright © 2020 Stein Alver. All rights reserved.
//


import XCTest
@testable import RayTracerB5

class Fresnel: XCTestCase {

    func testFresnel() {
        
        let world = World()
        
        let camera = Camera(hsize: 600, vsize: 600, field_of_view: 0.45)
        camera.transform = Matrix4.viewTransform(
                            from: Point(x: 0.0, y: 0.0, z: -5.0),
                            to: Point(x: 0.0, y: 0.0, z: 0.0),
                            up: Vector(x: 0, y: 1, z: 0))
        
        let light = PointLight(pos: Point(x: 2.0, y: 10.0, z: -5.0),
                               int: Color(r: 0.9, g: 0.9, b: 0.9))
        world.light = light
        
        let wall = Plane()
        wall.transform = Matrix4.translation(x: 0, y: 0, z: 10) * Matrix4.rotation_x(r: 1.5708)
        wall.material.pattern = ThreeDCheckerPattern(a: Color(r: 0.15, g: 0.15, b: 0.15),
                                                     b: Color(r: 0.85, g: 0.85, b: 0.85))
        wall.material.ambient = 0.8
        wall.material.diffuse = 0.2
        wall.material.specular = 0
        world.objects.append(wall)
        
        let glassBall = Sphere()
        glassBall.material.color = Color(r: 1, g: 1, b: 1)
        glassBall.material.ambient = 0
        glassBall.material.diffuse = 0
        glassBall.material.specular = 0.9
        glassBall.material.shininess = 300
        glassBall.material.reflectivity = 0.9
        glassBall.material.transparency = 0.9
        glassBall.material.refractiveIndex = 1.5
        world.objects.append(glassBall)

        let hollowCenter = Sphere()
        hollowCenter.transform = Matrix4.scaling(x: 0.5, y: 0.5, z: 0.5)
        hollowCenter.material.color = Color(r: 1, g: 1, b: 1)
        hollowCenter.material.ambient = 0
        hollowCenter.material.diffuse = 0
        hollowCenter.material.specular = 0.9
        hollowCenter.material.shininess = 300
        hollowCenter.material.reflectivity = 0.9
        hollowCenter.material.transparency = 0.9
        hollowCenter.material.refractiveIndex = 1.0000034
        world.objects.append(hollowCenter)

        let image = camera.renderParallell(world: world)
        
        let ppm = image.canvas_to_ppm()
        try! ppm.write(to: URL(fileURLWithPath: "B5Fresnel.ppm"),
                       atomically: true, encoding: .utf8)
    }
}
