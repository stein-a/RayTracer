//
//  ReflectRefract.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 25/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class ReflectRefract: XCTestCase {

    func testReflectRefract() {
        let world = World()
        
        let camera = Camera(hsize: 400, vsize: 200, field_of_view: 1.152)
        camera.transform = Matrix.viewTransform(from: Point(x: -2.6, y: 1.5, z: -3.9),
                                                to: Point(x: -0.6, y: 1, z: -0.8),
                                                up: Vector(x: 0, y: 1, z: 0))
        
        let light = PointLight(pos: Point(x: -4.9, y: 4.9, z: -1),
                               int: Color(r: 1, g: 1, b: 1))
        world.light = light
        
        let floor = Plane()
        floor.transform = Matrix.rotation_y(r: .pi/10)
        floor.material.pattern = ThreeDCheckerPattern(a: Color(r: 0.35, g: 0.35, b: 0.35), b: Color(r: 0.65, g: 0.65, b: 0.65))
        floor.material.specular = 0
        floor.material.reflectivity = 0.4
        world.objects.append(floor)
        
        let ceiling = Plane()
        ceiling.transform = Matrix.translation(x: 0, y: 5, z: 0)
        ceiling.material.color = Color(r: 0.8, g: 0.8, b: 0.8)
        ceiling.material.ambient = 0.3
        ceiling.material.specular = 0
        world.objects.append(ceiling)
        
        let westWall = Plane()
        westWall.transform = Matrix.translation(x: -5, y: 0, z: 0) *
            Matrix.rotation_z(r: .pi/2) *
            Matrix.rotation_y(r: .pi/2)
        westWall.material.pattern =
            StripePattern(a: Color(r: 0.45, g: 0.45, b: 0.45),
                          b: Color(r: 0.55, g: 0.55, b: 0.55))
        westWall.material.pattern?.transform = Matrix.rotation_y(r: .pi/2) *
            Matrix.scaling(x: 0.25, y: 0.25, z: 0.25)
        westWall.material.ambient = 0
        westWall.material.diffuse = 0.4
        westWall.material.specular = 0
        westWall.material.reflectivity = 0.3
        world.objects.append(westWall)
        
        let eastWall = Plane()
        eastWall.transform = Matrix.translation(x: 5, y: 0, z: 0) *
            Matrix.rotation_z(r: .pi/2) *
            Matrix.rotation_y(r: .pi/2)
        eastWall.material.pattern =
            StripePattern(a: Color(r: 0.45, g: 0.45, b: 0.45),
                          b: Color(r: 0.55, g: 0.55, b: 0.55))
        eastWall.material.pattern?.transform = Matrix.rotation_y(r: .pi/2) *
            Matrix.scaling(x: 0.25, y: 0.25, z: 0.25)
        eastWall.material.ambient = 0
        eastWall.material.diffuse = 0.4
        eastWall.material.specular = 0
        eastWall.material.reflectivity = 0.3
        world.objects.append(eastWall)
        
        let northWall = Plane()
        northWall.transform = Matrix.translation(x: 0, y: 0, z: 5) *
            Matrix.rotation_x(r: .pi/2)
        northWall.material.pattern =
            StripePattern(a: Color(r: 0.45, g: 0.45, b: 0.45),
                          b: Color(r: 0.55, g: 0.55, b: 0.55))
        northWall.material.pattern?.transform = Matrix.rotation_y(r: .pi/2) *
            Matrix.scaling(x: 0.25, y: 0.25, z: 0.25)
        northWall.material.ambient = 0
        northWall.material.diffuse = 0.4
        northWall.material.specular = 0
        northWall.material.reflectivity = 0.3
        world.objects.append(northWall)
        
        let southWall = Plane()
        southWall.transform = Matrix.translation(x: 0, y: 0, z: -5) *
            Matrix.rotation_x(r: .pi/2)
        southWall.material.pattern =
            StripePattern(a: Color(r: 0.45, g: 0.45, b: 0.45),
                          b: Color(r: 0.55, g: 0.55, b: 0.55))
        southWall.material.pattern?.transform = Matrix.rotation_y(r: .pi/2) *
            Matrix.scaling(x: 0.25, y: 0.25, z: 0.25)
        southWall.material.ambient = 0
        southWall.material.diffuse = 0.4
        southWall.material.specular = 0
        southWall.material.reflectivity = 0.3
        world.objects.append(southWall)
        
        let back1 = Sphere()
        back1.transform = Matrix.translation(x: 4.6, y: 0.4, z: 1) *
            Matrix.scaling(x: 0.4, y: 0.4, z: 0.4)
        back1.material.color = Color(r: 0.8, g: 0.5, b: 0.3)
        back1.material.shininess = 50
        world.objects.append(back1)
        
        let back2 = Sphere()
        back2.transform = Matrix.translation(x: 4.7, y: 0.3, z: 0.4) *
            Matrix.scaling(x: 0.3, y: 0.3, z: 0.3)
        back2.material.color = Color(r: 0.9, g: 0.4, b: 0.5)
        back2.material.shininess = 50
        world.objects.append(back2)
        
        let back3 = Sphere()
        back3.transform = Matrix.translation(x: -1, y: 0.5, z: 4.5) *
            Matrix.scaling(x: 0.5, y: 0.5, z: 0.5)
        back3.material.color = Color(r: 0.4, g: 0.9, b: 0.6)
        back3.material.shininess = 50
        world.objects.append(back3)
        
        let back4 = Sphere()
        back4.transform = Matrix.translation(x: -1.7, y: 0.3, z: 4.7) *
            Matrix.scaling(x: 0.3, y: 0.3, z: 0.3)
        back4.material.color = Color(r: 0.4, g: 0.6, b: 0.9)
        back4.material.shininess = 50
        world.objects.append(back4)
        
        let red = Sphere()
        red.transform = Matrix.translation(x: -0.6, y: 1, z: 0.6)
        red.material.color = Color(r: 1, g: 0.3, b: 0.2)
        red.material.specular = 0.4
        red.material.shininess = 5
        world.objects.append(red)
        
        let blue = Sphere()
        blue.transform = Matrix.translation(x: 0.6, y: 0.7, z: -0.6) *
            Matrix.scaling(x: 0.7, y: 0.7, z: 0.7)
        blue.material.color = Color(r: 0, g: 0, b: 0.2)
        blue.material.ambient = 0
        blue.material.diffuse = 0.4
        blue.material.specular = 0.9
        blue.material.shininess = 300
        blue.material.reflectivity = 0.9
        blue.material.transparency = 0.9
        blue.material.refractiveIndex = 1.5
        world.objects.append(blue)
        
        let green = Sphere()
        green.transform = Matrix.translation(x: -0.7, y: 0.5, z: -0.8) *
            Matrix.scaling(x: 0.5, y: 0.5, z: 0.5)
        green.material.color = Color(r: 0, g: 0.2, b: 0)
        green.material.ambient = 0
        green.material.diffuse = 0.4
        green.material.specular = 0.9
        green.material.shininess = 300
        green.material.reflectivity = 0.9
        green.material.transparency = 0.9
        green.material.refractiveIndex = 1.5
        world.objects.append(green)
        
        let image = camera.render(world: world)
        
        let ppm = image.canvas_to_ppm()
        try! ppm.write(to: URL(fileURLWithPath: "B5Reflect.ppm"),
                       atomically: true, encoding: .utf8)
    }
}
