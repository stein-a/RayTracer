//
//  CameraFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class CameraFeatures: XCTestCase {

    // Scenario: Constructing a camera
    // Given hsize ← 160 And vsize ← 120 And field_of_view ← π/2
    // When c ← camera(hsize, vsize, field_of_view)
    // Then c.hsize = 160 And c.vsize = 120 And c.field_of_view = π/2 And c.transform = identity_matrix
    func testConstructingACamera() {
        let hsize : Double = 160
        let vsize : Double = 120
        let field_of_view : Double = .pi/Double(2)
        
        let c = Camera(hsize: hsize, vsize: vsize, field_of_view: field_of_view)
        
        XCTAssertTrue(c.hsize == hsize)
        XCTAssertTrue(c.vsize == vsize)
        XCTAssertTrue(c.field_of_view == field_of_view)
        XCTAssertTrue(c.transform == Matrix.identity())
    }
    
    // Scenario: The pixel size for a horizontal canvas
    // Given c ← camera(200, 125, π/2) Then c.pixel_size = 0.01
    func testThePixelSizeForAHorisontalCanvas() {
        let c = Camera(hsize: 200, vsize: 125, field_of_view: .pi/2)
        XCTAssertEqual(c.pixel_size, 0.01, accuracy: epsilon)
    }
    
    // Scenario: The pixel size for a vertical canvas
    // Given c ← camera(125, 200, π/2) Then c.pixel_size = 0.01
    func testThePixelSizeForVerticalCanvas() {
        let c = Camera(hsize: 125, vsize: 200, field_of_view: .pi/2)
        XCTAssertEqual(c.pixel_size, 0.01, accuracy: epsilon)
    }
    
    // Scenario: Construct a ray through the center of the canvas
    // Given c ← camera(201, 101, π/2) When r ← ray_for_pixel(c, 100, 50)
    // Then r.origin = point(0, 0, 0) And r.direction = vector(0, 0, -1)
    func testConstructARayThroughTheCenterOfTheCanvas() {
        let c = Camera(hsize: 201, vsize: 101, field_of_view: .pi/2)
        let r = c.ray_for_pixel(px: 100, py: 50)
        XCTAssertEqual(r.origin, Point(x: 0, y: 0, z: 0))
        XCTAssertEqual(r.direction, Vector(x: 0, y: 0, z: -1))
    }
    
    // Scenario: Construct a ray through a corner of the canvas
    // Given c ← camera(201, 101, π/2) When r ← ray_for_pixel(c, 0, 0)
    // Then r.origin = point(0, 0, 0) And r.direction = vector(0.66519, 0.33259, -0.66851)
    func testConstructARayThroughACornerOfTheCanvas() {
        let c = Camera(hsize: 201, vsize: 101, field_of_view: .pi/2)
        let r = c.ray_for_pixel(px: 0, py: 0)
        XCTAssertEqual(r.origin, Point(x: 0, y: 0, z: 0))
        XCTAssertEqual(r.direction.x, 0.66519, accuracy: epsilon)
        XCTAssertEqual(r.direction.y, 0.33259, accuracy: epsilon)
        XCTAssertEqual(r.direction.z, -0.66851, accuracy: epsilon)
    }
    
    // Scenario: Construct a ray when the camera is transformed
    // Given c ← camera(201, 101, π/2)
    // When c.transform ← rotation_y(π/4) * translation(0, -2, 5) And r ← ray_for_pixel(c, 100, 50)
    // Then r.origin = point(0, 2, -5) And r.direction = vector(√2/2, 0, -√2/2)
    func testConstructARayWhenTheCameraIsTransformed() {
        let c = Camera(hsize: 201, vsize: 101, field_of_view: .pi/2)
        c.transform = Matrix.rotation_y(r: .pi/4) * Matrix.translation(x: 0, y: -2, z: 5)
        let r = c.ray_for_pixel(px: 100, py: 50)
        XCTAssertEqual(r.origin, Point(x: 0, y: 2, z: -5))
        XCTAssertEqual(r.direction.x, (sqrt(2))/2, accuracy: epsilon)
        XCTAssertEqual(r.direction.y, 0, accuracy: epsilon)
        XCTAssertEqual(r.direction.z, -(sqrt(2))/2, accuracy: epsilon)
    }
    
    // Scenario: Rendering a world with a camera
    // Given w ← default_world() And c ← camera(11, 11, π/2)
    // And from ← point(0, 0, -5) And to ← point(0, 0, 0) And up ← vector(0, 1, 0)
    // And c.transform ← view_transform(from, to, up)
    // When image ← render(c, w)
    // Then pixel_at(image, 5, 5) = color(0.38066, 0.47583, 0.2855)
    func testRenderingAWorldWithACamera() {
        let w = World.defaultWorld()
        let c = Camera(hsize: 11, vsize: 11, field_of_view: .pi/2)
        let from = Point(x: 0, y: 0, z: -5)
        let to = Point(x: 0, y: 0, z: 0)
        let up = Vector(x: 0, y: 1, z: 0)
        c.transform = Matrix.viewTransform(from: from, to: to, up: up)
        let image = c.render(world: w)
        
        XCTAssertEqual(image.pixel_at(x: 5, y: 5).red, 0.38066, accuracy: epsilon)
        XCTAssertEqual(image.pixel_at(x: 5, y: 5).green, 0.47583, accuracy: epsilon)
        XCTAssertEqual(image.pixel_at(x: 5, y: 5).blue, 0.2855, accuracy: epsilon)
    }

}
