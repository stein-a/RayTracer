//
//  CSG.swift
//  RayTracerB5
//
//  Created by Stein Alver on 17/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class CSG : Group {
    
    var operation: String
    var left: Shape
    var right: Shape
    
    init(op: String, left: Shape, right: Shape) {
        self.operation = op
        self.left = left
        self.right = right
        super.init(name: "CSG \(op)")
        left.parent = self
        right.parent = self
    }
}
