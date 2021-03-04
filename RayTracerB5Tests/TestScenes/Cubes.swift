//
//  Cubes.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 04/01/2019.
//  Copyright © 2019 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class Cubes: XCTestCase {

    func testTable() {
        let world = World()
        let camera = Camera(hsize: 800, vsize: 400, field_of_view: 0.785)
        camera.transform = Matrix4.viewTransform(from: Point(x: 8, y: 6, z: -8),
                                                to: Point(x: 0, y: 3, z: 0),
                                                up: Vector(x: 0, y: 1, z: 0))
        let light = PointLight(pos: Point(x: 0, y: 6.9, z: -5),
                               int: Color(r: 1, g: 1, b: 0.9))
        world.light = light
        
        let floor = Cube()
        floor.transform = Matrix4.scaling(x: 20, y: 7, z: 20) *
                            Matrix4.translation(x: 0, y: 1, z: 0)
        floor.material.pattern =
                    ThreeDCheckerPattern(a: Color(r: 0, g: 0, b: 0),
                                         b: Color(r: 0.25, g: 0.25, b: 0.25))
        floor.material.pattern?.transform =
                            Matrix4.scaling(x: 0.07, y: 0.07, z: 0.07)
        floor.material.ambient = 0.25
        floor.material.diffuse = 0.7
        floor.material.specular = 0.9
        floor.material.shininess = 300
        floor.material.reflectivity = 0.1
        world.objects.append(floor)

        let walls = Cube()
        walls.transform = Matrix4.scaling(x: 10, y: 10, z: 10)
        walls.material.pattern =
                    ThreeDCheckerPattern(a: Color(r: 0.4863, g: 0.3765, b: 0.2941),
                                         b: Color(r: 0.3725, g: 0.2902, b: 0.2275))
        walls.material.pattern?.transform =
                            Matrix4.scaling(x: 0.05, y: 20, z: 0.05)
        walls.material.ambient = 0.1
        walls.material.diffuse = 0.7
        walls.material.specular = 0.9
        walls.material.shininess = 300
        walls.material.reflectivity = 0.1
        world.objects.append(walls)

        let top = Cube()
        top.transform = Matrix4.translation(x: 0, y: 3.1, z: 0) *
                        Matrix4.scaling(x: 3, y: 0.1, z: 2)
        top.material.pattern =
                    StripePattern(a: Color(r: 0.5529, g: 0.4235, b: 0.3255),
                                  b: Color(r: 0.6588, g: 0.5098, b: 0.4000))
        top.material.pattern?.transform =
                            Matrix4.scaling(x: 0.05, y: 0.05, z: 0.05) *
                            Matrix4.rotation_y(r: 0.1)
        top.material.ambient = 0.1
        top.material.diffuse = 0.7
        top.material.specular = 0.9
        top.material.shininess = 300
        top.material.reflectivity = 0.2
        world.objects.append(top)

        let leg1 = Cube()
        leg1.transform = Matrix4.translation(x: 2.7, y: 1.5, z: -1.7) *
                        Matrix4.scaling(x: 0.1, y: 1.5, z: 0.1)
        leg1.material.color = Color(r: 0.5529, g: 0.4235, b: 0.3255)
        leg1.material.ambient = 0.2
        leg1.material.diffuse = 0.7
        world.objects.append(leg1)
        
        let leg2 = Cube()
        leg2.transform = Matrix4.translation(x: 2.7, y: 1.5, z: 1.7) *
            Matrix4.scaling(x: 0.1, y: 1.5, z: 0.1)
        leg2.material.color = Color(r: 0.5529, g: 0.4235, b: 0.3255)
        leg2.material.ambient = 0.2
        leg2.material.diffuse = 0.7
        world.objects.append(leg2)
        
        let leg3 = Cube()
        leg3.transform = Matrix4.translation(x: -2.7, y: 1.5, z: -1.7) *
            Matrix4.scaling(x: 0.1, y: 1.5, z: 0.1)
        leg3.material.color = Color(r: 0.5529, g: 0.4235, b: 0.3255)
        leg3.material.ambient = 0.2
        leg3.material.diffuse = 0.7
        world.objects.append(leg3)
        
        let leg4 = Cube()
        leg4.transform = Matrix4.translation(x: -2.7, y: 1.5, z: 1.7) *
            Matrix4.scaling(x: 0.1, y: 1.5, z: 0.1)
        leg4.material.color = Color(r: 0.5529, g: 0.4235, b: 0.3255)
        leg4.material.ambient = 0.2
        leg4.material.diffuse = 0.7
        world.objects.append(leg4)
        
        let glass = Cube()
        glass.transform = Matrix4.translation(x: 0, y: 3.45001, z: 0) *
                            Matrix4.rotation_y(r: 0.2) *
                            Matrix4.scaling(x: 0.25, y: 0.25, z: 0.25)
        glass.material.color = Color(r: 1, g: 1, b: 0.8)
        glass.material.ambient = 0
        glass.material.diffuse = 0.3
        glass.material.specular = 0.9
        glass.material.shininess = 300
        glass.material.reflectivity = 0.7
        glass.material.transparency = 0.7
        glass.material.refractiveIndex = 1.5
        world.objects.append(glass)
        
        let small1 = Cube()
        small1.transform = Matrix4.translation(x: 1, y: 3.35, z: -0.9) *
            Matrix4.rotation_y(r: -0.4) *
            Matrix4.scaling(x: 0.15, y: 0.15, z: 0.15)
        small1.material.color = Color(r: 1, g: 0.5, b: 0.5)
        small1.material.diffuse = 0.4
        small1.material.reflectivity = 0.6
        world.objects.append(small1)
        
        let small2 = Cube()
        small2.transform = Matrix4.translation(x: -1.5, y: 3.27, z: 0.3) *
            Matrix4.rotation_y(r: 0.4) *
            Matrix4.scaling(x: 0.15, y: 0.07, z: 0.15)
        small2.material.color = Color(r: 1, g: 1, b: 0.5)
        world.objects.append(small2)
        
        let small3 = Cube()
        small3.transform = Matrix4.translation(x: 0, y: 3.25, z: 1) *
            Matrix4.rotation_y(r: 0.4) *
            Matrix4.scaling(x: 0.2, y: 0.05, z: 0.05)
        small3.material.color = Color(r: 0.5, g: 1, b: 0.5)
        world.objects.append(small3)
        
        let small4 = Cube()
        small4.transform = Matrix4.translation(x: -0.6, y: 3.4, z: -1) *
            Matrix4.rotation_y(r: 0.8) *
            Matrix4.scaling(x: 0.05, y: 0.2, z: 0.05)
        small4.material.color = Color(r: 0.5, g: 0.5, b: 1)
        world.objects.append(small4)
        
        let small5 = Cube()
        small5.transform = Matrix4.translation(x: 2, y: 3.4, z: 1) *
            Matrix4.rotation_y(r: 0.8) *
            Matrix4.scaling(x: 0.05, y: 0.2, z: 0.05)
        small5.material.color = Color(r: 0.5, g: 1, b: 1)
        world.objects.append(small5)
        
        let frame1 = Cube()
        frame1.transform = Matrix4.translation(x: -10, y: 4, z: 1) *
                            Matrix4.scaling(x: 0.05, y: 1, z: 1)
        frame1.material.color = Color(r: 0.7098, g: 0.2471, b: 0.2196)
        frame1.material.diffuse = 0.6
        world.objects.append(frame1)
        
        let frame2 = Cube()
        frame2.transform = Matrix4.translation(x: -10, y: 3.4, z: 2.7) *
            Matrix4.scaling(x: 0.05, y: 0.4, z: 0.4)
        frame2.material.color = Color(r: 0.2667, g: 0.2706, b: 0.6902)
        frame2.material.diffuse = 0.6
        world.objects.append(frame2)
        
        let frame3 = Cube()
        frame3.transform = Matrix4.translation(x: -10, y: 4.6, z: 2.7) *
            Matrix4.scaling(x: 0.05, y: 0.4, z: 0.4)
        frame3.material.color = Color(r: 0.3098, g: 0.5961, b: 0.3098)
        frame3.material.diffuse = 0.6
        world.objects.append(frame3)
        
        let mirrorFrame = Cube()
        mirrorFrame.transform = Matrix4.translation(x: -2, y: 3.5, z: 9.95) *
            Matrix4.scaling(x: 5, y: 1.5, z: 0.05)
        mirrorFrame.material.color = Color(r: 0.3882, g: 0.2627, b: 0.1882)
        mirrorFrame.material.diffuse = 0.7
        world.objects.append(mirrorFrame)
        
        let mirror = Cube()
        mirror.transform = Matrix4.translation(x: -2, y: 3.5, z: 9.95) *
            Matrix4.scaling(x: 4.8, y: 1.4, z: 0.06)
        mirror.material.color = Color(r: 0, g: 0, b: 0)
        mirror.material.diffuse = 0
        mirror.material.ambient = 0
        mirror.material.specular = 1
        mirror.material.shininess = 300
        mirror.material.reflectivity = 1
        world.objects.append(mirror)
        
        let image = camera.render(world: world)
        
        let ppm = image.canvas_to_ppm()
        try! ppm.write(to: URL(fileURLWithPath: "B5CubeTable.ppm"),
                       atomically: true, encoding: .utf8)
    }
}
