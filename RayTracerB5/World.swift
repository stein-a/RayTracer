//
//  World.swift
//  RayTracerB4
//
//  Created by Stein Alver on 19/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class World {
    
    var objects: [Shape]
    var light: PointLight?
    
    init() {
        self.objects = [Shape]()
        self.light = nil
    }
    
    func intersect(with ray: Ray) -> Intersections {
        let intersects = Intersections([])
        
        for shape in self.objects {
            let xs = shape.intersect(ray: ray)
            intersects.list.append(contentsOf: xs.list)
            intersects.count = intersects.count + xs.count
        }
        intersects.list = intersects.list.sorted()
        
        return intersects
    }
    
    func shade(hit: IntersectionComp, remaining: Int = 5) -> Color {
        let shape = hit.object
        let shadowed = self.isShadowed(p: hit.overPoint)
        let surface =  shape.material.lighting(light: self.light!, object: shape, point: hit.overPoint, eyev: hit.eyeVector, normalv: hit.normal, in_shadow: shadowed)
        let reflected = self.reflectedColor(comps: hit, remaining: remaining)
        let refracted = self.refractedColor(comps: hit, remaining: remaining)
        
        let material = hit.object.material
        if material.reflectivity > 0 &&
            material.transparency > 0 {
            let reflectance = hit.schlick()
            return surface + (reflected * reflectance)
                    + (refracted * (1 - reflectance))
        } else {
            return surface + reflected + refracted
        }
    }
    
    func colorAt(ray: Ray, remaining: Int = 5) -> Color {
        var color : Color
        
        let xs = self.intersect(with: ray)
        if let hit = xs.hit() {
            let comps = hit.prepare(with: ray, xs: xs)
            color = self.shade(hit: comps, remaining: remaining)
        } else {
            color = Color(r: 0, g: 0, b: 0)
        }
        return color
    }
    
    func isShadowed(p: Point) -> Bool {
        let v = self.light!.position - p
        let distance = v.magnitude()
        let direction = v.normalize()
        
        let r = Ray(orig: p, dir: direction)
        let xs = self.intersect(with: r)

        if let hit = xs.hit() {
            if hit.t < distance {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func reflectedColor(comps: IntersectionComp, remaining: Int = 5) -> Color {
        if remaining < 1 {
            return Color(r: 0, g: 0, b: 0)
        }
        
        if comps.object.material.reflectivity == 0 {
            return Color(r: 0, g: 0, b: 0)
        }
        
        let reflect_ray = Ray(orig: comps.overPoint, dir: comps.reflectv)
        let color = self.colorAt(ray: reflect_ray, remaining: remaining - 1)
        return color * comps.object.material.reflectivity
    }
    
    func refractedColor(comps: IntersectionComp, remaining: Int = 5) -> Color {
        
        if remaining < 1 {
            return Color(r: 0, g: 0, b: 0)
        }
        
        if comps.object.material.transparency == 0 {
            return Color(r: 0, g: 0, b: 0)
        }
        
        // Find the ratio of first index of refraction to the second.
        // (Yup, this is inverted from the definition of Snell's Law.)
        let n_ratio = comps.n1 / comps.n2
        
        // cos(theta_i) is the same as the dot product of the two vectors
        let cos_i =  comps.eyeVector.dot(comps.normal)
        
        // Find sin(theta_t)^2 via trigonometric identity
        let sin2_t = (n_ratio * n_ratio) * (1 - (cos_i * cos_i))
        
        // If sin2_t is greater than 1, then you’ve got some
        // total internal reflection going on.
        if sin2_t > 1 {
            return Color(r: 0, g: 0, b: 0)
        }
        
        // In all other cases we should spawn a secondary ray in
        // the correct direction, and return it’s color.
        
        // Find cos(theta_t) via trigonometric identity
        let cos_t = sqrtf(1.0 - sin2_t)
        
        // Compute the direction of the refracted ray
        let direction = (comps.normal * (n_ratio * cos_i - cos_t) -
                        comps.eyeVector * n_ratio).asVector()
        
        // Create the refracted ray
        let refract_ray = Ray(orig: comps.underPoint, dir: direction)
        
        // Find the color of the refracted ray, making sure to multiply
        // by the transparency value to account for any opacity
        return self.colorAt(ray: refract_ray, remaining: remaining - 1)
                    * comps.object.material.transparency
    }

    class func defaultWorld() -> World {
        let w = World()
        
        let light = PointLight(pos: Point(x: -10, y: 10, z: -10), int: Color(r: 1, g: 1, b: 1))
        w.light = light
        
        let s1 = Sphere()
        let m1 = Material()
        m1.color = Color(r: 0.8, g: 1.0, b: 0.6)
        m1.diffuse = 0.7
        m1.specular = 0.2
        s1.material = m1
        w.objects.append(s1)
        
        let s2 = Sphere()
        s2.transform = Matrix.scaling(x: 0.5, y: 0.5, z: 0.5)
        w.objects.append(s2)
        
        return w
    }

}
