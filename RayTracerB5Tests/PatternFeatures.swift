//
//  PatternFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class PatternFeatures: XCTestCase {

    // Background:
    // Given black ← color(0, 0, 0) And white ← color(1, 1, 1)
    
    // Scenario: Creating a stripe pattern
    // Given pattern ← stripe_pattern(white, black)
    // Then pattern.a = white And pattern.b = black
    func testCreatingAStripePattern() {
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        let pattern = StripePattern(a: white, b: black)
        XCTAssertEqual(pattern.a, white)
        XCTAssertEqual(pattern.b, black)
    }
    
    // Scenario: A stripe pattern is constant in y
    // Given pattern ← stripe_pattern(white, black)
    // Then stripe_at(pattern, point(0, 0, 0)) = white
    // And stripe_at(pattern, point(0, 1, 0)) = white
    // And stripe_at(pattern, point(0, 2, 0)) = white
    func testAStripePatternIsConstantInY() {
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        let pattern = StripePattern(a: white, b: black)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 0)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 1, z: 0)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 2, z: 0)), white)
    }
    
    // Scenario: A stripe pattern is constant in z
    // Given pattern ← stripe_pattern(white, black)
    // Then stripe_at(pattern, point(0, 0, 0)) = white
    // And stripe_at(pattern, point(0, 0, 1)) = white
    // And stripe_at(pattern, point(0, 0, 2)) = white
    func testAStripePatternIsConstantInZ() {
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        let pattern = StripePattern(a: white, b: black)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 0)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 1)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 2)), white)
    }
    
    // Scenario: A stripe pattern alternates in x
    // Given pattern ← stripe_pattern(white, black)
    // Then stripe_at(pattern, point(0, 0, 0)) = white
    // And stripe_at(pattern, point(0.9, 0, 0)) = white
    // And stripe_at(pattern, point(1, 0, 0)) = black
    // And stripe_at(pattern, point(-0.1, 0, 0)) = black
    // And stripe_at(pattern, point(-1, 0, 0)) = black
    // And stripe_at(pattern, point(-1.1, 0, 0)) = white
    func testAStripePatternIsAlternatesInX() {
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        let pattern = StripePattern(a: white, b: black)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 0)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 0.9, y: 0, z: 0)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 1, y: 0, z: 0)), black)
        XCTAssertEqual(pattern.color(at: Point(x: -0.1, y: 0, z: 0)), black)
        XCTAssertEqual(pattern.color(at: Point(x: -1, y: 0, z: 0)), black)
        XCTAssertEqual(pattern.color(at: Point(x: -1.1, y: 0, z: 0)), white)
    }

    // Scenario: Stripes with an object transformation
    // Given object ← sphere() And set_transform(object, scaling(2, 2, 2))
    // And pattern ← stripe_pattern(white, black)
    // When c ← stripe_at_object(pattern, object, point(1.5, 0, 0)) Then c = white
    func testStripesWithAnObjectTransformation() {
        let object = Sphere()
        object.transform = Matrix.scaling(x: 2, y: 2, z: 2)
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        let pattern = StripePattern(a: white, b: black)
        let c = pattern.color(at: object, point: Point(x: 1.5, y: 0, z: 0))
        XCTAssertEqual(c, white)
    }
    
    // Scenario: Stripes with a pattern transformation
    // Given object ← sphere() And pattern ← stripe_pattern(white, black)
    // And set_pattern_transform(pattern, scaling(2, 2, 2))
    // When c ← stripe_at_object(pattern, object, point(1.5, 0, 0)) Then c = white
    func testStripesWithAnPatternTransformation() {
        let object = Sphere()
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        let pattern = StripePattern(a: white, b: black)
        pattern.transform = Matrix.scaling(x: 2, y: 2, z: 2)
        let c = pattern.color(at: object, point: Point(x: 1.5, y: 0, z: 0))
        XCTAssertEqual(c, white)
    }
    
    // Scenario: Stripes with both an object and a pattern transformation
    // Given object ← sphere() And set_transform(object, scaling(2, 2, 2))
    // And pattern ← stripe_pattern(white, black)
    // And set_pattern_transform(pattern, translation(0.5, 0, 0))
    // When c ← stripe_at_object(pattern, object, point(2.5, 0, 0)) Then c = white
    func testStripesWithAnBothObjectAndPatternTransformation() {
        let object = Sphere()
        object.transform = Matrix.scaling(x: 2, y: 2, z: 2)
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        let pattern = StripePattern(a: white, b: black)
        pattern.transform = Matrix.translation(x: 0.5, y: 0, z: 0)
        let c = pattern.color(at: object, point: Point(x: 2.5, y: 0, z: 0))
        XCTAssertEqual(c, white)
    }
    
    // Scenario: A pattern with an object transformation
    // Given shape ← sphere() And set_transform(shape, scaling(2, 2, 2))
    // And pattern ← test_pattern()
    // When c ← pattern_at_shape(pattern, shape, point(2, 3, 4))
    // Then c = color(1, 1.5, 2)
    func testAPatternWithAnObjectTransformation() {
        let shape = Sphere()
        shape.transform = Matrix.scaling(x: 2, y: 2, z: 2)
        let pattern = GeneralPattern()
        let c = pattern.color(at: shape, point: Point(x: 2, y: 3, z: 4))
        XCTAssertEqual(c, Color(r: 1, g: 1.5, b: 2))
    }
    
    // Scenario: A pattern with a pattern transformation
    // Given shape ← sphere() And pattern ← test_pattern()
    // And set_pattern_transform(pattern, scaling(2, 2, 2))
    // When c ← pattern_at_shape(pattern, shape, point(2, 3, 4))
    // Then c = color(1, 1.5, 2)
    func testAPatternWithAPatternTransformation() {
        let shape = Sphere()
        let pattern = GeneralPattern()
        pattern.transform = Matrix.scaling(x: 2, y: 2, z: 2)
        let c = pattern.color(at: shape, point: Point(x: 2, y: 3, z: 4))
        XCTAssertEqual(c, Color(r: 1, g: 1.5, b: 2))
    }
    
    // Scenario: A pattern with both an object and a pattern transformation
    // Given shape ← sphere() And set_transform(shape, scaling(2, 2, 2))
    // And pattern ← test_pattern()
    // And set_pattern_transform(pattern, translation(0.5, 1, 1.5))
    // When c ← pattern_at_shape(pattern, shape, point(2.5, 3, 3.5))
    // Then c = color(0.75, 0.5, 0.25)
    func testAPatternWithBothObjectAndPatternTransformation() {
        let shape = Sphere()
        shape.transform = Matrix.scaling(x: 2, y: 2, z: 2)
        let pattern = GeneralPattern()
        pattern.transform = Matrix.translation(x: 0.5, y: 1, z: 1.5)
        let c = pattern.color(at: shape, point: Point(x: 2.5, y: 3, z: 3.5))
        XCTAssertEqual(c, Color(r: 0.75, g: 0.5, b: 0.25))
    }
    
    // Scenario: A gradient linearly interpolates between colors
    // Given pattern ← gradient_pattern(white, black)
    // Then pattern_at(pattern, point(0, 0, 0)) = white
    // And pattern_at(pattern, point(0.25, 0, 0)) = color(0.75, 0.75, 0.75)
    // And pattern_at(pattern, point(0.5, 0, 0)) = color(0.5, 0.5, 0.5)
    // And pattern_at(pattern, point(0.75, 0, 0)) = color(0.25, 0.25, 0.25)
    func testAGradientLinearlyInterpolatesBetweenColors() {
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        let pattern = GradientPattern(a: white, b: black)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 0)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 0.25, y: 0, z: 0)),
                       Color(r: 0.75, g: 0.75, b: 0.75))
        XCTAssertEqual(pattern.color(at: Point(x: 0.5, y: 0, z: 0)),
                       Color(r: 0.5, g: 0.5, b: 0.5))
        XCTAssertEqual(pattern.color(at: Point(x: 0.75, y: 0, z: 0)),
                       Color(r: 0.25, g: 0.25, b: 0.25))
    }
    
    // Scenario: A ring should extend in both x and z
    // Given pattern ← ring_pattern(white, black)
    // Then pattern_at(pattern, point(0, 0, 0)) = white
    // And pattern_at(pattern, point(1, 0, 0)) = black
    // And pattern_at(pattern, point(0, 0, 1)) = black
    // # 0.708 = just slightly more than √2/2
    // And pattern_at(pattern, point(0.708, 0, 0.708)) = black
    func testARingShouldExtendInBothXAndZ() {
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        let pattern = RingPattern(a: white, b: black)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 0)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 1, y: 0, z: 0)), black)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 1)), black)
        XCTAssertEqual(pattern.color(at: Point(x: 0.708, y: 0, z: 0.708)), black)
    }
    
    // Scenario: Checkers should repeat in x
    // Given pattern ← checkers_pattern(white, black)
    // Then pattern_at(pattern, point(0, 0, 0)) = white
    // And pattern_at(pattern, point(0.99, 0, 0)) = white
    // And pattern_at(pattern, point(1.01, 0, 0)) = black
    func testCheckersShouldRepeatInX() {
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        let pattern = ThreeDCheckerPattern(a: white, b: black)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 0)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 0.99, y: 0, z: 0)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 1.01, y: 0, z: 0)), black)
    }
    
    // Scenario: Checkers should repeat in y
    // Given pattern ← checkers_pattern(white, black)
    // Then pattern_at(pattern, point(0, 0, 0)) = white
    // And pattern_at(pattern, point(0, 0.99, 0)) = white
    // And pattern_at(pattern, point(0, 1.01, 0)) = black
    func testCheckersShouldRepeatInY() {
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        let pattern = ThreeDCheckerPattern(a: white, b: black)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 0)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0.99, z: 0)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 1.01, z: 0)), black)
    }
    
    // Scenario: Checkers should repeat in z
    // Given pattern ← checkers_pattern(white, black)
    // Then pattern_at(pattern, point(0, 0, 0)) = white
    // And pattern_at(pattern, point(0, 0, 0.99)) = white
    // And pattern_at(pattern, point(0, 0, 1.01)) = black
    func testCheckersShouldRepeatInZ() {
        let black = Color(r: 0, g: 0, b: 0)
        let white = Color(r: 1, g: 1, b: 1)
        let pattern = ThreeDCheckerPattern(a: white, b: black)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 0)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 0.99)), white)
        XCTAssertEqual(pattern.color(at: Point(x: 0, y: 0, z: 1.01)), black)
    }

}
