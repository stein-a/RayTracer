//
//  SphereFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class SphereFeatures: XCTestCase {

    // Scenario: A ray intersects a sphere at two points
    // Given r ← ray(point(0, 0, -5), vector(0, 0, 1)) And s ← sphere()
    // When xs ← intersect(s, r) Then xs.count = 2 And xs[0] = 4.0 And xs[1] = 6.0
    func testARayIntersectsASphereInTwoPoints() {
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = Intersect(sphere: s, ray: r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs.hits[0], 4.0)
        XCTAssertEqual(xs.hits[1], 6.0)
    }
    
    // Scenario: A ray intersects a sphere at a tangent
    // Given r ← ray(point(0, 1, -5), vector(0, 0, 1)) And s ← sphere()
    // When xs ← intersect(s, r) Then xs.count = 2 And xs[0] = 5.0 And xs[1] = 5.0
    func testARayIntersectsASphereAtATangent() {
        let r = Ray(orig: Point(x: 0, y: 1, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = Intersect(sphere: s, ray: r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs.hits[0], 5.0)
        XCTAssertEqual(xs.hits[1], 5.0)
    }
    
    // Scenario: A ray misses a sphere
    // Given r ← ray(point(0, 2, -5), vector(0, 0, 1)) And s ← sphere()
    // When xs ← intersect(s, r) Then xs.count = 0
    func testARayMissesASphere() {
        let r = Ray(orig: Point(x: 0, y: 2, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = Intersect(sphere: s, ray: r)
        XCTAssertEqual(xs.count, 0)
    }
    
    // Scenario: A ray originates inside a sphere
    // Given r ← ray(point(0, 0, 0), vector(0, 0, 1)) And s ← sphere()
    // When xs ← intersect(s, r) Then xs.count = 2 And xs[0] = -1.0 And xs[1] = 1.0
    func testARayOriginatesInsideASphere() {
        let r = Ray(orig: Point(x: 0, y: 0, z: 0), dir: Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = Intersect(sphere: s, ray: r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs.hits[0], -1.0)
        XCTAssertEqual(xs.hits[1], 1.0)
    }
    
    // Scenario: A sphere is behind a ray
    // Given r ← ray(point(0, 0, 5), vector(0, 0, 1)) And s ← sphere()
    // When xs ← intersect(s, r) Then xs.count = 2 And xs[0] = -6.0 And xs[1] = -4.0
    func testASphereIsBehindARay() {
        let r = Ray(orig: Point(x: 0, y: 0, z: 5), dir: Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = Intersect(sphere: s, ray: r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs.hits[0], -6.0)
        XCTAssertEqual(xs.hits[1], -4.0)
    }

    // Scenario: Intersect sets the object on the intersection
    // Given r ← ray(point(0, 0, -5), vector(0, 0, 1)) And s ← sphere()
    // When xs ← intersect(s, r) Then xs.count = 2
    // And xs[0].object = s And xs[1].object = s
    func testIntersectSetsTheObjectOnTheIntersection() {
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        let xs = s.intersect(ray: r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs.list[0].object, s)
        XCTAssertEqual(xs.list[1].object, s)
    }

    // Scenario: A sphere's default transformation
    // Given s ← sphere() Then s.transform = identity_matrix
    func testASpheresDefaultTransformation() {
        let s = Sphere()
        XCTAssertEqual(s.transform, Matrix.identity())
    }
    
    // Scenario: Changing a sphere's transformation
    // Given s ← sphere() And t ← translation(2, 3, 4)
    // When set_transform(s, t) Then s.transform = t
    func testChangingASpheresTransformation() {
        let s = Sphere()
        let t = Matrix.translation(x: 2, y: 3, z: 4)
        s.transform = t
        XCTAssertEqual(s.transform, t)
    }
    
    // Scenario: Intersecting a scaled sphere with a ray
    // Given r ← ray(point(0, 0, -5), vector(0, 0, 1)) And s ← sphere()
    // When set_transform(s, scaling(2, 2, 2)) And xs ← intersect(s, r)
    // Then xs.count = 2 And xs[0].t = 3 And xs[1].t = 7
    func testIntersectingAScaledSphereWithARay() {
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        s.transform = Matrix.scaling(x: 2, y: 2, z: 2)
        let xs = s.intersect(ray: r)
        XCTAssertEqual(xs.count, 2)
        XCTAssertEqual(xs.list[0].t, 3)
        XCTAssertEqual(xs.list[1].t, 7)
    }
    
    // Scenario: Intersecting a translated sphere with a ray
    // Given r ← ray(point(0, 0, -5), vector(0, 0, 1)) And s ← sphere()
    // When set_transform(s, translation(5, 0, 0)) And xs ← intersect(s, r)
    // Then xs.count = 0
    func testIntersectingATranslatedSphereWithARay() {
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let s = Sphere()
        s.transform = Matrix.translation(x: 5, y: 0, z: 0)
        let xs = s.intersect(ray: r)
        XCTAssertEqual(xs.count, 0)
    }

    // Scenario: The normal on a sphere at a point on the x axis
    // Given s ← sphere() When n ← normal_at(s, point(1, 0, 0))
    // Then n = vector(1, 0, 0)
    func testTheNormalOnASphereAtAPointOnTheXAxis() {
        let s = Sphere()
        let n = s.normalAt(p: Point(x: 1, y: 0, z: 0))
        XCTAssertEqual(n, Vector(x: 1, y: 0, z: 0))
    }
    
    // Scenario: The normal on a sphere at a point on the y axis
    // Given s ← sphere() When n ← normal_at(s, point(0, 1, 0))
    // Then n = vector(0, 1, 0)
    func testTheNormalOnASphereAtAPointOnTheYAxis() {
        let s = Sphere()
        let n = s.normalAt(p: Point(x: 0, y: 1, z: 0))
        XCTAssertEqual(n, Vector(x: 0, y: 1, z: 0))
    }
    
    // Scenario: The normal on a sphere at a point on the z axis
    // Given s ← sphere() When n ← normal_at(s, point(0, 0, 1))
    // Then n = vector(0, 0, 1)
    func testTheNormalOnASphereAtAPointOnTheZAxis() {
        let s = Sphere()
        let n = s.normalAt(p: Point(x: 0, y: 0, z: 1))
        XCTAssertEqual(n, Vector(x: 0, y: 0, z: 1))
    }
    
    // Scenario: The normal on a sphere at a non-axial point
    // Given s ← sphere() When n ← normal_at(s, point(√3/3, √3/3, √3/3))
    // Then n = vector(√3/3, √3/3, √3/3)
    func testTheNormalOnASphereAtANonAxialPoint() {
        let s = Sphere()
        let n = s.normalAt(p: Point(x: sqrtf(3)/3, y: sqrtf(3)/3, z: sqrtf(3)/3))
        XCTAssertEqual(n, Vector(x: sqrtf(3)/3, y: sqrtf(3)/3, z: sqrtf(3)/3))
    }
    
    // Scenario: The normal is a normalized vector
    // Given s ← sphere() When n ← normal_at(s, point(√3/3, √3/3, √3/3))
    // Then n = normalize(n)
    func testTheNormalIsANormalizedVector() {
        let s = Sphere()
        let n = s.normalAt(p: Point(x: sqrtf(3)/3, y: sqrtf(3)/3, z: sqrtf(3)/3))
        XCTAssertEqual(n, n.normalize())
    }
    
    // Scenario: Computing the normal on a translated sphere
    // Given s ← sphere() And set_transform(s, translation(0, 1, 0))
    // When n ← normal_at(s, point(0, 1.70711, -0.70711))
    // Then n = vector(0, 0.70711, -0.70711)
    func testComputingTheNormalOnATranslatedSphere() {
        let s = Sphere()
        s.transform = Matrix.translation(x: 0, y: 1, z: 0)
        let n = s.normalAt(p: Point(x: 0, y: 1.70711, z: -0.70711))
        XCTAssertEqual(n, Vector(x: 0, y: 0.70711, z: -0.70711))
    }
    
    // Scenario: Computing the normal on a transformed sphere
    // Given s ← sphere() And m ← scaling(1, 0.5, 1) * rotation_z(π/5)
    // And set_transform(s, m) When n ← normal_at(s, point(0, √2/2, -√2/2))
    // Then n = vector(0, 0.97014, -0.24254)
    func testComputingTheNormalOnATransformedSphere() {
        let s = Sphere()
        let m = Matrix.scaling(x: 1, y: 0.5, z: 1) * Matrix.rotation_z(r: .pi/5)
        s.transform = m
        let n = s.normalAt(p: Point(x: 0, y: sqrtf(2)/2, z: -sqrtf(2)/2))
        XCTAssertEqual(n, Vector(x: 0, y: 0.97014, z: -0.24254))
    }

    // Scenario: A sphere has a default material
    // Given s ← sphere() When m ← s.material Then m = material()
    func testASphereHasADefaultMaterial() {
        let s = Sphere()
        let m = s.material
        XCTAssertEqual(m, Material())
    }
    
    // Scenario: A sphere may be assigned a material
    // Given s ← sphere() And m ← material() And m.ambient ← 1
    // When s.material ← m Then s.material = m
    func testASphereMayBeAssignedAMaterial() {
        let s = Sphere()
        let m = Material()
        m.ambient = 1
        s.material = m
        XCTAssertEqual(s.material, m)
    }

    // Scenario: A helper for producing a sphere with a glassy material
    // Given s ← glass_sphere() Then s.transform = identity_matrix
    // And s.material.transparency = 1.0 And s.material.refractive_index = 1.5
    func testAHelperForProducingASphereWithAGlassyMaterial() {
        let s = Sphere.glassSphere()
        XCTAssertEqual(s.transform, Matrix.identity())
        XCTAssertEqual(s.material.transparency, 1.0)
        XCTAssertEqual(s.material.refractiveIndex, 1.5)
    }

}
