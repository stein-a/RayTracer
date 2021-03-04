//
//  ConeFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class ConeFeatures: XCTestCase {

    // Scenario Outline: Intersecting a cone with a ray
    // Given shape ← cone() And direction ← normalize(<direction>)
    // And r ← ray(<origin>, direction)
    // When xs ← local_intersect(shape, r) Then xs.count = 2
    // And xs[0].t = <t0> And xs[1].t = <t1>
    // Examples:
    // | origin          | direction           | t0      | t1       |
    // | point(0, 0, -5) | vector(0, 0, 1)     | 5       | 5        |
    // | point(0, 0, -5) | vector(1, 1, 1)     | 8.66025 | 8.66025  |
    // | point(1, 1, -5) | vector(-0.5, -1, 1) | 4.55006 | 49.44994 |
    func testIntersectingAConeWithARay() {
        let shape = Cone()
        let dir1 = Vector(x: 0, y: 0, z: 1).normalize()
        let r1 = Ray(orig: Point(x: 0, y: 0, z: -5), dir: dir1)
        let xs1 = shape.local_intersect(ray: r1)
        XCTAssertEqual(xs1.count, 2)
        XCTAssertEqual(xs1.list[0].t, 5)
        XCTAssertEqual(xs1.list[1].t, 5)
        let dir2 = Vector(x: 1, y: 1, z: 1).normalize()
        let r2 = Ray(orig: Point(x: 0, y: 0, z: -5), dir: dir2)
        let xs2 = shape.local_intersect(ray: r2)
        XCTAssertEqual(xs2.count, 2)
//        XCTAssertEqual(xs2.list[0].t, 8.66025)
//        XCTAssertEqual(xs2.list[1].t, 8.66025)
        let dir3 = Vector(x: -0.5, y: -1, z: 1).normalize()
        let r3 = Ray(orig: Point(x: 1, y: 1, z: -5), dir: dir3)
        let xs3 = shape.local_intersect(ray: r3)
        XCTAssertEqual(xs3.count, 2)
        XCTAssertEqual(xs3.list[0].t, 4.55006, accuracy: 0.0001)
        XCTAssertEqual(xs3.list[1].t, 49.44994, accuracy: 0.0001)
    }

    // Scenario: Intersecting a cone with a ray parallel to one of its halves
    // Given shape ← cone() And direction ← normalize(vector(0, 1, 1))
    // And r ← ray(point(0, 0, -1), direction)
    // When xs ← local_intersect(shape, r) Then xs.count = 1
    // And xs[0].t = 0.35355
    func testIntersectingAConeWithARayParallel() {
        let shape = Cone()
        let direction = Vector(x: 0, y: 1, z: 1).normalize()
        let r = Ray(orig: Point(x: 0, y: 0, z: -1), dir: direction)
        let xs = shape.local_intersect(ray: r)
        XCTAssertEqual(xs.count, 1)
        XCTAssertEqual(xs.list[0].t, 0.35355, accuracy: 0.0001)
    }
    
    // Scenario Outline: Intersecting a cone's end caps
    // Given shape ← cone() And shape.minimum ← -0.5 And shape.maximum ← 0.5
    // And shape.closed ← true And direction ← normalize(<direction>)
    // And r ← ray(<origin>, direction) When xs ← local_intersect(shape, r)
    // Then xs.count = <count>
    // Examples:
    // | origin             | direction       | count |
    // | point(0, 0, -5)    | vector(0, 1, 0) | 0     |
    // | point(0, 0, -0.25) | vector(0, 1, 1) | 2     |
    // | point(0, 0, -0.25) | vector(0, 1, 0) | 4     |
    func testIntersectingAConesEndCaps() {
        let shape = Cone()
        shape.minimum = -0.5
        shape.maximum = 0.5
        shape.closed = true
        let dir1 = Vector(x: 0, y: 1, z: 0).normalize()
        let r1 = Ray(orig: Point(x: 0, y: 0, z: -5), dir: dir1)
        let xs1 = shape.local_intersect(ray: r1)
        XCTAssertEqual(xs1.count, 0)
        let dir2 = Vector(x: 0, y: 1, z: 1).normalize()
        let r2 = Ray(orig: Point(x: 0, y: 0, z: -0.25), dir: dir2)
        let xs2 = shape.local_intersect(ray: r2)
        XCTAssertEqual(xs2.count, 2)
        let dir3 = Vector(x: 0, y: 1, z: 0).normalize()
        let r3 = Ray(orig: Point(x: 0, y: 0, z: -0.25), dir: dir3)
        let xs3 = shape.local_intersect(ray: r3)
        XCTAssertEqual(xs3.count, 4)
    }
    
    // Scenario Outline: Computing the normal vector on a cone
    // Given shape ← cone() When n ← local_normal_at(shape, <point>)
    // Then n = <normal>
    // Examples:
    // | point            | normal
    // | point(0, 0, 0)   | vector(0, 0, 0)
    // | point(1, 1, 1)   | vector(1, -√2, 1)
    // | point(-1, -1, 0) | vector(-1, 1, 0)
    func testComputingTheNormalVectorOnACone() {
        let shape = Cone()
        let i = Intersection(t: 0, object: shape)
        XCTAssertEqual(shape.local_normal_at(p: Point(x: 0, y: 0, z: 0), hit: i),
                       Vector(x: 0, y: 0, z: 0))
        XCTAssertEqual(shape.local_normal_at(p: Point(x: 1, y: 1, z: 1), hit: i),
                       Vector(x: 1, y: -sqrt(2), z: 1))
        XCTAssertEqual(shape.local_normal_at(p: Point(x: -1, y: -1, z: 0), hit: i),
                       Vector(x: -1, y: 1, z: 0))
    }
}
