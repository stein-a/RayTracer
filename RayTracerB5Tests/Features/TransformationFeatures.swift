//
//  TransformationFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

let epsilon: Double = 0.0001

class TransformationFeatures: XCTestCase {

    // Scenario: Multiplying by a translation matrix
    // Given transform ← translation(5, -3, 2) And p ← point(-3, 4, 5)
    // Then transform * p = point(2, 1, 7)
    func testMultiplyingByATranslationMatrix() {
        let transform = Matrix.translation(x: 5, y: -3, z: 2)
        let p = Point(x: -3, y: 4, z: 5)
        XCTAssertEqual(transform * p, Point(x: 2, y: 1, z: 7))
    }
    
    // Scenario: Multiplying by the inverse of a translation matrix
    // Given transform ← translation(5, -3, 2)
    // And inv ← inverse(transform) And p ← point(-3, 4, 5)
    // Then inv * p = point(-8, 7, 3)
    func testMultiplyingByTheInverseOfATranslationMatrix() {
        let transform = Matrix.translation(x: 5, y: -3, z: 2)
        let inv = transform.inverse()
        let p = Point(x: -3, y: 4, z: 5)
        XCTAssertEqual(inv * p, Point(x: -8, y: 7, z: 3))
    }
    
    // Scenario: Translation does not affect vectors
    // Given transform ← translation(5, -3, 2)
    // And v ← vector(-3, 4, 5) Then transform * v = v
    func testTranslationDoesNotAffectVectors() {
        let transform = Matrix.translation(x: 5, y: -3, z: 2)
        let v = Vector(x: -3, y: 4, z: 5)
        XCTAssertEqual(transform * v, v)
    }
    
    // Scenario: A scaling matrix applied to a point
    // Given transform ← scaling(2, 3, 4) And p ← point(-4, 6, 8)
    // Then transform * p = point(-8, 18, 32)
    func testAScalingMatrixAppliedToAPoint() {
        let transform = Matrix.scaling(x: 2, y: 3, z: 4)
        let p = Point(x: -4, y: 6, z: 8)
        XCTAssertEqual(transform * p, Point(x: -8, y: 18, z: 32))
    }
    
    // Scenario: A scaling matrix applied to a vector
    // Given transform ← scaling(2, 3, 4) And v ← vector(-4, 6, 8)
    // Then transform * v = vector(-8, 18, 32)
    func testAScalingMatrixAppliedToAVector() {
        let transform = Matrix.scaling(x: 2, y: 3, z: 4)
        let v = Vector(x: -4, y: 6, z: 8)
        XCTAssertEqual(transform * v, Vector(x: -8, y: 18, z: 32))
    }
    
    // Scenario: Multiplying by the inverse of a scaling matrix
    // Given transform ← scaling(2, 3, 4) And inv ← inverse(transform)
    // And v ← vector(-4, 6, 8) Then inv * v = vector(-2, 2, 2)
    func testMultiplyingByTheInverseOfAScalingMatrix() {
        let transform = Matrix.scaling(x: 2, y: 3, z: 4)
        let inv = transform.inverse()
        let v = Vector(x: -4, y: 6, z: 8)
        XCTAssertEqual(inv * v, Vector(x: -2, y: 2, z: 2))
    }
    
    // Scenario: Reflection is scaling by a negative value
    // Given transform ← scaling(-1, 1, 1) And p ← point(2, 3, 4)
    // Then transform * p = point(-2, 3, 4)
    func testReflectionIsScalingByANegativeValue() {
        let transform = Matrix.scaling(x: -1, y: 1, z: 1)
        let p = Point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, Point(x: -2, y: 3, z: 4))
    }
    
    // Scenario: Rotating a point around the x axis
    // Given p ← point(0, 1, 0) And half_quarter ← rotation_x(π / 4)
    // And full_quarter ← rotation_x(π / 2)
    // Then half_quarter * p = point(0, √2/2, √2/2)
    // And full_quarter * p = point(0, 0, 1)
    func testRotatingAPointAroundTheXAxis() {
        let p = Point(x: 0, y: 1, z: 0)
        let half_quarter = Matrix.rotation_x(r: .pi/4)
        let full_quarter = Matrix.rotation_x(r: .pi/2)
        XCTAssertEqual(half_quarter * p, Point(x: 0, y: sqrt(2)/2, z: sqrt(2)/2))
        XCTAssertEqual(full_quarter * p, Point(x: 0, y: 0, z: 1))
    }
    
    // Scenario: The inverse of an x-rotation rotates in the opposite direction
    // Given p ← point(0, 1, 0) And half_quarter ← rotation_x(π / 4)
    // And inv ← inverse(half_quarter) Then inv * p = point(0, √2/2, -√2/2)
    func testTheInverseOfXRotationRotatesInOppositeDirection() {
        let p = Point(x: 0, y: 1, z: 0)
        let half_quarter = Matrix.rotation_x(r: .pi/4)
        let inv = half_quarter.inverse()
        XCTAssertEqual(inv * p, Point(x: 0, y: sqrt(2)/2, z: -sqrt(2)/2))
    }
    
    // Scenario: Rotating a point around the y axis
    // Given p ← point(0, 0, 1) And half_quarter ← rotation_y(π / 4)
    // And full_quarter ← rotation_y(π / 2)
    // Then half_quarter * p = point(√2/2, 0, √2/2)
    // And full_quarter * p = point(1, 0, 0)
    func testRotatingAPointAroundTheYAxis() {
        let p = Point(x: 0, y: 0, z: 1)
        let half_quarter = Matrix.rotation_y(r: .pi/4)
        let full_quarter = Matrix.rotation_y(r: .pi/2)
        XCTAssertEqual(half_quarter * p, Point(x: sqrt(2)/2, y: 0, z: sqrt(2)/2))
        XCTAssertEqual(full_quarter * p, Point(x: 1, y: 0, z: 0))
    }
    
    // Scenario: Rotating a point around the z axis
    // Given p ← point(0, 1, 0) And half_quarter ← rotation_z(π / 4)
    // And full_quarter ← rotation_z(π / 2)
    // Then half_quarter * p = point(-√2/2, √2/2, 0)
    // And full_quarter * p = point(-1, 0, 0)
    func testRotatingAPointAroundTheZAxis() {
        let p = Point(x: 0, y: 1, z: 0)
        let half_quarter = Matrix.rotation_z(r: .pi/4)
        let full_quarter = Matrix.rotation_z(r: .pi/2)
        XCTAssertEqual(half_quarter * p, Point(x: -sqrt(2)/2, y: sqrt(2)/2, z: 0))
        XCTAssertEqual(full_quarter * p, Point(x: -1, y: 0, z: 0))
    }
    
    // Scenario: A shearing transformation moves x in proportion to y
    // Given transform ← shearing(1, 0, 0, 0, 0, 0) And p ← point(2, 3, 4)
    // Then transform * p = point(5, 3, 4)
    func testShearingMovesXInProportionToY() {
        let transform = Matrix.shearing(xy: 1, xz: 0, yx: 0, yz: 0, zx: 0, zy: 0)
        let p = Point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, Point(x: 5, y: 3, z: 4))
    }
    
    // Scenario: A shearing transformation moves x in proportion to z
    // Given transform ← shearing(0, 1, 0, 0, 0, 0) And p ← point(2, 3, 4)
    // Then transform * p = point(6, 3, 4)
    func testShearingMovesXInProportionToZ() {
        let transform = Matrix.shearing(xy: 0, xz: 1, yx: 0, yz: 0, zx: 0, zy: 0)
        let p = Point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, Point(x: 6, y: 3, z: 4))
    }
    
    // Scenario: A shearing transformation moves y in proportion to x
    // Given transform ← shearing(0, 0, 1, 0, 0, 0) And p ← point(2, 3, 4)
    // Then transform * p = point(2, 5, 4)
    func testShearingMovesYInProportionToX() {
        let transform = Matrix.shearing(xy: 0, xz: 0, yx: 1, yz: 0, zx: 0, zy: 0)
        let p = Point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, Point(x: 2, y: 5, z: 4))
    }
    
    // Scenario: A shearing transformation moves y in proportion to z
    // Given transform ← shearing(0, 0, 0, 1, 0, 0) And p ← point(2, 3, 4)
    // Then transform * p = point(2, 7, 4)
    func testShearingMovesYInProportionToZ() {
        let transform = Matrix.shearing(xy: 0, xz: 0, yx: 0, yz: 1, zx: 0, zy: 0)
        let p = Point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, Point(x: 2, y: 7, z: 4))
    }
    
    // Scenario: A shearing transformation moves z in proportion to x
    // Given transform ← shearing(0, 0, 0, 0, 1, 0) And p ← point(2, 3, 4)
    // Then transform * p = point(2, 3, 6)
    func testShearingMovesZInProportionToX() {
        let transform = Matrix.shearing(xy: 0, xz: 0, yx: 0, yz: 0, zx: 1, zy: 0)
        let p = Point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, Point(x: 2, y: 3, z: 6))
    }
    
    // Scenario: A shearing transformation moves z in proportion to y
    // Given transform ← shearing(0, 0, 0, 0, 0, 1) And p ← point(2, 3, 4)
    // Then transform * p = point(2, 3, 7)
    func testShearingMovesZInProportionToY() {
        let transform = Matrix.shearing(xy: 0, xz: 0, yx: 0, yz: 0, zx: 0, zy: 1)
        let p = Point(x: 2, y: 3, z: 4)
        XCTAssertEqual(transform * p, Point(x: 2, y: 3, z: 7))
    }
    
    // Scenario: Individual transformations are applied in sequence
    // Given p ← point(1, 0, 1) And A ← rotation_x(π / 2)
    // And B ← scaling(5, 5, 5) And C ← translation(10, 5, 7)
    // # apply rotation first
    // When p2 ← A * p Then p2 = point(1, -1, 0)
    // # then apply scaling
    // When p3 ← B * p2 Then p3 = point(5, -5, 0)
    // # then apply translation
    // When p4 ← C * p3 Then p4 = point(15, 0, 7)
    func testIndividualTransformationsAreAppliedInSequence() {
        let p = Point(x: 1, y: 0, z: 1)
        let A = Matrix.rotation_x(r: .pi/2)
        let B = Matrix.scaling(x: 5, y: 5, z: 5)
        let C = Matrix.translation(x: 10, y: 5, z: 7)
        let p2 = A * p
        XCTAssertEqual(p2, Point(x: 1, y: -1, z: 0))
        let p3 = B * p2
        XCTAssertEqual(p3, Point(x: 5, y: -5, z: 0))
        let p4 = C * p3
        XCTAssertEqual(p4, Point(x: 15, y: 0, z: 7))
    }
    
    // Scenario: Chained transformations must be applied in reverse order
    // Given p ← point(1, 0, 1) And A ← rotation_x(π / 2)
    // And B ← scaling(5, 5, 5) And C ← translation(10, 5, 7)
    // When T ← C * B * A Then T * p = point(15, 0, 7)
    func testChainedTransformationsMustBeAppliedInReverseOrder() {
        let p = Point(x: 1, y: 0, z: 1)
        let A = Matrix.rotation_x(r: .pi/2)
        let B = Matrix.scaling(x: 5, y: 5, z: 5)
        let C = Matrix.translation(x: 10, y: 5, z: 7)
        let T = C * B * A
        XCTAssertEqual(T * p, Point(x: 15, y: 0, z: 7))
    }

    // Scenario: The transformation matrix for the default orientation
    // Given from ← point(0, 0, 0) And to ← point(0, 0, -1) And up ← vector(0, 1, 0)
    // When t ← view_transform(from, to, up) Then t = identity_matrix
    func testTheTransformationMatrixForTheDefaultOrientation() {
        let from = Point(x: 0, y: 0, z: 0)
        let to = Point(x: 0, y: 0, z: -1)
        let up = Vector(x: 0, y: 1, z: 0)
        
        let t = Matrix.viewTransform(from: from, to: to, up: up)
        
        XCTAssert(t == Matrix.identity())
    }
    
    // Scenario: A view transformation matrix looking in positive z direction
    // Given from ← point(0, 0, 0) And to ← point(0, 0, 1) And up ← vector(0, 1, 0)
    // When t ← view_transform(from, to, up) Then t = scaling(-1, 1, -1)
    func testAViewTransformationMatrixLookingInThePositiveZDirection() {
        let from = Point(x: 0, y: 0, z: 0)
        let to = Point(x: 0, y: 0, z: 1)
        let up = Vector(x: 0, y: 1, z: 0)
        
        let t = Matrix.viewTransform(from: from, to: to, up: up)
        XCTAssert(t == Matrix.scaling(x: -1, y: 1, z: -1))
    }
    
    // Scenario: The view transformation moves the world
    // Given from ← point(0, 0, 8) And to ← point(0, 0, 0) And up ← vector(0, 1, 0)
    // When t ← view_transform(from, to, up) Then t = translation(0, 0, -8)
    func testTheViewTransformationMovesTheWorld() {
        let from = Point(x: 0, y: 0, z: 8)
        let to = Point(x: 0, y: 0, z: 0)
        let up = Vector(x: 0, y: 1, z: 0)
        
        let t = Matrix.viewTransform(from: from, to: to, up: up)
        
        XCTAssert(t == Matrix.translation(x: 0, y: 0, z: -8))
    }
    
    // Scenario: An arbitrary view transformation
    // Given from ← point(1, 3, 2) And to ← point(4, -2, 8) And up ← vector(1, 1, 0)
    // When t ← view_transform(from, to, up) Then t is the following 4x4 matrix:
    // | -0.50709 | 0.50709 | 0.67612  | -2.36643 |
    // | 0.76772  | 0.60609 | 0.12122  | -2.82843 |
    // | -0.35857 | 0.59761 | -0.71714 | 0.00000  |
    // | 0.00000  | 0.00000 | 0.00000  | 1.00000  |
    func testAnArbitraryViewTransform() {
        let from = Point(x: 1, y: 3, z: 2)
        let to = Point(x: 4, y: -2, z: 8)
        let up = Vector(x: 1, y: 1, z: 0)
        
        let t = Matrix.viewTransform(from: from, to: to, up: up)
        
        XCTAssertEqual(t[0,0], -0.50709, accuracy: epsilon)
        XCTAssertEqual(t[0,1], 0.50709, accuracy: epsilon)
        XCTAssertEqual(t[0,2], 0.67612, accuracy: epsilon)
        XCTAssertEqual(t[0,3], -2.36643, accuracy: epsilon)
        XCTAssertEqual(t[1,0], 0.76772, accuracy: epsilon)
        XCTAssertEqual(t[1,1], 0.60609, accuracy: epsilon)
        XCTAssertEqual(t[1,2], 0.12122, accuracy: epsilon)
        XCTAssertEqual(t[1,3], -2.82843, accuracy: epsilon)
        XCTAssertEqual(t[2,0], -0.35857, accuracy: epsilon)
        XCTAssertEqual(t[2,1], 0.59761, accuracy: epsilon)
        XCTAssertEqual(t[2,2], -0.71714, accuracy: epsilon)
        XCTAssertEqual(t[2,3], 0, accuracy: epsilon)
        XCTAssertEqual(t[3,0], 0, accuracy: epsilon)
        XCTAssertEqual(t[3,1], 0, accuracy: epsilon)
        XCTAssertEqual(t[3,2], 0, accuracy: epsilon)
        XCTAssertEqual(t[3,3], 1, accuracy: epsilon)
    }

}
