//
//  Group.swift
//  RayTracerB5
//
//  Created by Stein Alver on 14/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Group: Shape {
    var name: String
    var shapes: [Shape]
    
    override init() {
        self.shapes = [Shape]()
        self.name = "DefaultGroup"
        super.init()
    }
    
    init(name: String) {
        self.name = name
        self.shapes = [Shape]()
        super.init()
    }
    
    func addChild(shape: Shape) {
        self.shapes.append(shape)
        shape.parent = self
    }
    
    func isEmpty() -> Bool {
        return self.shapes.isEmpty
    }
    
    func includes(shape: Shape) -> Bool {
        return self.shapes.contains(shape)
    }
    
    override func local_intersect(ray: Ray) -> Intersections {
        let xsOut = Intersections([])
        for shape in self.shapes {
            let xs = shape.intersect(ray: ray)
            xsOut.list.append(contentsOf: xs.list)
            xsOut.count = xsOut.count + xs.count
        }
        xsOut.list = xsOut.list.sorted()
        return xsOut
    }
    
    override func local_normal_at(p: Point, hit: Intersection) -> Vector {
        print("ERROR : You have called local_normal_at on a Group")
        return Vector(x: 57, y: 57, z: 57)
    }
}
