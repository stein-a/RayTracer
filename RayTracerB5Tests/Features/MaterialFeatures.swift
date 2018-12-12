//
//  MaterialFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class MaterialFeatures: XCTestCase {

    // Scenario: The default material
    // Given m ← material() Then m.color = color(1, 1, 1) And m.ambient = 0.1
    // And m.diffuse = 0.9 And m.specular = 0.9 And m.shininess = 200.0
    func testTheDefaultMaterial() {
        let m = Material()
        XCTAssertEqual(m.color, Color(r: 1, g: 1, b: 1))
        XCTAssertEqual(m.ambient, 0.1)
        XCTAssertEqual(m.diffuse, 0.9)
        XCTAssertEqual(m.specular, 0.9)
        XCTAssertEqual(m.shininess, 200.0)
    }
    
    // Background:
    // Given m ← material() And position ← point(0, 0, 0)
    
    // Scenario: Lighting with the eye between the light and the surface
    // Given eyev ← vector(0, 0, -1) And normalv ← vector(0, 0, -1)
    // And light ← point_light(point(0, 0, -10), color(1, 1, 1))
    // When result ← lighting(m, light, position, eyev, normalv)
    // Then result = color(1.9, 1.9, 1.9)
    func testLightingWithTheEyeBetweenTheLightAndTheSurface() {
        let s = Sphere()
        let m = Material()
        let position = Point(x: 0, y: 0, z: 0)
        let eyev = Vector(x: 0, y: 0, z: -1)
        let normalv = Vector(x: 0, y: 0, z: -1)
        let light = PointLight(pos: Point(x: 0, y: 0, z: -10), int: Color(r: 1, g: 1, b: 1))
        let result = m.lighting(light: light, object: s, point: position, eyev: eyev, normalv: normalv, in_shadow: false)
        XCTAssertEqual(result, Color(r: 1.9, g: 1.9, b: 1.9))
    }
    
    // Scenario: Lighting with the eye between light and surface (45 degrees)
    // Given eyev ← vector(0, √2/2, -√2/2) And normalv ← vector(0, 0, -1)
    // And light ← point_light(point(0, 0, -10), color(1, 1, 1))
    // When result ← lighting(m, light, position, eyev, normalv)
    // Then result = color(1.0, 1.0, 1.0)
    func testLightingWithTheEyeBetweenTheLightAndTheSurface45degrees() {
        let s = Sphere()
        let m = Material()
        let position = Point(x: 0, y: 0, z: 0)
        let eyev = Vector(x: 0, y: sqrtf(2)/2, z: -sqrtf(2)/2)
        let normalv = Vector(x: 0, y: 0, z: -1)
        let light = PointLight(pos: Point(x: 0, y: 0, z: -10), int: Color(r: 1, g: 1, b: 1))
        let result = m.lighting(light: light, object: s, point: position, eyev: eyev, normalv: normalv, in_shadow: false)
        XCTAssertEqual(result, Color(r: 1.0, g: 1.0, b: 1.0))
    }
    
    // Scenario: Lighting with eye opposite surface, light offset 45 degrees
    // Given eyev ← vector(0, 0, -1) And normalv ← vector(0, 0, -1)
    // And light ← point_light(point(0, 10, -10), color(1, 1, 1))
    // When result ← lighting(m, light, position, eyev, normalv)
    // Then result = color(0.7364, 0.7364, 0.7364)
    func testLightingWithTheEyeOppositeTheSurfaceLightOffset45degrees() {
        let s = Sphere()
        let m = Material()
        let position = Point(x: 0, y: 0, z: 0)
        let eyev = Vector(x: 0, y: 0, z: -1)
        let normalv = Vector(x: 0, y: 0, z: -1)
        let light = PointLight(pos: Point(x: 0, y: 10, z: -10), int: Color(r: 1, g: 1, b: 1))
        let result = m.lighting(light: light, object: s, point: position, eyev: eyev, normalv: normalv, in_shadow: false)
        XCTAssertEqual(result.red, 0.7364, accuracy: 0.00001)
        XCTAssertEqual(result.green, 0.7364, accuracy: 0.00001)
        XCTAssertEqual(result.blue, 0.7364, accuracy: 0.00001)
    }
    
    // Scenario: Lighting with eye in the path of the reflection vector
    // Given eyev ← vector(0, -√2/2, -√2/2) And normalv ← vector(0, 0, -1)
    // And light ← point_light(point(0, 10, -10), color(1, 1, 1))
    // When result ← lighting(m, light, position, eyev, normalv)
    // Then result = color(1.6364, 1.6364, 1.6364)
    func testLightingWithEyeInThePathOfTheReflectionVector() {
        let s = Sphere()
        let m = Material()
        let position = Point(x: 0, y: 0, z: 0)
        let eyev = Vector(x: 0, y: -sqrtf(2)/2, z: -sqrtf(2)/2)
        let normalv = Vector(x: 0, y: 0, z: -1)
        let light = PointLight(pos: Point(x: 0, y: 10, z: -10), int: Color(r: 1, g: 1, b: 1))
        let result = m.lighting(light: light, object: s, point: position, eyev: eyev, normalv: normalv, in_shadow: false)
        XCTAssertEqual(result.red, 1.6364, accuracy: 0.0001)
        XCTAssertEqual(result.green, 1.6364, accuracy: 0.0001)
        XCTAssertEqual(result.blue, 1.6364, accuracy: 0.0001)
    }
    
    // Scenario: Lighting with the light behind the surface
    // Given eyev ← vector(0, 0, -1) And normalv ← vector(0, 0, -1)
    // And light ← point_light(point(0, 0, 10), color(1, 1, 1))
    // When result ← lighting(m, light, position, eyev, normalv)
    // Then result = color(0.1, 0.1, 0.1)
    func testLightingWithTheLightBehindTheSurface() {
        let s = Sphere()
        let m = Material()
        let position = Point(x: 0, y: 0, z: 0)
        let eyev = Vector(x: 0, y: 0, z: -1)
        let normalv = Vector(x: 0, y: 0, z: -1)
        let light = PointLight(pos: Point(x: 0, y: 0, z: 10), int: Color(r: 1, g: 1, b: 1))
        let result = m.lighting(light: light, object: s, point: position, eyev: eyev, normalv: normalv, in_shadow: false)
        XCTAssertEqual(result.red, 0.1)
        XCTAssertEqual(result.green, 0.1)
        XCTAssertEqual(result.blue, 0.1)
    }

    // Scenario: Lighting with the surface in shadow
    // Given eyev ← vector(0, 0, -1) And normalv ← vector(0, 0, -1)
    // And light ← point_light(point(0, 0, -10), color(1, 1, 1)) And in_shadow ← true
    // When result ← lighting(m, light, position, eyev, normalv, in_shadow)
    // Then result = color(0.1, 0.1, 0.1)
    func testLightingWithTheSurfaceInShadow() {
        let s = Sphere()
        let m = Material()
        let position = Point(x: 0, y: 0, z: 0)
        let eyev = Vector(x: 0, y: 0, z: -1)
        let normalv = Vector(x: 0, y: 0, z: -1)
        let light = PointLight(pos: Point(x: 0, y: 0, z: -10), int: Color(r: 1, g: 1, b: 1))
        let in_shadow = true
        let result = m.lighting(light: light, object: s, point: position, eyev: eyev, normalv: normalv, in_shadow: in_shadow)
        XCTAssertEqual(result, Color(r: 0.1, g: 0.1, b: 0.1))
    }

    // Scenario: Lighting with a pattern applied
    // Given m.pattern ← stripe_pattern(color(1, 1, 1), color(0, 0, 0))
    // And m.ambient ← 1 And m.diffuse ← 0 And m.specular ← 0
    // And eyev ← vector(0, 0, -1) And normalv ← vector(0, 0, -1)
    // And light ← point_light(point(0, 0, -10), color(1, 1, 1))
    // When c1 ← lighting(m, light, point(0.9, 0, 0), eyev, normalv, false)
    // And c2 ← lighting(m, light, point(1.1, 0, 0), eyev, normalv, false)
    // Then c1 = color(1, 1, 1) And c2 = color(0, 0, 0)
    func testLightingWithAPatternApplied() {
        let s = Sphere()
        let m = Material()
        s.material = m
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        m.pattern = StripePattern(a: white, b: black)
        m.ambient = 1
        m.diffuse = 0
        m.specular = 0
        let eyev = Vector(x: 0, y: 0, z: -1)
        let normalv = Vector(x: 0, y: 0, z: -1)
        let light = PointLight(pos: Point(x: 0, y: 0, z: -10), int: white)
        let c1 = m.lighting(light: light, object: s, point: Point(x: 0.9, y: 0, z: 0), eyev: eyev, normalv: normalv, in_shadow: false)
        let c2 = m.lighting(light: light, object: s, point: Point(x: 1.1, y: 0, z: 0), eyev: eyev, normalv: normalv, in_shadow: false)
        XCTAssertEqual(c1, white)
        XCTAssertEqual(c2, black)
    }

    // Scenario: Reflectivity for the default material
    // Given m ← material() Then m.reflective = 0.0
    func testReflectivityForTheDefaultMaterial() {
        let m = Material()
        XCTAssertEqual(m.reflectivity, 0.0)
    }

    // Scenario: Transparency and Refractive Index for the default material
    // Given m ← material() Then m.transparency = 0.0 And m.refractive_index = 1.0
    func testTransparencyAndRefractiveIndexForTheDefaultMaterial() {
        let m = Material()
        XCTAssertEqual(m.transparency, 0.0)
        XCTAssertEqual(m.refractiveIndex, 1.0)
    }
}
