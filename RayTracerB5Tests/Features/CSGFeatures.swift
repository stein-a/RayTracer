//
//  CSGFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 17/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class CSGFeatures: XCTestCase {

    // Scenario: CSG is created with an operation and two shapes
    // Given s1 ← sphere() And s2 ← cube()
    // When c ← csg("union", s1, s2)
    // Then c.operation = "union" And c.left = s1 And c.right = s2
    // And s1.parent = c And s2.parent = c
    func testCSGIsCreatedWithAnOperationAndTwoShapes() {
        let s1 = Sphere()
        let s2 = Cube()
        let c = CSG(op: "union", left: s1, right: s2)
        XCTAssertEqual(c.operation, "union")
        XCTAssertEqual(c.left, s1)
        XCTAssertEqual(c.right, s2)
        XCTAssertEqual(s1.parent, c)
        XCTAssertEqual(s2.parent, c)
    }
}
