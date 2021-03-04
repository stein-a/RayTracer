//
//  GroupFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class GroupFeatures: XCTestCase {

    // Scenario: Creating a new group
    // Given g ← group() Then g.transform = identity_matrix And g is empty
    func testCreatingANewGroup() {
        let g = Group()
        XCTAssertEqual(g.transform, Matrix4.identity())
        XCTAssertTrue(g.isEmpty())
    }
 
    // Scenario: Adding a child to a group
    // Given g ← group() And s ← test_shape()
    // When add_child(g, s) Then g is not empty And g includes s And s.parent = g
    func testAddingAChildToAGroup() {
        let g = Group()
        let s = Shape.testShape()
        g.addChild(shape: s)
        XCTAssertFalse(g.isEmpty())
        XCTAssertTrue(g.includes(shape: s))
        XCTAssertEqual(s.parent!, g)
    }
    
    // Scenario: Intersecting a ray with an empty group
    // Given g ← group() And r ← ray(point(0, 0, 0), vector(0, 0, 1))
    // When xs ← local_intersect(g, r) Then xs is empty
    func testIntersectingARayWithAnEmptyGroup() {
        let g = Group()
        let r = Ray(orig: Point(x: 0, y: 0, z: 0), dir: Vector(x: 0, y: 0, z: 1))
        let xs = g.local_intersect(ray: r)
        XCTAssertEqual(xs.count, 0)
    }
    
    // Scenario: Intersecting a ray with a non-empty group
    // Given g ← group() And s1 ← sphere() And s2 ← sphere()
    // And set_transform(s2, translation(0, 0, -3)) And s3 ← sphere()
    // And set_transform(s3, translation(5, 0, 0)) And add_child(g, s1)
    // And add_child(g, s2) And add_child(g, s3)
    // When r ← ray(point(0, 0, -5), vector(0, 0, 1))
    // And xs ← local_intersect(g, r)
    // Then xs.count = 4 And xs[0].object = s2 And xs[1].object = s2
    // And xs[2].object = s1 And xs[3].object = s1
    func testIntersectingARayWithANonEmptyGroup() {
        let g = Group()
        let s1 = Sphere()
        let s2 = Sphere()
        let s3 = Sphere()
        s2.transform = Matrix4.translation(x: 0, y: 0, z: -3)
        s3.transform = Matrix4.translation(x: 5, y: 0, z: 0)
        g.addChild(shape: s1)
        g.addChild(shape: s2)
        g.addChild(shape: s3)
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let xs = g.local_intersect(ray: r)
        XCTAssertEqual(xs.count, 4)
        XCTAssertEqual(xs.list[0].object, s2)
        XCTAssertEqual(xs.list[1].object, s2)
        XCTAssertEqual(xs.list[2].object, s1)
        XCTAssertEqual(xs.list[3].object, s1)
    }
    
    // Scenario: Intersecting a transformed group
    // Given g ← group() And set_transform(g, scaling(2, 2, 2))
    // And s ← sphere() And set_transform(s, translation(5, 0, 0))
    // And add_child(g, s)
    // When r ← ray(point(10, 0, -10), vector(0, 0, 1))
    // And xs ← intersect(g, r) Then xs.count = 2
    func testIntersectingATransformedGroup() {
        let g = Group()
        g.transform = Matrix4.scaling(x: 2, y: 2, z: 2)
        let s = Sphere()
        s.transform = Matrix4.translation(x: 5, y: 0, z: 0)
        g.addChild(shape: s)
        let r = Ray(orig: Point(x: 10, y: 0, z: -10),
                    dir: Vector(x: 0, y: 0, z: 1))
        let xs = g.intersect(ray: r)
        XCTAssertEqual(xs.count, 2)
    }
    
}
