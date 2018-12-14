//
//  GeneralPattern.swift
//  RayTracerB4
//
//  Created by Stein Alver on 24/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class GeneralPattern {
    
    var transform: Matrix
    
    init() {
        self.transform = Matrix.identity()
    }
    
    func color(at point: Point) -> Color {
        return Color(r: point.x, g: point.y, b: point.z)
    }
    
    func color(at object: Shape, point: Point) -> Color {
        let object_point = object.worldToObject(p: point)
//        let object_point = (object.transform.inverse() * point).asPoint()
        let pattern_point = (self.transform.inverse() * object_point).asPoint()
        return color(at: pattern_point)
    }
}
