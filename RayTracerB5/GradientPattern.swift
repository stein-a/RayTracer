//
//  GradientPattern.swift
//  RayTracerB4
//
//  Created by Stein Alver on 24/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class GradientPattern: GeneralPattern {
    
    var a: Color
    var b: Color
    
    init(a: Color, b: Color) {
        self.a = a
        self.b = b
        super.init()
    }
    
    override func color(at point: Point) -> Color {
        let distance = self.b - self.a
        let fraction = point.x - floor(point.x)
        return self.a + distance * fraction
    }
}
