//
//  Shape.swift
//  RayTracerB4
//
//  Created by Stein Alver on 22/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Shape: CustomStringConvertible, Equatable {

    var transpInvTransform: Matrix4
    var invTransform: Matrix4
    var transform: Matrix4 {
        didSet {
            invTransform = transform.inverse()
            transpInvTransform = invTransform^
        }
    }
    var material: Material
    var parent: Group?
    
    var description: String {
        return "transform: \(transform), material: \(material)"
    }
    
    static func == (lhs: Shape, rhs: Shape) -> Bool {
        return (lhs.transform == rhs.transform) && (lhs.material == rhs.material)
    }

    init() {
        self.transform = Matrix4.identity()
        self.material = Material()
        self.invTransform = Matrix4.identity()
        self.transpInvTransform = Matrix4.identity()
    }
    
    func intersect(ray: Ray) -> Intersections {
        let local_ray = ray.transform(m: self.invTransform)
        return local_intersect(ray: local_ray)
    }
    
    func normalAt(p: Point, hit: Intersection) -> Vector {
        let local_point = self.worldToObject(p: p)
        let local_normal = self.local_normal_at(p: local_point, hit: hit)
        return normalToWorld(normal: local_normal)
    }
    
    func worldToObject(p: Point) -> Point {
        var pOut = p
        if let parent = self.parent {
            pOut = parent.worldToObject(p: p)
        }
        return (self.invTransform * pOut).asPoint()
    }
    
    func normalToWorld(normal: Vector) -> Vector {
        var normOut = (self.transpInvTransform * normal).asVector()
        normOut = normOut.normalize()
        
        if let parent = self.parent {
            normOut = parent.normalToWorld(normal: normOut)
        }
        return normOut
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
    
    func local_normal_at(p: Point, hit: Intersection) -> Vector {
        return Vector(x: p.x, y: p.y, z: p.z)
    }
}
