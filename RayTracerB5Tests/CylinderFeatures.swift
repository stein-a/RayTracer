//
//  CylinderFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class CylinderFeatures: XCTestCase {

    // Scenario Outline: A ray misses a cylinder
    // Given cyl ← cylinder() And direction ← normalize(<direction>)
    // And r ← ray(<origin>, direction)
    // When xs ← local_intersect(cyl, r) Then xs.count = 0
    // Examples:
    // | origin          | direction       |
    // | point(1, 0, 0)  | vector(0, 1, 0) |
    // | point(0, 0, 0)  | vector(0, 1, 0) |
    // | point(0, 0, -5) | vector(1, 1, 1) |
    func testARayMissesACylinder() {
        let cyl = Cylinder()
        let orig1 = Point(x: 1, y: 0, z: 0)
        let dir1 = Vector(x: 0, y: 1, z: 0).normalize()
        let r1 = Ray(orig: orig1, dir: dir1)
        let xs1 = cyl.local_intersect(ray: r1)
        XCTAssertEqual(xs1.count, 0)
        let orig2 = Point(x: 0, y: 0, z: 0)
        let dir2 = Vector(x: 0, y: 1, z: 0).normalize()
        let r2 = Ray(orig: orig2, dir: dir2)
        let xs2 = cyl.local_intersect(ray: r2)
        XCTAssertEqual(xs2.count, 0)
        let orig3 = Point(x: 0, y: 0, z: -5)
        let dir3 = Vector(x: 1, y: 1, z: 1).normalize()
        let r3 = Ray(orig: orig3, dir: dir3)
        let xs3 = cyl.local_intersect(ray: r3)
        XCTAssertEqual(xs3.count, 0)
    }
    
    // Scenario Outline: A ray strikes a cylinder
    // Given cyl ← cylinder() And direction ← normalize(<direction>)
    // And r ← ray(<origin>, direction)
    // When xs ← local_intersect(cyl, r) Then xs.count = 2
    // And xs[0].t = <t0> And xs[1].t = <t1>
    // Examples:
    // | origin            | direction         | t0      | t1      |
    // | point(1, 0, -5)   | vector(0, 0, 1)   | 5       | 5       |
    // | point(0, 0, -5)   | vector(0, 0, 1)   | 4       | 6       |
    // | point(0.5, 0, -5) | vector(0.1, 1, 1) | 6.80798 | 7.08872 |
    func testARayStrikesACylinder() {
        let cyl = Cylinder()
        let orig1 = Point(x: 1, y: 0, z: -5)
        let dir1 = Vector(x: 0, y: 0, z: 1).normalize()
        let r1 = Ray(orig: orig1, dir: dir1)
        let xs1 = cyl.local_intersect(ray: r1)
        XCTAssertEqual(xs1.count, 2)
        XCTAssertEqual(xs1.list[0].t, 5)
        XCTAssertEqual(xs1.list[1].t, 5)
        let orig2 = Point(x: 0, y: 0, z: -5)
        let dir2 = Vector(x: 0, y: 0, z: 1).normalize()
        let r2 = Ray(orig: orig2, dir: dir2)
        let xs2 = cyl.local_intersect(ray: r2)
        XCTAssertEqual(xs2.count, 2)
        XCTAssertEqual(xs2.list[0].t, 4)
        XCTAssertEqual(xs2.list[1].t, 6)
        let orig3 = Point(x: 0.5, y: 0, z: -5)
        let dir3 = Vector(x: 0.1, y: 1, z: 1).normalize()
        let r3 = Ray(orig: orig3, dir: dir3)
        let xs3 = cyl.local_intersect(ray: r3)
        XCTAssertEqual(xs3.count, 2)
        XCTAssertEqual(xs3.list[0].t, 6.80798, accuracy: 0.0001)
        XCTAssertEqual(xs3.list[1].t, 7.08872, accuracy: 0.0001)
    }
    
    // Scenario Outline: Normal vector on a cylinder
    // Given cyl ← cylinder()
    // When n ← local_normal_at(cyl, <point>) Then n = <normal>
    // Examples:
    // | point           | normal           |
    // | point(1, 0, 0)  | vector(1, 0, 0)  |
    // | point(0, 5, -1) | vector(0, 0, -1) |
    // | point(0, -2, 1) | vector(0, 0, 1)  |
    // | point(-1, 1, 0) | vector(-1, 0, 0) |
    func testNormalVectorOnACylinder() {
        let cyl = Cylinder()
        let p1 = Point(x: 1, y: 0, z: 0)
        let n1 = Vector(x: 1, y: 0, z: 0)
        XCTAssertEqual(cyl.local_normal_at(p: p1), n1)
        let p2 = Point(x: 0, y: 5, z: -1)
        let n2 = Vector(x: 0, y: 0, z: -1)
        XCTAssertEqual(cyl.local_normal_at(p: p2), n2)
        let p3 = Point(x: 0, y: -2, z: 1)
        let n3 = Vector(x: 0, y: 0, z: 1)
        XCTAssertEqual(cyl.local_normal_at(p: p3), n3)
        let p4 = Point(x: -1, y: 1, z: 0)
        let n4 = Vector(x: -1, y: 0, z: 0)
        XCTAssertEqual(cyl.local_normal_at(p: p4), n4)
    }

    // Scenario: The default minimum and maximum for a cylinder
    // Given cyl ← cylinder()
    // Then cyl.minimum = -infinity And cyl.maximum = infinity
    
    // Scenario Outline: Intersecting a constrained cylinder
    // Given cyl ← cylinder() And cyl.minimum ← 1 And cyl.maximum ← 2
    // And direction ← normalize(<direction>)
    // And r ← ray(<point>, direction)
    // When xs ← local_intersect(cyl, r) Then xs.count = <count>
    // Examples:
    // |   | point             | direction         | count |
    // | 1 | point(0, 1.5, 0)  | vector(0.1, 1, 0) | 0     |
    // | 2 | point(0, 3, -5)   | vector(0, 0, 1)   | 0     |
    // | 3 | point(0, 0, -5)   | vector(0, 0, 1)   | 0     |
    // | 4 | point(0, 2, -5)   | vector(0, 0, 1)   | 0     |
    // | 5 | point(0, 1, -5)   | vector(0, 0, 1)   | 0     |
    // | 6 | point(0, 1.5, -2) | vector(0, 0, 1)   | 2     |
    
    // Scenario: The default closed value for a cylinder
    // Given cyl ← cylinder() Then cyl.closed = false
    
    // Scenario Outline: Intersecting the caps of a closed cylinder
    // Given cyl ← cylinder() And cyl.minimum ← 1 And cyl.maximum ← 2
    // And cyl.closed ← true
    // And direction ← normalize(<direction>)
    // And r ← ray(<point>, direction)
    // When xs ← local_intersect(cyl, r) Then xs.count = <count>
    // Examples:
    // |   | point            | direction        | count |
    // | 1 | point(0, 3, 0)   | vector(0, -1, 0) | 2     |
    // | 2 | point(0, 3, -2)  | vector(0, -1, 2) | 2     |
    // | 3 | point(0, 4, -2)  | vector(0, -1, 1) | 2     | # corner case
    // | 4 | point(0, 0, -2)  | vector(0, 1, 2)  | 2     |
    // | 5 | point(0, -1, -2) | vector(0, 1, 1)  | 2     | # corner case
    
    // Scenario Outline: The normal vector on a cylinder's end caps
    // Given cyl ← cylinder() And cyl.minimum ← 1 And cyl.maximum ← 2
    // And cyl.closed ← true
    // When n ← local_normal_at(cyl, <point>) Then n = <normal>
    // Examples:
    // | point            | normal           |
    // | point(0, 1, 0)   | vector(0, -1, 0) |
    // | point(0.5, 1, 0) | vector(0, -1, 0) |
    // | point(0, 1, 0.5) | vector(0, -1, 0) |
    // | point(0, 2, 0)   | vector(0, 1, 0)  |
    // | point(0.5, 2, 0) | vector(0, 1, 0)  |
    // | point(0, 2, 0.5) | vector(0, 1, 0)  |
}
