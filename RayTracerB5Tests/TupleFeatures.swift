//
//  TupleFeatures.swift
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class TupleFeatures: XCTestCase {

    // Scenario: A tuple with w=1.0 is a point
    // Given a ← tuple(4.3, -4.2, 3.1, 1.0)
    // Then a.x = 4.3 And a.y = -4.2 And a.z = 3.1 And a.w = 1.0
    // And a is a point And a is not a vector
    func testATupleWithW1IsAPoint() {
        let a = Tuple(x: 4.3, y: -4.2, z: 3.1, w: 1.0)
        XCTAssertEqual(a.x, 4.3)
        XCTAssertEqual(a.y, -4.2)
        XCTAssertEqual(a.z, 3.1)
        XCTAssertEqual(a.w, 1.0)
        XCTAssertTrue(a.isPoint())
        XCTAssertFalse(a.isVector())
    }
    
    // Scenario: A tuple with w=0 is a vector
    // Given a ← tuple(4.3, -4.2, 3.1, 0.0)
    // Then a.x = 4.3 And a.y = -4.2 And a.z = 3.1 And a.w = 0.0
    // And a is not a point And a is a vector
    func testATupleWithW0IsAVector() {
        let a = Tuple(x: 4.3, y: -4.2, z: 3.1, w: 0.0)
        XCTAssertEqual(a.x, 4.3)
        XCTAssertEqual(a.y, -4.2)
        XCTAssertEqual(a.z, 3.1)
        XCTAssertEqual(a.w, 0.0)
        XCTAssertFalse(a.isPoint())
        XCTAssertTrue(a.isVector())
    }
    
    // Scenario: point() creates tuples with w=1
    // Given p ← point(4, -4, 3)
    // Then p = tuple(4, -4, 3, 1)
    func testPointCreatesTupleWithW1() {
        let p = Point(x: 4, y: -4, z: 3)
        XCTAssertTrue(p == Tuple(x: 4, y: -4, z: 3, w: 1))
    }
    
    // Scenario: vector() creates tuples with w=0
    // Given v ← vector(4, -4, 3)
    // Then v = tuple(4, -4, 3, 0)
    func testVectorCreatesTupleWithW0() {
        let v = Vector(x: 4, y: -4, z: 3)
        XCTAssertTrue(v == Tuple(x: 4, y: -4, z: 3, w: 0))
    }

    // Scenario: Adding two tuples
    // Given a1 ← tuple(3, -2, 5, 1)
    // And a2 ← tuple(-2, 3, 1, 0)
    // Then a1 + a2 = tuple(1, 1, 6, 1)
    func testAddingTwoTuples() {
        let a1 = Tuple(x: 3, y: -2, z: 5, w: 1)
        let a2 = Tuple(x: -2, y: 3, z: 1, w: 0)
        XCTAssertEqual(a1 + a2, Tuple(x: 1, y: 1, z: 6, w: 1))
    }
    
    // Scenario: Subtracting two points
    // Given p1 ← point(3, 2, 1)
    // And p2 ← point(5, 6, 7)
    // Then p1 - p2 = vector(-2, -4, -6)
    func testSubtractingTwoPoints() {
        let p1 = Point(x: 3, y: 2, z: 1)
        let p2 = Point(x: 5, y: 6, z: 7)
        XCTAssertEqual(p1 - p2, Vector(x: -2, y: -4, z: -6))
    }
    
    // Scenario: Subtracting a vector from a point
    // Given p ← point(3, 2, 1)
    // And v ← vector(5, 6, 7)
    // Then p - v = point(-2, -4, -6)
    func testSubtractingAVectorFromAPoint() {
        let p = Point(x: 3, y: 2, z: 1)
        let v = Vector(x: 5, y: 6, z: 7)
        XCTAssertEqual(p - v, Point(x: -2, y: -4, z: -6))
    }
    
    // Scenario: Subtracting two vectors
    // Given v1 ← vector(3, 2, 1)
    // And v2 ← vector(5, 6, 7)
    // Then v1 - v2 = vector(-2, -4, -6)
    func testSubtractingTwoVectors() {
        let v1 = Vector(x: 3, y: 2, z: 1)
        let v2 = Vector(x: 5, y: 6, z: 7)
        XCTAssertEqual(v1 - v2, Vector(x: -2, y: -4, z: -6))
    }
    
    // Scenario: Subtracting a vector from the zero vector
    // Given zero ← vector(0, 0, 0)
    // And v ← vector(1, -2, 3)
    // Then zero - v = vector(-1, 2, -3)
    func testSubtractingAVectorFromTheZeroVector() {
        let zero = Vector(x: 0, y: 0, z: 0)
        let v = Vector(x: 1, y: -2, z: 3)
        XCTAssertEqual(zero - v, Vector(x: -1, y: 2, z: -3))
    }

    // Scenario: Negating a tuple
    // Given a ← tuple(1, -2, 3, -4)
    // Then -a = tuple(-1, 2, -3, 4)
    func testNegatingATuple() {
        let a = Tuple(x: 1, y: -2, z: 3, w: -4)
        XCTAssertEqual(-a, Tuple(x: -1, y: 2, z: -3, w: 4))
    }
    
    // Scenario: Multiplying a tuple by a scalar
    // Given a ← tuple(1, -2, 3, -4)
    // Then a * 3.5 = tuple(3.5, -7, 10.5, -14)
    func testMultiplyingATupleByAScalar() {
        let a = Tuple(x: 1, y: -2, z: 3, w: -4)
        XCTAssertEqual(a * 3.5, Tuple(x: 3.5, y: -7, z: 10.5, w: -14))
    }
    
    // Scenario: Multiplying a tuple by a fraction
    // Given a ← tuple(1, -2, 3, -4)
    // Then a * 0.5 = tuple(0.5, -1, 1.5, -2)
    func testMultiplyingATupleByAFraction() {
        let a = Tuple(x: 1, y: -2, z: 3, w: -4)
        XCTAssertEqual(a * 0.5, Tuple(x: 0.5, y: -1, z: 1.5, w: -2))
    }
    
    // Scenario: Dividing a tuple by a scalar
    // Given a ← tuple(1, -2, 3, -4)
    // Then a / 2 = tuple(0.5, -1, 1.5, -2)
    func testDividingATupleByAScalar() {
        let a = Tuple(x: 1, y: -2, z: 3, w: -4)
        XCTAssertEqual(a / 2, Tuple(x: 0.5, y: -1, z: 1.5, w: -2))
    }
    
    // Scenario: Computing the magnitude of vector(1, 0, 0)
    // Given v ← vector(1, 0, 0) Then magnitude(v) = 1
    func testComputingTheMagnitudeOfVector100() {
        let v = Vector(x: 1, y: 0, z: 0)
        XCTAssertEqual(v.magnitude(), 1)
    }
    
    // Scenario: Computing the magnitude of vector(0, 1, 0)
    // Given v ← vector(0, 1, 0) Then magnitude(v) = 1
    func testComputingTheMagnitudeOfVector010() {
        let v = Vector(x: 0, y: 1, z: 0)
        XCTAssertEqual(v.magnitude(), 1)
    }
    
    // Scenario: Computing the magnitude of vector(0, 0, 1)
    // Given v ← vector(0, 0, 1) Then magnitude(v) = 1
    func testComputingTheMagnitudeOfVector001() {
        let v = Vector(x: 0, y: 0, z: 1)
        XCTAssertEqual(v.magnitude(), 1)
    }
    
    // Scenario: Computing the magnitude of vector(1, 2, 3)
    // Given v ← vector(1, 2, 3) Then magnitude(v) = √14
    func testComputingTheMagnitudeOfVector123() {
        let v = Vector(x: 1, y: 2, z: 3)
        XCTAssertEqual(v.magnitude(), sqrtf(14))
    }
    
    // Scenario: Computing the magnitude of vector(-1, -2, -3)
    // Given v ← vector(-1, -2, -3) Then magnitude(v) = √14
    func testComputingTheMagnitudeOfVectorMinus123() {
        let v = Vector(x: -1, y: -2, z: -3)
        XCTAssertEqual(v.magnitude(), sqrtf(14))
    }
    
    // Scenario: Normalizing vector(4, 0, 0) gives (1, 0, 0)
    // Given v ← vector(4, 0, 0) Then normalize(v) = vector(1, 0, 0)
    func testNormalizingVector400GivesVector100() {
        let v = Vector(x: 4, y: 0, z: 0)
        XCTAssertEqual(v.normalize(), Vector(x: 1, y: 0, z: 0))
    }
    
    // Scenario: Normalizing vector(1, 2, 3)
    // Given v ← vector(1, 2, 3)      # vector(1/√14, 2/√14, 3/√14)
    // Then normalize(v) = approximately vector(0.26726, 0.53452, 0.80178)
    func testNormalizingVector123() {
        let v = Vector(x: 1, y: 2, z: 3)
        XCTAssertEqual(v.normalize().x, 0.26726, accuracy: 0.00001)
        XCTAssertEqual(v.normalize().y, 0.53452, accuracy: 0.00001)
        XCTAssertEqual(v.normalize().z, 0.80178, accuracy: 0.00001)
    }
    
    // Scenario: The magnitude of a normalized vector
    // Given v ← vector(1, 2, 3)
    // When norm ← normalize(v) Then magnitude(norm) = 1
    func testTheMagnitudeOfANormalizedVector() {
        let v = Vector(x: 1, y: 2, z: 3)
        let norm = v.normalize()
        XCTAssertEqual(norm.magnitude(), 1, accuracy: 0.00001)
    }
    
    // Scenario: The dot product of two tuples
    // Given a ← vector(1, 2, 3) And b ← vector(2, 3, 4)
    // Then dot(a, b) = 20
    func testTheDotProductOfTwoTuples() {
        let a = Vector(x: 1, y: 2, z: 3)
        let b = Vector(x: 2, y: 3, z: 4)
        XCTAssertEqual(a.dot(b), 20, accuracy: 0.00001)
    }
    
    // Scenario: The cross product of two vectors
    // Given a ← vector(1, 2, 3) And b ← vector(2, 3, 4)
    // Then cross(a, b) = vector(-1, 2, -1)
    // And cross(b, a) = vector(1, -2, 1)
    func testTheCrossProductOfTwoVectors() {
        let a = Vector(x: 1, y: 2, z: 3)
        let b = Vector(x: 2, y: 3, z: 4)
        XCTAssertEqual(a.cross(b), Vector(x: -1, y: 2, z: -1))
        XCTAssertEqual(b.cross(a), Vector(x: 1, y: -2, z: 1))
    }

    // Scenario: Colors are (red, green, blue) tuples
    // Given c ← color(-0.5, 0.4, 1.7)
    // Then c.red = -0.5
    // And c.green = 0.4
    // And c.blue = 1.7
    func testColorsAreRedGreenBlue() {
        let c = Color(r: -0.5, g: 0.4, b: 1.7)
        XCTAssert(c.red == -0.5)
        XCTAssert(c.green == 0.4)
        XCTAssert(c.blue == 1.7)
    }
    
    // Scenario: Adding colors
    // Given c1 ← color(0.9, 0.6, 0.75)
    // And c2 ← color(0.7, 0.1, 0.25)
    // Then c1 + c2 = color(1.6, 0.7, 1.0)
    func testAddingColors() {
        let c1 = Color(r: 0.9, g: 0.6, b: 0.75)
        let c2 = Color(r: 0.7, g: 0.1, b: 0.25)
        let sum = c1 + c2
        XCTAssertEqual(sum.red, 1.6, accuracy: 0.00001)
        XCTAssertEqual(sum.green, 0.7, accuracy: 0.00001)
        XCTAssertEqual(sum.blue, 1.0, accuracy: 0.00001)
    }
    
    // Scenario: Subtracting colors
    // Given c1 ← color(0.9, 0.6, 0.75)
    // And c2 ← color(0.7, 0.1, 0.25)
    // Then c1 - c2 = color(0.2, 0.5, 0.5)
    func testSubtractColors() {
        let c1 = Color(r: 0.9, g: 0.6, b: 0.75)
        let c2 = Color(r: 0.7, g: 0.1, b: 0.25)
        let diff = c1 - c2
        XCTAssertEqual(diff.red, 0.2, accuracy: 0.00001)
        XCTAssertEqual(diff.green, 0.5, accuracy: 0.00001)
        XCTAssertEqual(diff.blue, 0.5, accuracy: 0.00001)
    }
    
    // Scenario: Multiplying a color by a scalar
    // Given c ← color(0.2, 0.3, 0.4)
    // Then c * 2 = color(0.4, 0.6, 0.8)
    func testMultiplyColorWithScalar() {
        let c = Color(r: 0.2, g: 0.3, b: 0.4)
        let c2 = c * 2
        XCTAssertEqual(c2.red, 0.4, accuracy: 0.00001)
        XCTAssertEqual(c2.green, 0.6, accuracy: 0.00001)
        XCTAssertEqual(c2.blue, 0.8, accuracy: 0.00001)
    }
    
    // Scenario: Multiplying colors
    // Given c1 ← color(1, 0.2, 0.4)
    // And c2 ← color(0.9, 1, 0.1)
    // Then c1 * c2 = color(0.9, 0.2, 0.04)
    func testMultiplyColors() {
        let c1 = Color(r: 1, g: 0.2, b: 0.4)
        let c2 = Color(r: 0.9, g: 1, b: 0.1)
        let product = c1 * c2
        XCTAssertEqual(product.red, 0.9, accuracy: 0.00001)
        XCTAssertEqual(product.green, 0.2, accuracy: 0.00001)
        XCTAssertEqual(product.blue, 0.04, accuracy: 0.00001)
    }

    // Scenario:Reflecting a vector approaching at 45 degrees
    // Given v ← vector(1, -1, 0) And n ← vector(0, 1, 0)
    // When r ← reflect(v, n) Then r = vector(1, 1, 0)
    func testReflectingAVectorApproachingAt45Degrees() {
        let v = Vector(x: 1, y: -1, z: 0)
        let n = Vector(x: 0, y: 1, z: 0)
        let r = v.reflect(normal: n)
        XCTAssertEqual(r, Vector(x: 1, y: 1, z: 0))
    }
    
    // Scenario: Reflecting a vector off a slanted surface
    // Given v ← vector(0, -1, 0) And n ← vector(√2/2, √2/2, 0)
    // When r ← reflect(v, n) Then r = vector(1, 0, 0)
    func testReflectingAVectorOffASlantedSurface() {
        let v = Vector(x: 0, y: -1, z: 0)
        let n = Vector(x: sqrtf(2)/2, y: sqrtf(2)/2, z: 0)
        let r = v.reflect(normal: n)
        XCTAssertEqual(r, Vector(x: 1, y: 0, z: 0))
    }

}
