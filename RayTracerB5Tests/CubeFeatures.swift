//
//  CubeFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class CubeFeatures: XCTestCase {

    // Scenario Outline: A ray intersects a cube
    // Given c ← cube() And r ← ray(<origin>, <direction>)
    // When xs ← local_intersect(c, r) Then xs.count = 2
    // And xs[0].t = <t1> And xs[1].t = <t2>
    // Examples:
    // |        | origin            | direction        | t1 | t2 |
    // | +x     | point(5, 0.5, 0)  | vector(-1, 0, 0) | 4  | 6 |
    // | -x     | point(-5, 0.5, 0) | vector(1, 0, 0)  | 4  | 6 |
    // | +y     | point(0.5, 5, 0)  | vector(0, -1, 0) | 4  | 6 |
    // | -y     | point(0.5, -5, 0) | vector(0, 1, 0)  | 4  | 6 |
    // | +z     | point(0.5, 0, 5)  | vector(0, 0, -1) | 4  | 6 |
    // | -z     | point(0.5, 0, -5) | vector(0, 0, 1)  | 4  | 6 |
    // | inside | point(0, 0.5, 0)  | vector(0, 0, 1)  | -1 | 1 |
    func testARayIntersectsACube() {
        let c = Cube()
        let r1 = Ray(orig: Point(x: 5, y: 0.5, z: 0),
                     dir: Vector(x: -1, y: 0, z: 0))
        let xs1 = c.local_intersect(ray: r1)
        XCTAssertEqual(xs1.count, 2)
        XCTAssertEqual(xs1.list[0].t, 4)
        XCTAssertEqual(xs1.list[1].t, 6)
        let r2 = Ray(orig: Point(x: -5, y: 0.5, z: 0),
                     dir: Vector(x: 1, y: 0, z: 0))
        let xs2 = c.local_intersect(ray: r2)
        XCTAssertEqual(xs2.count, 2)
        XCTAssertEqual(xs2.list[0].t, 4)
        XCTAssertEqual(xs2.list[1].t, 6)
        let r3 = Ray(orig: Point(x: 0.5, y: 5, z: 0),
                     dir: Vector(x: 0, y: -1, z: 0))
        let xs3 = c.local_intersect(ray: r3)
        XCTAssertEqual(xs3.count, 2)
        XCTAssertEqual(xs3.list[0].t, 4)
        XCTAssertEqual(xs3.list[1].t, 6)
        let r4 = Ray(orig: Point(x: 0.5, y: -5, z: 0),
                     dir: Vector(x: 0, y: 1, z: 0))
        let xs4 = c.local_intersect(ray: r4)
        XCTAssertEqual(xs4.count, 2)
        XCTAssertEqual(xs4.list[0].t, 4)
        XCTAssertEqual(xs4.list[1].t, 6)
        let r5 = Ray(orig: Point(x: 0.5, y: 0, z: 5),
                     dir: Vector(x: 0, y: 0, z: -1))
        let xs5 = c.local_intersect(ray: r5)
        XCTAssertEqual(xs5.count, 2)
        XCTAssertEqual(xs5.list[0].t, 4)
        XCTAssertEqual(xs5.list[1].t, 6)
        let r6 = Ray(orig: Point(x: 0.5, y: 0, z: -5),
                     dir: Vector(x: 0, y: 0, z: 1))
        let xs6 = c.local_intersect(ray: r6)
        XCTAssertEqual(xs6.count, 2)
        XCTAssertEqual(xs6.list[0].t, 4)
        XCTAssertEqual(xs6.list[1].t, 6)
        let r7 = Ray(orig: Point(x: 0, y: 0.5, z: 0),
                     dir: Vector(x: 0, y: 0, z: 1))
        let xs7 = c.local_intersect(ray: r7)
        XCTAssertEqual(xs7.count, 2)
        XCTAssertEqual(xs7.list[0].t, -1)
        XCTAssertEqual(xs7.list[1].t, 1)
    }

    // Scenario Outline: A ray misses a cube
    // Given c ← cube() And r ← ray(<origin>, <direction>)
    // When xs ← local_intersect(c, r) Then xs.count = 0
    // Examples:
    // | origin          | direction                      |
    // | point(-2, 0, 0) | vector(0.2673, 0.5345, 0.8018) |
    // | point(0, -2, 0) | vector(0.8018, 0.2673, 0.5345) |
    // | point(0, 0, -2) | vector(0.5345, 0.8018, 0.2673) |
    // | point(2, 0, 2)  | vector(0, 0, -1)               |
    // | point(0, 2, 2)  | vector(0, -1, 0)               |
    // | point(2, 2, 0)  | vector(-1, 0, 0)               |
    func testARayMissesACube() {
        let c = Cube()
        let r1 = Ray(orig: Point(x: -2, y: 0, z: 0),
                     dir: Vector(x: 0.2673, y: 0.5345, z: 0.8018))
        let xs1 = c.local_intersect(ray: r1)
        XCTAssertEqual(xs1.count, 0)
        let r2 = Ray(orig: Point(x: 0, y: -2, z: 0),
                     dir: Vector(x: 0.8018, y: 0.2673, z: 0.5345))
        let xs2 = c.local_intersect(ray: r2)
        XCTAssertEqual(xs2.count, 0)
        let r3 = Ray(orig: Point(x: 0, y: 0, z: -2),
                     dir: Vector(x: 0.5345, y: 0.8018, z: 0.2673))
        let xs3 = c.local_intersect(ray: r3)
        XCTAssertEqual(xs3.count, 0)
        let r4 = Ray(orig: Point(x: 2, y: 0, z: 2), dir: Vector(x: 0, y: 0, z: -1))
        let xs4 = c.local_intersect(ray: r4)
        XCTAssertEqual(xs4.count, 0)
        let r5 = Ray(orig: Point(x: 0, y: 2, z: 2), dir: Vector(x: 0, y: -1, z: 0))
        let xs5 = c.local_intersect(ray: r5)
        XCTAssertEqual(xs5.count, 0)
        let r6 = Ray(orig: Point(x: 2, y: 2, z: 0), dir: Vector(x: -1, y: 0, z: 0))
        let xs6 = c.local_intersect(ray: r6)
        XCTAssertEqual(xs6.count, 0)
    }

    // Scenario Outline: The normal on the surface of a cube
    // Given c ← cube() And p ← <point>
    // When normal ← local_normal_at(c, p) Then normal = <normal>
    // Examples:
    // | point                | normal           |
    // | point(1, 0.5, -0.8)  | vector(1, 0, 0)  |
    // | point(-1, -0.2, 0.9) | vector(-1, 0, 0) |
    // | point(-0.4, 1, -0.1) | vector(0, 1, 0)  |
    // | point(0.3, -1, -0.7) | vector(0, -1, 0) |
    // | point(-0.6, 0.3, 1)  | vector(0, 0, 1)  |
    // | point(0.4, 0.4, -1)  | vector(0, 0, -1) |
    // | point(1, 1, 1)       | vector(1, 0, 0)  |
    // | point(-1, -1, -1)    | vector(-1, 0, 0) |
    func testTheNormalOnTheSurfaceOfACube() {
        let c = Cube()
        let p1 = Point(x: 1, y: 0.5, z: -0.8)
        let p2 = Point(x: -1, y: -0.2, z: 0.9)
        let p3 = Point(x: -0.4, y: 1, z: -0.1)
        let p4 = Point(x: 0.3, y: -1, z: -0.7)
        let p5 = Point(x: -0.6, y: 0.3, z: 1)
        let p6 = Point(x: 0.4, y: 0.4, z: -1)
        let p7 = Point(x: 1, y: 1, z: 1)
        let p8 = Point(x: -1, y: -1, z: -1)
        let n1 = Vector(x: 1, y: 0, z: 0)
        let n2 = Vector(x: -1, y: 0, z: 0)
        let n3 = Vector(x: 0, y: 1, z: 0)
        let n4 = Vector(x: 0, y: -1, z: 0)
        let n5 = Vector(x: 0, y: 0, z: 1)
        let n6 = Vector(x: 0, y: 0, z: -1)
        let n7 = Vector(x: 1, y: 0, z: 0)
        let n8 = Vector(x: -1, y: 0, z: 0)
        XCTAssertEqual(c.local_normal_at(p: p1), n1)
        XCTAssertEqual(c.local_normal_at(p: p2), n2)
        XCTAssertEqual(c.local_normal_at(p: p3), n3)
        XCTAssertEqual(c.local_normal_at(p: p4), n4)
        XCTAssertEqual(c.local_normal_at(p: p5), n5)
        XCTAssertEqual(c.local_normal_at(p: p6), n6)
        XCTAssertEqual(c.local_normal_at(p: p7), n7)
        XCTAssertEqual(c.local_normal_at(p: p8), n8)
    }

}
