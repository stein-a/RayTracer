//
//  Intersections.swift
//  RayTracerB4
//
//  Created by Stein Alver on 16/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Intersections {
    
    var count: Int
    var list: Array<Intersection>
    
    init(_ list: Array<Intersection>) {
        self.list = list
        self.count = list.count
    }
    
    func hit() -> Intersection? {
        var lowest : Float = 999.9
        var low_intersect : Intersection? = nil
        
        for intersect in self.list {
            if intersect.t < 0 {
                // ignore
            } else {
                if intersect.t < lowest {
                    lowest = intersect.t
                    low_intersect = intersect
                }
            }
        }
        return low_intersect
    }
}
