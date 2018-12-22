//
//  TestScenes.swift
//  RayTracerB4Tests
//
//  Created by Stein Alver on 27/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class TestScenes: XCTestCase {

    func testCh08Puppets() {
        
        let world = World()
        
        // - add: camera
        // width: 400
        // height: 200
        // field-of-view: 30
        // from: [ 40, 0, -70 ]
        // to: [ 0, 0, -5 ]
        //up: [ 0, 1, 0 ]
        let camera = Camera(hsize: 400, vsize: 200, field_of_view: .pi/6)
        camera.transform = Matrix.viewTransform(from: Point(x: 40, y: 0, z: -70),
                                                to: Point(x: 0, y: 0, z: -5),
                                                up: Vector(x: 0, y: 1, z: 0))
        
        // - add: light
        // at: [ 0, 0, -100 ]
        //intensity: [ 1, 1, 1 ]
        let light = PointLight(pos: Point(x: 0, y: 0, z: -100),
                               int: Color(r: 1, g: 1, b: 1))
        world.light = light
        
        // - define: sphere-material
        // value:
        // ambient: 0.2
        // diffuse: 0.8
        // specular: 0.3
        // shininess: 200
        
        // - define: wrist-material
        // extend: sphere-material
        // value:
        // color: [ 0.1, 1, 1 ]
        let wristMaterial = Material()
        wristMaterial.ambient = 0.2
        wristMaterial.diffuse = 0.8
        wristMaterial.specular = 0.3
        wristMaterial.shininess = 200
        wristMaterial.color = Color(r: 0.1, g: 1, b: 1)

        // - define: palm-material
        // extend: sphere-material
        // value:
        // color: [ 0.1, 0.1, 1 ]
        let palmMaterial = Material()
        palmMaterial.ambient = 0.2
        palmMaterial.diffuse = 0.8
        palmMaterial.specular = 0.3
        palmMaterial.shininess = 200
        palmMaterial.color = Color(r: 0.1, g: 0.1, b: 1)
        
        // - define: thumb-material
        // extend: sphere-material
        // value:
        // color: [ 0.1, 0.1, 1 ]
        let thumbMaterial = Material()
        thumbMaterial.ambient = 0.2
        thumbMaterial.diffuse = 0.8
        thumbMaterial.specular = 0.3
        thumbMaterial.shininess = 200
        thumbMaterial.color = Color(r: 0.1, g: 0.1, b: 1)
        
        // - define: index-material
        // extend: sphere-material
        // value:
        // color: [ 1, 1, 0.1 ]
        let indexMaterial = Material()
        indexMaterial.ambient = 0.2
        indexMaterial.diffuse = 0.8
        indexMaterial.specular = 0.3
        indexMaterial.shininess = 200
        indexMaterial.color = Color(r: 1, g: 1, b: 0.1)
        
        // - define: middle-material
        // extend: sphere-material
        // value:
        // color: [ 0.1, 1, 0.5 ]
        let middleMaterial = Material()
        middleMaterial.ambient = 0.2
        middleMaterial.diffuse = 0.8
        middleMaterial.specular = 0.3
        middleMaterial.shininess = 200
        middleMaterial.color = Color(r: 0.1, g: 1, b: 0.5)
        
        // - define: ring-material
        // extend: sphere-material
        // value:
        // color: [ 0.1, 1, 0.1 ]
        let ringMaterial = Material()
        ringMaterial.ambient = 0.2
        ringMaterial.diffuse = 0.8
        ringMaterial.specular = 0.3
        ringMaterial.shininess = 200
        ringMaterial.color = Color(r: 0.1, g: 1, b: 0.1)
        
        // - define: pinky-material
        // extend: sphere-material
        // value:
        // color: [ 0.1, 0.5, 1 ]
        let pinkyMaterial = Material()
        pinkyMaterial.ambient = 0.2
        pinkyMaterial.diffuse = 0.8
        pinkyMaterial.specular = 0.3
        pinkyMaterial.shininess = 200
        pinkyMaterial.color = Color(r: 0.1, g: 0.5, b: 1)
        
        // - add: sphere
        // material:
        // color: [ 1, 1, 1 ]
        // ambient: 0
        // diffuse: 0.5
        // specular: 0
        // transform:
        // - [ scale, 200, 200, 0.01 ]
        // - [ translate, 0, 0, 20 ]
        let sphere = Sphere()
        sphere.material.color = Color(r: 1, g: 1, b: 1)
        sphere.material.ambient = 0
        sphere.material.diffuse = 0.5
        sphere.material.specular = 0
        sphere.transform =  Matrix.translation(x: 0, y: 0, z: 20) *
                            Matrix.scaling(x: 200, y: 200, z: 0.01)
        world.objects.append(sphere)
        
        // # the wrist
        // - add: sphere
        // material: wrist-material
        // transform:
        // - [ scale, 3, 3, 3 ]
        // - [ translate, -4, 0, -21 ]
        // - [ rotate-z, 0.785398163397448 ] # pi/4
        let wrist = Sphere()
        wrist.material = wristMaterial
        wrist.transform =   Matrix.rotation_z(r: .pi/4) *
                            Matrix.translation(x: -4, y: 0, z: -21) *
                            Matrix.scaling(x: 3, y: 3, z: 3)
        world.objects.append(wrist)
        
        // # the palm
        // - add: sphere
        // material: palm-material
        // transform:
        // - [ scale, 4, 3, 3 ]
        // - [ translate, 0, 0, -15 ]
        let palm = Sphere()
        palm.material = palmMaterial
        palm.transform =    Matrix.translation(x: 0, y: 0, z: -15) *
                            Matrix.scaling(x: 4, y: 3, z: 3)
        world.objects.append(palm)
        
        // # the thumb
        // - add: sphere
        // material: thumb-material
        // transform:
        // - [ scale, 1, 3, 1 ]
        // - [ translate, -2, 2, -16 ]
        let thumb = Sphere()
        thumb.material = thumbMaterial
        thumb.transform =   Matrix.translation(x: -2, y: 2, z: -16) *
                            Matrix.scaling(x: 1, y: 3, z: 1)
        world.objects.append(thumb)
        
        // # the index finger
        // - add: sphere
        // material: index-material
        // transform:
        // - [ scale, 3, 0.75, 0.75 ]
        // - [ translate, 3, 2, -22 ]
        let index = Sphere()
        index.material = indexMaterial
        index.transform =   Matrix.translation(x: 3, y: 2, z: -22) *
                            Matrix.scaling(x: 3, y: 0.75, z: 0.75)
        world.objects.append(index)
        
        // # the middle finger
        // - add: sphere
        // material: middle-material
        // transform:
        // - [ scale, 3, 0.75, 0.75 ]
        // - [ translate, 4, 1, -19 ]
        let middle = Sphere()
        middle.material = middleMaterial
        middle.transform =  Matrix.translation(x: 4, y: 1, z: -19) *
                            Matrix.scaling(x: 3, y: 0.75, z: 0.75)
        world.objects.append(middle)

        // # the ring finger
        // - add: sphere
        // material: ring-material
        // transform:
        // - [ scale, 3, 0.75, 0.75 ]
        // - [ translate, 4, 0, -18 ]
        let ring = Sphere()
        ring.material = ringMaterial
        ring.transform =    Matrix.translation(x: 4, y: 0, z: -18) *
                            Matrix.scaling(x: 3, y: 0.75, z: 0.75)
        world.objects.append(ring)
        
        // # the pinky finger
        // - add: sphere
        // material: pinky-material
        // transform:
        // - [ scale, 2.5, 0.6, 0.6 ]
        // - [ translate, 1, 0, 0 ]
        // - [ rotate-z, -0.314159265358979 ] # pi/10
        // - [ translate, 3, -1.5, -20]
        let pinky = Sphere()
        pinky.material = pinkyMaterial
        pinky.transform =   Matrix.translation(x: 3, y: -1.5, z: -20) *
                            Matrix.rotation_z(r: -.pi/10) *
                            Matrix.translation(x: 1, y: 0, z: 0) *
                            Matrix.scaling(x: 2.5, y: 0.6, z: 0.6)
        world.objects.append(pinky)
        
        
        let image = camera.render(world: world)
        
        let ppm = image.canvas_to_ppm()
        try! ppm.write(to: URL(fileURLWithPath: "B5Puppets.ppm"),
                            atomically: true, encoding: .utf8)
    }
    
    func testCh11ReflectRefract() {
        
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
