//
//  IntersectionFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class IntersectionFeatures: XCTestCase {

    // Scenario: An intersection encapsulates t and object
    // Given s ← sphere()
    // When i ← intersection(3.5, s), Then i.t = 3.5 And i.object = s
    func testIntersectionEncapsulatesTAndObject() {
        let s = Sphere()
        let i = Intersection(t: 3.5, object: s)
        XCTAssertEqual(i.t, 3.5)
        XCTAssertEqual(i.object, s)
    }
    
    // Scenario: Aggregating intersections
    // Given s ← sphere() And i1 ← intersection(1, s) And i2 ← intersection(2, s)
    // When xs ← intersections(i1, i2)
    // Then xs.count = 2 And xs[0].t = 1 And xs[1].t = 2
    func testAggregatingIntersections() {
        let s = Sphere()
        let i1 = Intersection(t: 1, object: s)
        let i2 = Intersection(t: 2, object: s)
        let xs = Intersections([i1,i2])
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs.list[0].t, 1)
        XCTAssertEqual(xs.list[1].t, 2)
    }

    // Scenario: The hit, when all intersections have positive t
    // Given s ← sphere() And i1 ← intersection(1, s)
    // And i2 ← intersection(2, s) And xs ← intersections(i2, i1)
    // When i ← hit(xs) Then i = i1
    func testTheHitAllPositive() {
        let s = Sphere()
        let i1 = Intersection(t: 1, object: s)
        let i2 = Intersection(t: 2, object: s)
        let xs = Intersections([i1, i2])
        let i = xs.hit()!
        XCTAssertEqual(i, i1)
    }
    
    // Scenario: The hit, when some intersections have negative t
    // Given s ← sphere() And i1 ← intersection(-1, s)
    // And i2 ← intersection(1, s) And xs ← intersections(i2, i1)
    // When i ← hit(xs) Then i = i2
    func testTheHitWhenSomeHaveNegativeT() {
        let s = Sphere()
        let i1 = Intersection(t: -1, object: s)
        let i2 = Intersection(t: 1, object: s)
        let xs = Intersections([i1, i2])
        let i = xs.hit()!
        XCTAssertEqual(i, i2)
    }
    
    // Scenario: The hit, when all intersections have negative t
    // Given s ← sphere() And i1 ← intersection(-2, s)
    // And i2 ← intersection(-1, s) And xs ← intersections(i2, i1)
    // When i ← hit(xs) Then i is nothing
    func testTheHitWhenAllNegative() {
        let s = Sphere()
        let i1 = Intersection(t: -2, object: s)
        let i2 = Intersection(t: -1, object: s)
        let xs = Intersections([i1, i2])
        let i = xs.hit()
        XCTAssertTrue(i == nil)
    }

    // Scenario: The hit is always the lowest non-negative intersection
    // Given s ← sphere() And i1 ← intersection(5, s)
    // And i2 ← intersection(7, s) And i3 ← intersection(-3, s)
    // And i4 ← intersection(2, s) And xs ← intersections(i1, i2, i3, i4)
    // When i ← hit(xs) Then i = i4
    func testTheHitIsAlwaysTheLowestNonNegativeIntersection() {
        let s = Sphere()
        let i1 = Intersection(t: 5, object: s)
        let i2 = Intersection(t: 7, object: s)
        let i3 = Intersection(t: -3, object: s)
        let i4 = Intersection(t: 2, object: s)
        let xs = Intersections([i1, i2, i3, i4])
        let i = xs.hit()!
        XCTAssertEqual(i, i4)
    }

    // Scenario: Precomputing the state of an intersection
    // Given r ← ray(point(0, 0, -5), vector(0, 0, 1)) And shape ← sphere()
    // And i ← intersection(4, shape)
    // When comps ← prepare_computations(i, r) Then comps.t = i.t
    // And comps.object = i.object And comps.point = point(0, 0, -1)
    // And comps.eyev = vector(0, 0, -1) And comps.normalv = vector(0, 0, -1)
    func testPrecomputingTheStateOfAnIntersection() {
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let shape = Sphere()
        let i = Intersection(t: 4, object: shape)
        let comps = i.prepare(with: r)
        XCTAssertEqual(comps.t, i.t)
        XCTAssertEqual(comps.object, i.object)
        XCTAssertEqual(comps.point, Point(x: 0, y: 0, z: -1))
        XCTAssertEqual(comps.eyeVector, Vector(x: 0, y: 0, z: -1))
        XCTAssertEqual(comps.normal, Vector(x: 0, y: 0, z: -1))
    }
    
    // Scenario: The hit, when an intersection occurs on the outside
    // Given r ← ray(point(0, 0, -5), vector(0, 0, 1)) And shape ← sphere()
    // And i ← intersection(4, shape)
    // When comps ← prepare_computations(i, r) Then comps.inside = false
    func testTheHitWhenAnIntersectionOccursOnTheOutside() {
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let shape = Sphere()
        let i = Intersection(t: 4, object: shape)
        let comps = i.prepare(with: r)
        XCTAssertFalse(comps.isInside)
    }
    
    // Scenario: The hit, when an intersection occurs on the inside
    // Given r ← ray(point(0, 0, 0), vector(0, 0, 1)) And shape ← sphere()
    // And i ← intersection(1, shape) When comps ← prepare_computations(i, r)
    // Then comps.point = point(0, 0, 1) And comps.eyev = vector(0, 0, -1)
    // And comps.inside = true
    // # normal would have been (0, 0, 1), but is inverted!
    // And comps.normalv = vector(0, 0, -1)
    func testTheHitWhenAnIntersectionOccursOnTheInside() {
        let r = Ray(orig: Point(x: 0, y: 0, z: 0), dir: Vector(x: 0, y: 0, z: 1))
        let shape = Sphere()
        let i = Intersection(t: 1, object: shape)
        let comps = i.prepare(with: r)
        XCTAssertEqual(comps.point, Point(x: 0, y: 0, z: 1))
        XCTAssertEqual(comps.eyeVector, Vector(x: 0, y: 0, z: -1))
        XCTAssertTrue(comps.isInside)
        XCTAssertEqual(comps.normal, Vector(x: 0, y: 0, z: -1))
    }

    // Scenario: The hit should offset the point
    // Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    // And shape ← sphere() with translation(0, 0, 1)
    // And i ← intersection(5, shape)
    // When comps ← prepare_computations(i, r)
    // Then comps.over_point.z < -EPSILON/2
    // And comps.point.z > comps.over_point.z
    func testTheHitShouldOffsetThePoint() {
        let EPSILON = 0.00001
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let shape = Sphere()
        shape.transform = Matrix.translation(x: 0, y: 0, z: 1)
        let i = Intersection(t: 5, object: shape)
        let comps = i.prepare(with: r)
        XCTAssertLessThan(comps.overPoint.z, Double(-EPSILON/2))
        XCTAssertGreaterThan(comps.point.z, comps.overPoint.z)
    }

    // Scenario: Precomputing the reflection vector
    // Given shape ← plane() And r ← ray(point(0, 1, -1), vector(0, -√2/2, √2/2))
    // And i ← intersection(√2, shape)
    // When comps ← prepare_computations(i, r)
    // Then comps.reflectv = vector(0, √2/2, √2/2)
    func testPrecomputingTheReflectionVector() {
        let shape = Plane()
        let r = Ray(orig: Point(x: 0, y: 1, z: -1), dir: Vector(x: 0, y: -sqrt(2)/2, z: sqrt(2)/2))
        let i = Intersection(t: sqrt(2), object: shape)
        let comps = i.prepare(with: r)
        XCTAssertEqual(comps.reflectv, Vector(x: 0, y: sqrt(2)/2, z: sqrt(2)/2))
    }

    // Scenario Outline: Finding n1 and n2 at various intersections
    // Given A ← glass_sphere() with:
    // transform: scaling(2, 2, 2) and material.refractive_index = 1.5
    // And B ← glass_sphere() with:
    // transform: translation(0, 0, -0.25) & material.refractive_index = 2.0
    // And C ← glass_sphere() with:
    // transform: translation(0, 0, 0.25) & material.refractive_index = 2.5
    // And r ← ray(point(0, 0, -4), vector(0, 0, 1))
    // And xs ← intersections(2:A, 2.75:B, 3.25:C, 4.75:B, 5.25:C, 6:A)
    // When comps ← prepare_computations(xs[<index>], r, xs)
    // Then comps.n1 = <n1> And comps.n2 = <n2>
    // Examples:
    //     | index | n1  | n2  |
    //     | 0     | 1.0 | 1.5 |
    //     | 1     | 1.5 | 2.0 |
    //     | 2     | 2.0 | 2.5 |
    //     | 3     | 2.5 | 2.5 |
    //     | 4     | 2.5 | 1.5 |
    //     | 5     | 1.5 | 1.0 |
    func testFindingN1AndN2ForVariousIntersections() {
        let A = Sphere.glassSphere()
        A.transform = Matrix.scaling(x: 2, y: 2, z: 2)
        A.material.refractiveIndex = 1.5
        let B = Sphere.glassSphere()
        B.transform = Matrix.translation(x: 0, y: 0, z: -0.25)
        B.material.refractiveIndex = 2.0
        let C = Sphere.glassSphere()
        C.transform = Matrix.translation(x: 0, y: 0, z: 0.25)
        C.material.refractiveIndex = 2.5
        let r = Ray(orig: Point(x: 0, y: 0, z: -4), dir: Vector(x: 0, y: 0, z: 1))
        let i0 = Intersection(t: 2, object: A)
        let i1 = Intersection(t: 2.75, object: B)
        let i2 = Intersection(t: 3.25, object: C)
        let i3 = Intersection(t: 4.75, object: B)
        let i4 = Intersection(t: 5.25, object: C)
        let i5 = Intersection(t: 6, object: A)
        let xs = Intersections([i0,i1,i2,i3,i4,i5])
        let comp0 = i0.prepare(with: r, xs: xs)
        XCTAssertEqual(comp0.n1, 1.0)
        XCTAssertEqual(comp0.n2, 1.5)
        let comp1 = i1.prepare(with: r, xs: xs)
        XCTAssertEqual(comp1.n1, 1.5)
        XCTAssertEqual(comp1.n2, 2.0)
        let comp2 = i2.prepare(with: r, xs: xs)
        XCTAssertEqual(comp2.n1, 2.0)
        XCTAssertEqual(comp2.n2, 2.5)
        let comp3 = i3.prepare(with: r, xs: xs)
        XCTAssertEqual(comp3.n1, 2.5)
        XCTAssertEqual(comp3.n2, 2.5)
        let comp4 = i4.prepare(with: r, xs: xs)
        XCTAssertEqual(comp4.n1, 2.5)
        XCTAssertEqual(comp4.n2, 1.5)
        let comp5 = i5.prepare(with: r, xs: xs)
        XCTAssertEqual(comp5.n1, 1.5)
        XCTAssertEqual(comp5.n2, 1.0)
    }

    // Scenario: The under point is offset below the surface
    // Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    // And shape ← glass_sphere() with transform: translation(0, 0, 1)
    // And i ← intersection(5, shape) And xs ← intersections(i)
    // When comps ← prepare_computations(i, r, xs)
    // Then comps.under_point.z > EPSILON/2
    // And comps.point.z < comps.under_point.z
    func testTheUnderPointIsOffsetBelowTheSurface() {
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let shape = Sphere.glassSphere()
        shape.transform = Matrix.translation(x: 0, y: 0, z: 1)
        let i = Intersection(t: 5, object: shape)
        let xs = Intersections([i])
        let comps = i.prepare(with: r, xs: xs)
        XCTAssertTrue(comps.underPoint.z > 0.00001 / 2)
        XCTAssertTrue(comps.point.z < comps.underPoint.z)
    }

    // Scenario: The Schlick approximation under total internal reflection
    // Given shape ← glass_sphere() And r ← ray(point(0, 0, √2/2), vector(0, 1, 0))
    // And xs ← intersections(-√2/2:shape, √2/2:shape)
    // When comps ← prepare_computations(xs[1], r, xs)
    // And reflectance ← schlick(comps) Then reflectance = 1.0
    func testTheSchlickApproximationUnderTotalInternalReflection() {
        let shape = Sphere.glassSphere()
        let r = Ray(orig: Point(x: 0, y: 0, z: sqrt(2)/2),
                    dir: Vector(x: 0, y: 1, z: 0))
        let i0 = Intersection(t: -sqrt(2)/2, object: shape)
        let i1 = Intersection(t: sqrt(2)/2, object: shape)
        let xs = Intersections([i0, i1])
        let comps = i1.prepare(with: r, xs: xs)
        let reflectance = comps.schlick()
        XCTAssertEqual(reflectance, 1.0)
    }
    
    // Scenario: The Schlick approximation with a perpendicular viewing angle
    // Given shape ← glass_sphere() And r ← ray(point(0, 0, 0), vector(0, 1, 0))
    // And xs ← intersections(-1:shape, 1:shape)
    // When comps ← prepare_computations(xs[1], r, xs)
    // And reflectance ← schlick(comps) Then reflectance = 0.04
    func testTheSchlickApproximationWithAPerpendicularViewingAngle() {
        let shape = Sphere.glassSphere()
        let r = Ray(orig: Point(x: 0, y: 0, z: 0), dir: Vector(x: 0, y: 1, z: 0))
        let i0 = Intersection(t: -1, object: shape)
        let i1 = Intersection(t: 1, object: shape)
        let xs = Intersections([i0, i1])
        let comps = i1.prepare(with: r, xs: xs)
        let reflectance = comps.schlick()
        XCTAssertEqual(reflectance, 0.04, accuracy: 0.0001)
    }
    
    // Scenario: The Schlick approximation with small angle and n2 > n1
    // Given shape ← glass_sphere() And r ← ray(point(0, 0.99, -2), vector(0, 0, 1))
    // And xs ← intersections(1.8589:shape)
    // When comps ← prepare_computations(xs[0], r, xs)
    // And reflectance ← schlick(comps) Then reflectance = 0.48873
    func testTheSchlickApproximationWithSmallAngleAndN2GtN1() {
        let shape = Sphere.glassSphere()
        let r = Ray(orig: Point(x: 0, y: 0.99, z: -2), dir: Vector(x: 0, y: 0, z: 1))
        let i0 = Intersection(t: 1.8589, object: shape)
        let xs = Intersections([i0])
        let comps = i0.prepare(with: r, xs: xs)
        let reflectance = comps.schlick()
        XCTAssertEqual(reflectance, 0.48873, accuracy: 0.0001)
    }

    // Scenario: An intersection can encapsulate `u` and `v`
    // Given s ← triangle(point(0, 1, 0), point(-1, 0, 0), point(1, 0, 0))
    // When i ← intersection_with_uv(3.5, s, 0.2, 0.4)
    // Then i.u = 0.2 And i.v = 0.4
    func testAnIntersectionCanEncapsulateUAndV() {
        let s = Triangle(p1: Point(x: 0, y: 1, z: 0),
                         p2: Point(x: -1, y: 0, z: 0),
                         p3: Point(x: 1, y: 0, z: 0))
        let i = s.intersectionWithUV(t: 3.5, object: s, u: 0.2, v: 0.4)
        XCTAssertEqual(i.u, 0.2)
        XCTAssertEqual(i.v, 0.4)
    }
}
