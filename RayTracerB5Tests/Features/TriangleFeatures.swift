//
//  TriangleFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class TriangleFeatures: XCTestCase {

    // Scenario: Constructing a triangle
    // Given p1 ← point(0, 1, 0) And p2 ← point(-1, 0, 0) And p3 ← point(1, 0, 0)
    // And t ← triangle(p1, p2, p3)
    // Then t.p1 = p1 And t.p2 = p2 And t.p3 = p3
    // And t.e1 = vector(-1, -1, 0) And t.e2 = vector(1, -1, 0)
    // And t.normal = vector(0, 0, -1)
    func testConstructingATriangle() {
        let p1 = Point(x: 0, y: 1, z: 0)
        let p2 = Point(x: -1, y: 0, z: 0)
        let p3 = Point(x: 1, y: 0, z: 0)
        let t = Triangle(p1: p1, p2: p2, p3: p3)
        XCTAssertEqual(t.p1, p1)
        XCTAssertEqual(t.p2, p2)
        XCTAssertEqual(t.p3, p3)
        XCTAssertEqual(t.e1, Vector(x: -1, y: -1, z: 0))
        XCTAssertEqual(t.e2, Vector(x: 1, y: -1, z: 0))
        XCTAssertEqual(t.normal, Vector(x: 0, y: 0, z: -1))
    }
    
    // Scenario: Finding the normal on a triangle
    // Given t ← triangle(point(0, 1, 0), point(-1, 0, 0), point(1, 0, 0))
    // When n1 ← local_normal_at(t, point(0, 0.5, 0))
    // And n2 ← local_normal_at(t, point(-0.5, 0.75, 0))
    // And n3 ← local_normal_at(t, point(0.5, 0.25, 0))
    // Then n1 = t.normal And n2 = t.normal And n3 = t.normal
    func testFindingTheNormalOnATriangle() {
        let t = Triangle(p1: Point(x: 0, y: 1, z: 0),
                         p2: Point(x: -1, y: 0, z: 0),
                         p3: Point(x: 1, y: 0, z: 0))
        let i = Intersection(t: 0, object: t)
        let n1 = t.local_normal_at(p: Point(x: 0, y: 0.5, z: 0), hit: i)
        let n2 = t.local_normal_at(p: Point(x: -0.5, y: 0.75, z: 0), hit: i)
        let n3 = t.local_normal_at(p: Point(x: 0.5, y: 0.25, z: 0), hit: i)
        XCTAssertEqual(n1, t.normal)
        XCTAssertEqual(n2, t.normal)
        XCTAssertEqual(n3, t.normal)
    }
    
    // Scenario: Intersecting a ray parallel to the triangle
    // Given t ← triangle(point(0, 1, 0), point(-1, 0, 0), point(1, 0, 0))
    // And r ← ray(point(0, -1, -2), vector(0, 1, 0))
    // When xs ← local_intersect(t, r) Then xs is empty
    func testIntersectingARayParallelToTheTriangle() {
        let t = Triangle(p1: Point(x: 0, y: 1, z: 0),
                         p2: Point(x: -1, y: 0, z: 0),
                         p3: Point(x: 1, y: 0, z: 0))
        let r = Ray(orig: Point(x: 0, y: -1, z: -2),
                    dir: Vector(x: 0, y: 1, z: 0))
        let xs = t.local_intersect(ray: r)
        XCTAssertEqual(xs.count, 0)
    }
    
    // Scenario: A ray misses the p1-p3 edge
    // Given t ← triangle(point(0, 1, 0), point(-1, 0, 0), point(1, 0, 0))
    // And r ← ray(point(1, 1, -2), vector(0, 0, 1))
    // When xs ← local_intersect(t, r) Then xs is empty
    func testARayMissesTheP1P3Edge() {
        let t = Triangle(p1: Point(x: 0, y: 1, z: 0),
                         p2: Point(x: -1, y: 0, z: 0),
                         p3: Point(x: 1, y: 0, z: 0))
        let r = Ray(orig: Point(x: 1, y: 1, z: -2),
                    dir: Vector(x: 0, y: 0, z: 1))
        let xs = t.local_intersect(ray: r)
        XCTAssertEqual(xs.count, 0)
    }
    
    // Scenario: A ray misses the p1-p2 edge
    // Given t ← triangle(point(0, 1, 0), point(-1, 0, 0), point(1, 0, 0))
    // And r ← ray(point(-1, 1, -2), vector(0, 0, 1))
    // When xs ← local_intersect(t, r) Then xs is empty
    func testARayMissesTheP1P2Edge() {
        let t = Triangle(p1: Point(x: 0, y: 1, z: 0),
                         p2: Point(x: -1, y: 0, z: 0),
                         p3: Point(x: 1, y: 0, z: 0))
        let r = Ray(orig: Point(x: -1, y: 1, z: -2),
                    dir: Vector(x: 0, y: 0, z: 1))
        let xs = t.local_intersect(ray: r)
        XCTAssertEqual(xs.count, 0)
    }
    
    // Scenario: A ray misses the p2-p3 edge
    // Given t ← triangle(point(0, 1, 0), point(-1, 0, 0), point(1, 0, 0))
    // And r ← ray(point(0, -1, -2), vector(0, 0, 1))
    // When xs ← local_intersect(t, r) Then xs is empty
    func testARayMissesTheP2P3Edge() {
        let t = Triangle(p1: Point(x: 0, y: 1, z: 0),
                         p2: Point(x: -1, y: 0, z: 0),
                         p3: Point(x: 1, y: 0, z: 0))
        let r = Ray(orig: Point(x: 0, y: -1, z: -2),
                    dir: Vector(x: 0, y: 0, z: 1))
        let xs = t.local_intersect(ray: r)
        XCTAssertEqual(xs.count, 0)
    }
    
    // Scenario: A ray strikes a triangle
    // Given t ← triangle(point(0, 1, 0), point(-1, 0, 0), point(1, 0, 0))
    // And r ← ray(point(0, 0.5, -2), vector(0, 0, 1))
    // When xs ← local_intersect(t, r) Then xs.count = 1 And xs[0].t = 2
    func testARayStrikesATriangle() {
        let t = Triangle(p1: Point(x: 0, y: 1, z: 0),
                         p2: Point(x: -1, y: 0, z: 0),
                         p3: Point(x: 1, y: 0, z: 0))
        let r = Ray(orig: Point(x: 0, y: 0.5, z: -2),
                    dir: Vector(x: 0, y: 0, z: 1))
        let xs = t.local_intersect(ray: r)
        XCTAssertEqual(xs.count, 1)
        XCTAssertEqual(xs.list[0].t, 2)
    }
}
