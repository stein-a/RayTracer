//
//  Cylinders.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 03/01/2019.
//  Copyright © 2019 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class Cylinders: XCTestCase {

    func testCylinders() {
        let world = World()
        
        let camera = Camera(hsize: 800, vsize: 400, field_of_view: .pi/10)
        camera.transform = Matrix.viewTransform(
            from: Point(x: 8, y: 3.5, z: -9),
            to: Point(x: 0, y: 0.3, z: 0),
            up: Vector(x: 0, y: 1, z: 0))

        let light = PointLight(pos: Point(x: 1, y: 6.9, z: -4.9),
                               int: Color(r: 1, g: 1, b: 1))
        world.light = light
        
        let floor = Plane()
        floor.material.pattern =
            ThreeDCheckerPattern(a: Color(r: 0.5, g: 0.5, b: 0.5),
                                 b: Color(r: 0.75, g: 0.75, b: 0.75))
        floor.material.pattern!.transform =
                        Matrix.rotation_y(r: 0.3) *
                        Matrix.scaling(x: 0.25, y: 0.25, z: 0.25)
        floor.material.ambient = 0.2
        floor.material.diffuse = 0.9
        floor.material.specular = 0
        world.objects.append(floor)
            
        let cyl1 = Cylinder()
        cyl1.minimum = 0
        cyl1.maximum = 0.75
        cyl1.closed = true
        cyl1.transform = Matrix.translation(x: -1, y: 0, z: 1) *
                        Matrix.scaling(x: 0.5, y: 1, z: 0.5)
        cyl1.material.color = Color(r: 0, g: 0, b: 0.6)
        cyl1.material.diffuse = 0.1
        cyl1.material.specular = 0.9
        cyl1.material.shininess = 300
        cyl1.material.reflectivity = 0.9
        world.objects.append(cyl1)
        
        let con1 = Cylinder()
        con1.minimum = 0
        con1.maximum = 0.2
        con1.closed = false
        con1.transform = Matrix.translation(x: 1, y: 0, z: 0) *
                        Matrix.scaling(x: 0.8, y: 1, z: 0.8)
        con1.material.color = Color(r: 1, g: 1, b: 0.3)
        con1.material.ambient = 0.1
        con1.material.diffuse = 0.8
        con1.material.specular = 0.9
        con1.material.shininess = 300
        world.objects.append(con1)
        
        let con2 = Cylinder()
        con2.minimum = 0
        con2.maximum = 0.3
        con2.closed = false
        con2.transform = Matrix.translation(x: 1, y: 0, z: 0) *
            Matrix.scaling(x: 0.6, y: 1, z: 0.6)
        con2.material.color = Color(r: 1, g: 0.9, b: 0.4)
        con2.material.ambient = 0.1
        con2.material.diffuse = 0.8
        con2.material.specular = 0.9
        con2.material.shininess = 300
        world.objects.append(con2)
        
        let con3 = Cylinder()
        con3.minimum = 0
        con3.maximum = 0.4
        con3.closed = false
        con3.transform = Matrix.translation(x: 1, y: 0, z: 0) *
            Matrix.scaling(x: 0.4, y: 1, z: 0.4)
        con3.material.color = Color(r: 1, g: 0.8, b: 0.5)
        con3.material.ambient = 0.1
        con3.material.diffuse = 0.8
        con3.material.specular = 0.9
        con3.material.shininess = 300
        world.objects.append(con3)
        
        let con4 = Cylinder()
        con4.minimum = 0
        con4.maximum = 0.5
        con4.closed = false
        con4.transform = Matrix.translation(x: 1, y: 0, z: 0) *
            Matrix.scaling(x: 0.2, y: 1, z: 0.2)
        con4.material.color = Color(r: 1, g: 0.7, b: 0.6)
        con4.material.ambient = 0.1
        con4.material.diffuse = 0.8
        con4.material.specular = 0.9
        con4.material.shininess = 300
        world.objects.append(con4)
        
        let dec1 = Cylinder()
        dec1.minimum = 0
        dec1.maximum = 0.3
        dec1.closed = true
        dec1.transform = Matrix.translation(x: 0, y: 0, z: -0.75) *
            Matrix.scaling(x: 0.05, y: 1, z: 0.05)
        dec1.material.color = Color(r: 1, g: 0, b: 0)
        dec1.material.ambient = 0.1
        dec1.material.diffuse = 0.9
        dec1.material.specular = 0.9
        dec1.material.shininess = 300
        world.objects.append(dec1)
        
        let dec2 = Cylinder()
        dec2.minimum = 0
        dec2.maximum = 0.3
        dec2.closed = true
        dec2.transform = Matrix.translation(x: 0, y: 0, z: -2.25) *
            Matrix.rotation_y(r: -0.15) *
            Matrix.translation(x: 0, y: 0, z: 1.5) *
            Matrix.scaling(x: 0.05, y: 1, z: 0.05)
        dec2.material.color = Color(r: 1, g: 1, b: 0)
        dec2.material.ambient = 0.1
        dec2.material.diffuse = 0.9
        dec2.material.specular = 0.9
        dec2.material.shininess = 300
        world.objects.append(dec2)
        
        let dec3 = Cylinder()
        dec3.minimum = 0
        dec3.maximum = 0.3
        dec3.closed = true
        dec3.transform = Matrix.translation(x: 0, y: 0, z: -2.25) *
            Matrix.rotation_y(r: -0.3) *
            Matrix.translation(x: 0, y: 0, z: 1.5) *
            Matrix.scaling(x: 0.05, y: 1, z: 0.05)
        dec3.material.color = Color(r: 0, g: 1, b: 0)
        dec3.material.ambient = 0.1
        dec3.material.diffuse = 0.9
        dec3.material.specular = 0.9
        dec3.material.shininess = 300
        world.objects.append(dec3)
        
        let dec4 = Cylinder()
        dec4.minimum = 0
        dec4.maximum = 0.3
        dec4.closed = true
        dec4.transform = Matrix.translation(x: 0, y: 0, z: -2.25) *
            Matrix.rotation_y(r: -0.45) *
            Matrix.translation(x: 0, y: 0, z: 1.5) *
            Matrix.scaling(x: 0.05, y: 1, z: 0.05)
        dec4.material.color = Color(r: 0, g: 1, b: 1)
        dec4.material.ambient = 0.1
        dec4.material.diffuse = 0.9
        dec4.material.specular = 0.9
        dec4.material.shininess = 300
        world.objects.append(dec4)
        
        let gcyl = Cylinder()
        gcyl.minimum = 0.0001
        gcyl.maximum = 0.5
        gcyl.closed = true
        gcyl.transform = Matrix.translation(x: 0, y: 0, z: -1.5) *
                        Matrix.scaling(x: 0.33, y: 1, z: 0.33)
        gcyl.material.color = Color(r: 0.25, g: 0, b: 0)
        gcyl.material.diffuse = 0.1
        gcyl.material.specular = 0.9
        gcyl.material.shininess = 300
        gcyl.material.reflectivity = 0.9
        gcyl.material.transparency = 0.9
        gcyl.material.refractiveIndex = 1.5
        world.objects.append(gcyl)
        
        let image = camera.render(world: world)
        
        let ppm = image.canvas_to_ppm()
        try! ppm.write(to: URL(fileURLWithPath: "B5Cylinders.ppm"),
                       atomically: true, encoding: .utf8)
    }
}
