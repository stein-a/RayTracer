//
//  Intersection.swift
//  RayTracerB4
//
//  Created by Stein Alver on 16/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Intersection: Equatable, Comparable, CustomStringConvertible {
    static func < (lhs: Intersection, rhs: Intersection) -> Bool {
        return (lhs.t < rhs.t)
    }
    
    static func == (lhs: Intersection, rhs: Intersection) -> Bool {
        return (lhs.t == rhs.t) && (lhs.object == rhs.object)
    }
    
    
    var t: Double
    var object: Shape
    var u: Double
    var v: Double
    
    var description: String {
        return "t=\(t), object=\(object)"
    }
    
    init(t: Double, object: Shape) {
        self.t = t
        self.object = object
        self.u = 0
        self.v = 0
    }
    
    func prepare(with ray: Ray, xs: Intersections? = nil) -> IntersectionComp {
        let comp = IntersectionComp(t: self.t, object: self.object)
        
        comp.point = ray.position(time: self.t)
        comp.normal = comp.object.normalAt(p: comp.point, hit: self)
        
        comp.eyeVector = -ray.direction
        
        if (comp.normal.dot(comp.eyeVector)) < 0 {
            comp.isInside = true
            comp.normal = -comp.normal
        } else {
            comp.isInside = false
        }

        comp.overPoint = (comp.point + comp.normal * 0.000099).asPoint()
        comp.underPoint = (comp.point - comp.normal * 0.000099).asPoint()

        comp.reflectv = ray.direction.reflect(normal: comp.normal)
        
        if let intersections = xs?.list {
            var containers: [Shape] = [Shape]()
            
            for i in intersections {
                if i == self {
                    if containers.count == 0 {
                        comp.n1 = 1.0
                    } else {
                        comp.n1 = containers.last!.material.refractiveIndex
                    }
                }
                
                if containers.contains(i.object) {
                    containers = containers.filter() { $0 != i.object }
               } else {
                    containers.append(i.object)
                }
                
                if i == self {
                    if containers.count == 0 {
                        comp.n2 = 1.0
                    } else {
                        comp.n2 = containers.last!.material.refractiveIndex
                    }
                    break
                }
            }
        }

        return comp
    }
}
