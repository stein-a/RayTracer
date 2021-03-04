//
//  ShadowPuppets.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 25/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class ShadowPuppets: XCTestCase {

    func testShadowPuppets() {
        let world = World()
        
        let camera = Camera(hsize: 800, vsize: 400, field_of_view: .pi/6)
        camera.transform = Matrix4.viewTransform(from: Point(x: 40, y: 0, z: -70),
                                                to: Point(x: 0, y: 0, z: -5),
                                                up: Vector(x: 0, y: 1, z: 0))
        
        let light = PointLight(pos: Point(x: 0, y: 0, z: -100),
                               int: Color(r: 1, g: 1, b: 1))
        world.light = light
        
        let wristMaterial = Material()
        wristMaterial.ambient = 0.2
        wristMaterial.diffuse = 0.8
        wristMaterial.specular = 0.3
        wristMaterial.shininess = 200
        wristMaterial.color = Color(r: 0.1, g: 1, b: 1)
        
        let palmMaterial = Material()
        palmMaterial.ambient = 0.2
        palmMaterial.diffuse = 0.8
        palmMaterial.specular = 0.3
        palmMaterial.shininess = 200
        palmMaterial.color = Color(r: 0.1, g: 0.1, b: 1)
        
        let thumbMaterial = Material()
        thumbMaterial.ambient = 0.2
        thumbMaterial.diffuse = 0.8
        thumbMaterial.specular = 0.3
        thumbMaterial.shininess = 200
        thumbMaterial.color = Color(r: 0.1, g: 0.1, b: 1)
        
        let indexMaterial = Material()
        indexMaterial.ambient = 0.2
        indexMaterial.diffuse = 0.8
        indexMaterial.specular = 0.3
        indexMaterial.shininess = 200
        indexMaterial.color = Color(r: 1, g: 1, b: 0.1)
        
        let middleMaterial = Material()
        middleMaterial.ambient = 0.2
        middleMaterial.diffuse = 0.8
        middleMaterial.specular = 0.3
        middleMaterial.shininess = 200
        middleMaterial.color = Color(r: 0.1, g: 1, b: 0.5)
        
        let ringMaterial = Material()
        ringMaterial.ambient = 0.2
        ringMaterial.diffuse = 0.8
        ringMaterial.specular = 0.3
        ringMaterial.shininess = 200
        ringMaterial.color = Color(r: 0.1, g: 1, b: 0.1)
        
        let pinkyMaterial = Material()
        pinkyMaterial.ambient = 0.2
        pinkyMaterial.diffuse = 0.8
        pinkyMaterial.specular = 0.3
        pinkyMaterial.shininess = 200
        pinkyMaterial.color = Color(r: 0.1, g: 0.5, b: 1)
        
        let sphere = Sphere()
        sphere.material.color = Color(r: 1, g: 1, b: 1)
        sphere.material.ambient = 0
        sphere.material.diffuse = 0.5
        sphere.material.specular = 0
        sphere.transform =  Matrix4.translation(x: 0, y: 0, z: 20) *
            Matrix4.scaling(x: 200, y: 200, z: 0.01)
        world.objects.append(sphere)
        
        let wrist = Sphere()
        wrist.material = wristMaterial
        wrist.transform =   Matrix4.rotation_z(r: .pi/4) *
            Matrix4.translation(x: -4, y: 0, z: -21) *
            Matrix4.scaling(x: 3, y: 3, z: 3)
        world.objects.append(wrist)
        
        let palm = Sphere()
        palm.material = palmMaterial
        palm.transform =    Matrix4.translation(x: 0, y: 0, z: -15) *
            Matrix4.scaling(x: 4, y: 3, z: 3)
        world.objects.append(palm)
        
        let thumb = Sphere()
        thumb.material = thumbMaterial
        thumb.transform =   Matrix4.translation(x: -2, y: 2, z: -16) *
            Matrix4.scaling(x: 1, y: 3, z: 1)
        world.objects.append(thumb)
        
        let index = Sphere()
        index.material = indexMaterial
        index.transform =   Matrix4.translation(x: 3, y: 2, z: -22) *
            Matrix4.scaling(x: 3, y: 0.75, z: 0.75)
        world.objects.append(index)
        
        let middle = Sphere()
        middle.material = middleMaterial
        middle.transform =  Matrix4.translation(x: 4, y: 1, z: -19) *
            Matrix4.scaling(x: 3, y: 0.75, z: 0.75)
        world.objects.append(middle)
        
        let ring = Sphere()
        ring.material = ringMaterial
        ring.transform =    Matrix4.translation(x: 4, y: 0, z: -18) *
            Matrix4.scaling(x: 3, y: 0.75, z: 0.75)
        world.objects.append(ring)
        
        let pinky = Sphere()
        pinky.material = pinkyMaterial
        pinky.transform =   Matrix4.translation(x: 3, y: -1.5, z: -20) *
            Matrix4.rotation_z(r: -.pi/10) *
            Matrix4.translation(x: 1, y: 0, z: 0) *
            Matrix4.scaling(x: 2.5, y: 0.6, z: 0.6)
        world.objects.append(pinky)
        
        let image = camera.render(world: world)
        
        let ppm = image.canvas_to_ppm()
        try! ppm.write(to: URL(fileURLWithPath: "B5Puppets.ppm"),
                       atomically: true, encoding: .utf8)
    }
}
