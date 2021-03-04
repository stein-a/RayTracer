//
//  SmoothTriangleFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 16/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class SmoothTriangleFeatures: XCTestCase {

    // Background:
    // Given p1=point(0, 1, 0) And p2=point(-1, 0, 0) And p3=point(1, 0, 0)
    // And n1=vector(0, 1, 0) And n2=vector(-1, 0, 0) And n3=vector(1, 0, 0)
    // When tri ← smooth_triangle(p1, p2, p3, n1, n2, n3)
    
    // Scenario: Constructing a smooth triangle
    // Then tri.p1 = p1 And tri.p2 = p2 And tri.p3 = p3
    // And tri.n1 = n1 And tri.n2 = n2 And tri.n3 = n3
    func testConstructingASmoothTriangle() {
        let p1 = Point(x: 0, y: 1, z: 0)
        let p2 = Point(x: -1, y: 0, z: 0)
        let p3 = Point(x: 1, y: 0, z: 0)
        let n1 = Vector(x: 0, y: 1, z: 0)
        let n2 = Vector(x: -1, y: 0, z: 0)
        let n3 = Vector(x: 1, y: 0, z: 0)
        let tri = SmoothTriangle(p1: p1, p2: p2, p3: p3, n1: n1, n2: n2, n3: n3)
        XCTAssertEqual(tri.p1, p1)
        XCTAssertEqual(tri.p2, p2)
        XCTAssertEqual(tri.p3, p3)
        XCTAssertEqual(tri.n1, n1)
        XCTAssertEqual(tri.n2, n2)
        XCTAssertEqual(tri.n3, n3)
    }
    
    // Scenario: An intersection with a smooth triangle stores u/v
    // When r ← ray(point(-0.2, 0.3, -2), vector(0, 0, 1))
    // And xs ← local_intersect(tri, r)
    // Then xs[0].u = 0.45 And xs[0].v = 0.25
    func testAnIntersectionWithASmoothTriangleStoresUandV() {
        let p1 = Point(x: 0, y: 1, z: 0)
        let p2 = Point(x: -1, y: 0, z: 0)
        let p3 = Point(x: 1, y: 0, z: 0)
        let n1 = Vector(x: 0, y: 1, z: 0)
        let n2 = Vector(x: -1, y: 0, z: 0)
        let n3 = Vector(x: 1, y: 0, z: 0)
        let tri = SmoothTriangle(p1: p1, p2: p2, p3: p3,
                                 n1: n1, n2: n2, n3: n3)
        let r = Ray(orig: Point(x: -0.2, y: 0.3, z: -2),
                    dir: Vector(x: 0, y: 0, z: 1))
        let xs = tri.local_intersect(ray: r)
        XCTAssertEqual(xs.list[0].u, 0.45, accuracy: epsilon)
        XCTAssertEqual(xs.list[0].v, 0.25, accuracy: epsilon)
    }
    
    // Scenario: A smooth triangle uses u/v to interpolate the normal
    // When i ← intersection_with_uv(1, tri, 0.45, 0.25)
    // And n ← normal_at(tri, point(0, 0, 0), i)
    // Then n = vector(-0.5547, 0.83205, 0)
    func testASmoothTriangleUsesUVToInterpolateTheNormal() {
        let p1 = Point(x: 0, y: 1, z: 0)
        let p2 = Point(x: -1, y: 0, z: 0)
        let p3 = Point(x: 1, y: 0, z: 0)
        let n1 = Vector(x: 0, y: 1, z: 0)
        let n2 = Vector(x: -1, y: 0, z: 0)
        let n3 = Vector(x: 1, y: 0, z: 0)
        let tri = SmoothTriangle(p1: p1, p2: p2, p3: p3,
                                 n1: n1, n2: n2, n3: n3)
        let i = tri.intersectionWithUV(t: 1, object: tri, u: 0.45, v: 0.25)
        let n = tri.normalAt(p: Point(x: 0, y: 0, z: 0), hit: i)
        XCTAssertEqual(n, Vector(x: -0.5547, y: 0.83205, z: 0))
    }
    
    // Scenario: Preparing the normal on a smooth triangle
    // When i ← intersection_with_uv(1, tri, 0.45, 0.25)
    // And r ← ray(point(-0.2, 0.3, -2), vector(0, 0, 1))
    // And xs ← intersections(i) And comps ← prepare_computations(i, r, xs)
    // Then comps.normalv = vector(-0.5547, 0.83205, 0)
    func testPreparingTheNormalOnASmoothTriangle() {
        let p1 = Point(x: 0, y: 1, z: 0)
        let p2 = Point(x: -1, y: 0, z: 0)
        let p3 = Point(x: 1, y: 0, z: 0)
        let n1 = Vector(x: 0, y: 1, z: 0)
        let n2 = Vector(x: -1, y: 0, z: 0)
        let n3 = Vector(x: 1, y: 0, z: 0)
        let tri = SmoothTriangle(p1: p1, p2: p2, p3: p3,
                                 n1: n1, n2: n2, n3: n3)
        let i = tri.intersectionWithUV(t: 1, object: tri, u: 0.45, v: 0.25)
        let r = Ray(orig: Point(x: -0.2, y: 0.3, z: -2),
                    dir: Vector(x: 0, y: 0, z: 1))
        let xs = Intersections([i])
        let comps = i.prepare(with: r, xs: xs)
        XCTAssertEqual(comps.normal, Vector(x: -0.5547, y: 0.83205, z: 0))
    }
}
