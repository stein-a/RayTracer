//
//  RingPattern.swift
//  RayTracerB4
//
//  Created by Stein Alver on 24/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class RingPattern: GeneralPattern {
 
    var a: Color
    var b: Color
    
    init(a: Color, b: Color) {
        self.a = a
        self.b = b
        super.init()
    }
    
    override func color(at point: Point) -> Color {
        let i = Int(floor(sqrt((point.x * point.x) + (point.z * point.z))))
        
        if ( i % 2 == 0) {
            return self.a
        } else {
            return self.b
        }
    }

}
