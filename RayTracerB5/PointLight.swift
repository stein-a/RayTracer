//
//  PointLight.swift
//  RayTracerB4
//
//  Created by Stein Alver on 19/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class PointLight: Equatable {
    var position: Point
    var intensity: Color
    
    init(pos: Point, int: Color) {
        self.position = pos
        self.intensity = int
    }

    static func == (lhs: PointLight, rhs: PointLight) -> Bool {
        return (lhs.position == rhs.position &&
            lhs.intensity == rhs.intensity)
    }    
}
