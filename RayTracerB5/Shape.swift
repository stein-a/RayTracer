//
//  Shape.swift
//  RayTracerB4
//
//  Created by Stein Alver on 22/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Shape: CustomStringConvertible, Equatable {

    var transform: Matrix
    var material: Material
    
    var description: String {
        return "transform: \(transform), material: \(material)"
    }
    
    static func == (lhs: Shape, rhs: Shape) -> Bool {
        return (lhs.transform == rhs.transform) && (lhs.material == rhs.material)
    }

    init() {
        self.transform = Matrix.identity()
        self.material = Material()
    }
    
    func intersect(ray: Ray) -> Intersections {
        let local_ray = ray.transform(m: self.transform.inverse())
        return local_intersect(ray: local_ray)
    }
    
    func normalAt(p: Point) -> Vector {
        let local_point = (self.transform.inverse() * p).asPoint()
        let local_normal = self.local_normal_at(p: local_point)
        let world_normal = (self.transform.inverse()^ * local_normal).asVector()
        return world_normal.normalize()
    }
    
    // For testing
    
    class func testShape() -> Shape {
        return Shape()
    }

    var savedRay: Ray?
    
    func local_intersect(ray: Ray) -> Intersections {
        self.savedRay = ray
        return Intersections([])
    }
    
    func local_normal_at(p: Point) -> Vector {
        return Vector(x: p.x, y: p.y, z: p.z)
    }
}
