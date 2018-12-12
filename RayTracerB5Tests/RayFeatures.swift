//
//  RayFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class RayFeatures: XCTestCase {

    // Scenario: Creating and querying a ray
    // Given origin ← point(1, 2, 3) And direction ← vector(4, 5, 6)
    // When r ← ray(origin, direction)
    // Then r.origin = origin And r.direction = direction
    func testCreatingAndQueryingARay() {
        let origin = Point(x: 1, y: 2, z: 3)
        let direction = Vector(x: 4, y: 5, z: 6)
        let r = Ray(orig: origin, dir: direction)
        XCTAssertEqual(r.origin, origin)
        XCTAssertEqual(r.direction, direction)
    }
    
    // Scenario: Computing a point from a distance
    // Given r ← ray(point(2, 3, 4), vector(1, 0, 0))
    // Then position(r, 0) = point(2, 3, 4) And position(r, 1) = point(3, 3, 4)
    // And position(r, -1) = point(1, 3, 4) And position(r, 2.5) = point(4.5, 3, 4)
    func testComputingAPointFromADistance() {
        let r = Ray(orig: Point(x: 2, y: 3, z: 4), dir: Vector(x: 1, y: 0, z: 0))
        XCTAssertEqual(r.position(time: 0), Point(x: 2, y: 3, z: 4))
        XCTAssertEqual(r.position(time: 1), Point(x: 3, y: 3, z: 4))
        XCTAssertEqual(r.position(time: -1), Point(x: 1, y: 3, z: 4))
        XCTAssertEqual(r.position(time: 2.5), Point(x: 4.5, y: 3, z: 4))
    }

    // Scenario: Translating a ray
    // Given r ← ray(point(1, 2, 3), vector(0, 1, 0)) And m ← translation(3, 4, 5)
    // When r2 ← transform(r, m)
    // Then r2.origin = point(4, 6, 8) And r2.direction = vector(0, 1, 0)
    func testTranslatingARay() {
        let r = Ray(orig: Point(x: 1, y: 2, z: 3), dir: Vector(x: 0, y: 1, z: 0))
        let m = Matrix.translation(x: 3, y: 4, z: 5)
        let r2 = r.transform(m: m)
        XCTAssertEqual(r2.origin, Point(x: 4, y: 6, z: 8))
        XCTAssertEqual(r2.direction, Vector(x: 0, y: 1, z: 0))
    }
    
    // Scenario: Scaling a ray
    // Given r ← ray(point(1, 2, 3), vector(0, 1, 0)) And m ← scaling(2, 3, 4)
    // When r2 ← transform(r, m)
    // Then r2.origin = point(2, 6, 12) And r2.direction = vector(0, 3, 0)
    func testScalingARay() {
        let r = Ray(orig: Point(x: 1, y: 2, z: 3), dir: Vector(x: 0, y: 1, z: 0))
        let m = Matrix.scaling(x: 2, y: 3, z: 4)
        let r2 = r.transform(m: m)
        XCTAssertEqual(r2.origin, Point(x: 2, y: 6, z: 12))
        XCTAssertEqual(r2.direction, Vector(x: 0, y: 3, z: 0))
    }

}
