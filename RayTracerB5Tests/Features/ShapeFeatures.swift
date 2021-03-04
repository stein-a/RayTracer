//
//  ShapeFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class ShapeFeatures: XCTestCase {

    // Scenario: The default transformation
    // Given s ← test_shape() Then s.transform = identity_matrix
    func testTheDefaultTransformation() {
        let s = Shape.testShape()
        XCTAssertEqual(s.transform, Matrix4.identity())
    }
    
    // Scenario: Assigning a transformation
    // Given s ← test_shape()
    // When set_transform(s, translation(2, 3, 4))
    // Then s.transform = translation(2, 3, 4)
    func testAssigningATransformation() {
        let s = Shape.testShape()
        s.transform = Matrix4.translation(x: 2, y: 3, z: 4)
        XCTAssertEqual(s.transform, Matrix4.translation(x: 2, y: 3, z: 4))
    }
    
    // Scenario: The default material
    // Given s ← test_shape() When m ← s.material Then m = material()
    func testTheDefaultMaterial() {
        let s = Shape.testShape()
        XCTAssertEqual(s.material, Material())
    }
    
    // Scenario: Assigning a material
    // Given s ← test_shape() And m ← material() And m.ambient ← 1
    // When s.material ← m Then s.material = m
    func testAssigningAMaterial() {
        let s = Shape.testShape()
        let m = Material()
        m.ambient = 1
        s.material = m
        XCTAssertEqual(s.material, m)
    }
    
    // Scenario: Intersecting a scaled shape with a ray
    // Given r ← ray(point(0, 0, -5), vector(0, 0, 1)) And s ← test_shape()
    // When set_transform(s, scaling(2, 2, 2)) And xs ← intersect(s, r)
    // Then s.saved_ray.origin = point(0, 0, -2.5)
    // And s.saved_ray.direction = vector(0, 0, 0.5)
    func testIntersectingAScaledShapeWithARay() {
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let s = Shape.testShape()
        s.transform = Matrix4.scaling(x: 2, y: 2, z: 2)
        _ = s.intersect(ray: r)
        XCTAssertEqual(s.savedRay!.origin, Point(x: 0, y: 0, z: -2.5))
        XCTAssertEqual(s.savedRay?.direction, Vector(x: 0, y: 0, z: 0.5))
    }
    
    // Scenario: Intersecting a translated shape with a ray
    // Given r ← ray(point(0, 0, -5), vector(0, 0, 1)) And s ← test_shape()
    // When set_transform(s, translation(5, 0, 0)) And xs ← intersect(s, r)
    // Then s.saved_ray.origin = point(-5, 0, -5)
    // And s.saved_ray.direction = vector(0, 0, 1)
    func testIntersectingATranslatedShapeWithARay() {
        let r = Ray(orig: Point(x: 0, y: 0, z: -5), dir: Vector(x: 0, y: 0, z: 1))
        let s = Shape.testShape()
        s.transform = Matrix4.translation(x: 5, y: 0, z: 0)
        _ = s.intersect(ray: r)
        XCTAssertEqual(s.savedRay!.origin, Point(x: -5, y: 0, z: -5))
        XCTAssertEqual(s.savedRay!.direction, Vector(x: 0, y: 0, z: 1))
    }
    
    // Scenario: Computing the normal on a translated shape
    // Given s ← test_shape() When set_transform(s, translation(0, 1, 0))
    // And n ← normal_at(s, point(0, 1.70711, -0.70711))
    // Then n = vector(0, 0.70711, -0.70711)
    func testComputingTheNormalOnATranslatedShape() {
        let s = Shape.testShape()
        s.transform = Matrix4.translation(x: 0, y: 1, z: 0)
        let n = s.normalAt(p: Point(x: 0, y: 1.70711, z: -0.70711), hit: Intersection(t: 0, object: s))
        XCTAssertEqual(n, Vector(x: 0, y: 0.70711, z: -0.70711))
    }
    
    // Scenario: Computing the normal on a transformed shape
    // Given s ← test_shape() And m ← scaling(1, 0.5, 1) * rotation_z(π/5)
    // When set_transform(s, m) And n ← normal_at(s, point(0, √2/2, -√2/2))
    // Then n = vector(0, 0.97014, -0.24254)
    func testComputingTheNormalOnATransformedShape() {
        let s = Shape.testShape()
        let m = Matrix4.scaling(x: 1, y: 0.5, z: 1) * Matrix4.rotation_z(r: .pi/5)
        s.transform = m
        let n = s.normalAt(p: Point(x: 0, y: sqrt(2)/2, z: -sqrt(2)/2), hit: Intersection(t: 0, object: s))
        XCTAssertEqual(n, Vector(x: 0, y: 0.97014, z: -0.24254))
    }
    
    // Scenario: A shape has a parent attribute
    // Given s ← test_shape() Then s.parent is nothing
    func testAShapeHasAParentAttribute() {
        let s = Shape.testShape()
        XCTAssertTrue(s.parent == nil)
    }

    // Scenario: Converting a point from world to object space
    // Given g1 ← group() And set_transform(g1, rotation_y(π/2))
    // And g2 ← group() And set_transform(g2, scaling(2, 2, 2))
    // And add_child(g1, g2)
    // And s ← sphere() And set_transform(s, translation(5, 0, 0))
    // And add_child(g2, s)
    // When p ← world_to_object(s, point(-2, 0, -10)) Then p = point(0, 0, -1)
    func testConvertingAPointFromWorldToObjectSpace() {
        let g1 = Group()
        g1.transform = Matrix4.rotation_y(r: .pi/2)
        let g2 = Group()
        g2.transform = Matrix4.scaling(x: 2, y: 2, z: 2)
        g1.addChild(shape: g2)
        let s = Sphere()
        s.transform = Matrix4.translation(x: 5, y: 0, z: 0)
        g2.addChild(shape: s)
        XCTAssertEqual(s.worldToObject(p: Point(x: -2, y: 0, z: -10)),
                       Point(x: 0, y: 0, z: -1))
    }
    
    // Scenario: Converting a normal from object to world space
    // Given g1 ← group() And set_transform(g1, rotation_y(π/2))
    // And g2 ← group() And set_transform(g2, scaling(1, 2, 3))
    // And add_child(g1, g2)
    // And s ← sphere() And set_transform(s, translation(5, 0, 0))
    // And add_child(g2, s)
    // When n ← normal_to_world(s, vector(√3/3, √3/3, √3/3))
    // Then n = vector(0.2857, 0.4286, -0.8571)
    func testConvertingANormalFromObjectToWorldSpace() {
        let g1 = Group()
        g1.transform = Matrix4.rotation_y(r: .pi/2)
        let g2 = Group()
        g2.transform = Matrix4.scaling(x: 1, y: 2, z: 3)
        g1.addChild(shape: g2)
        let s = Sphere()
        s.transform = Matrix4.translation(x: 5, y: 0, z: 0)
        g2.addChild(shape: s)
        let n = Vector(x: sqrt(3)/3, y: sqrt(3)/3, z: sqrt(3)/3)
        XCTAssertEqual(s.normalToWorld(normal: n),
                       Vector(x: 0.2857, y: 0.4286, z: -0.8571))
    }
    
    // Scenario: Finding the normal on a child object
    // Given g1 ← group() And set_transform(g1, rotation_y(π/2))
    // And g2 ← group() And set_transform(g2, scaling(1, 2, 3))
    // And add_child(g1, g2)
    // And s ← sphere() And set_transform(s, translation(5, 0, 0))
    // And add_child(g2, s)
    // When n ← normal_at(s, point(1.7321, 1.1547, -5.5774))
    // Then n = vector(0.2857, 0.4286, -0.8571)
    func testFindingTheNormalOnAChildObject() {
        let g1 = Group()
        g1.transform = Matrix4.rotation_y(r: .pi/2)
        let g2 = Group()
        g2.transform = Matrix4.scaling(x: 1, y: 2, z: 3)
        g1.addChild(shape: g2)
        let s = Sphere()
        s.transform = Matrix4.translation(x: 5, y: 0, z: 0)
        g2.addChild(shape: s)
        let n = s.normalAt(p: Point(x: 1.7321, y: 1.1547, z: -5.5774), hit: Intersection(t: 0, object: s))
        XCTAssertEqual(n, Vector(x: 0.2857, y: 0.4286, z: -0.8571))
    }
}
