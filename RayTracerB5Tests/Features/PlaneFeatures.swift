//
//  PlaneFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class PlaneFeatures: XCTestCase {

    // Scenario: The normal of a plane is constant everywhere
    // Given p ← plane() When n1 ← local_normal_at(p, point(0, 0, 0))
    // And n2 ← local_normal_at(p, point(10, 0, -10))
    // And n3 ← local_normal_at(p, point(-5, 0, 150))
    // Then n1 = vector(0, 1, 0) And n2 = vector(0, 1, 0) And n3 = vector(0, 1, 0)
    func testTheNormalOfAPlaneIsConstantEverywhere() {
        let p = Plane()
        let n1 = p.local_normal_at(p: Point(x: 0, y: 0, z: 0))
        let n2 = p.local_normal_at(p: Point(x: 10, y: 0, z: -10))
        let n3 = p.local_normal_at(p: Point(x: -5, y: 0, z: 150))
        XCTAssertEqual(n1, Vector(x: 0, y: 1, z: 0))
        XCTAssertEqual(n2, Vector(x: 0, y: 1, z: 0))
        XCTAssertEqual(n3, Vector(x: 0, y: 1, z: 0))
    }
    
    // Scenario: Intersect with a ray parallel to the plane
    // Given p ← plane() And r ← ray(point(0, 10, 0), vector(0, 0, 1))
    // When xs ← local_intersect(p, r) Then xs is empty
    func testIntersectWithARayParallelToThePlane() {
        let p = Plane()
        let r = Ray(orig: Point(x: 0, y: 10, z: 0), dir: Vector(x: 0, y: 0, z: 1))
        let xs = p.local_intersect(ray: r)
        XCTAssertEqual(xs.count, 0)
    }
    
    // Scenario: Intersect with a coplanar ray
    // Given p ← plane() And r ← ray(point(0, 0, 0), vector(0, 0, 1))
    // When xs ← local_intersect(p, r) Then xs is empty
    func testIntersectWithACoplanarRay() {
        let p = Plane()
        let r = Ray(orig: Point(x: 0, y: 0, z: 0), dir: Vector(x: 0, y: 0, z: 1))
        let xs = p.local_intersect(ray: r)
        XCTAssertEqual(xs.count, 0)
    }
    
    // Scenario: A ray intersecting a plane from above
    // Given p ← plane() And r ← ray(point(0, 1, 0), vector(0, -1, 0))
    // When xs ← local_intersect(p, r) Then xs.count = 1
    // And xs[0].t = 1 And xs[0].object = p
    func testARayIntersectingAPlaneFromAbove() {
        let p = Plane()
        let r = Ray(orig: Point(x: 0, y: 1, z: 0), dir: Vector(x: 0, y: -1, z: 0))
        let xs = p.local_intersect(ray: r)
        XCTAssertEqual(xs.count, 1)
        XCTAssertEqual(xs.list[0].t, 1)
        XCTAssertEqual(xs.list[0].object, p)
    }
    
    // Scenario: A ray intersecting a plane from below
    // Given p ← plane() And r ← ray(point(0, -1, 0), vector(0, 1, 0))
    // When xs ← local_intersect(p, r) Then xs.count = 1
    // And xs[0].t = 1 And xs[0].object = p
    func testARayIntersectingAPlaneFromBelow() {
        let p = Plane()
        let r = Ray(orig: Point(x: 0, y: -1, z: 0), dir: Vector(x: 0, y: 1, z: 0))
        let xs = p.local_intersect(ray: r)
        XCTAssertEqual(xs.count, 1)
        XCTAssertEqual(xs.list[0].t, 1)
        XCTAssertEqual(xs.list[0].object, p)
    }

}
