//
//  LightFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class LightFeatures: XCTestCase {

    // Scenario: A point light has a position and intensity
    // Given intensity ← color(1, 1, 1) And position ← point(0, 0, 0)
    // When light ← point_light(position, intensity)
    // Then light.position = position And light.intensity = intensity
    func testAPointLightHasPositionAndIntesity() {
        let intensity = Color(r: 1, g: 1, b: 1)
        let position = Point(x: 0, y: 0, z: 0)
        let light = PointLight(pos: position, int: intensity)
        XCTAssertEqual(light.position, position)
        XCTAssertEqual(light.intensity, intensity)
    }

}
