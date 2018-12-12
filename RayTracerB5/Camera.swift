//
//  Camera.swift
//  RayTracerB4
//
//  Created by Stein Alver on 19/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Camera {
    
    var hsize : Float
    var vsize : Float
    var field_of_view : Float
    var pixel_size : Float
    var half_width : Float
    var half_height : Float
    
    var transform : Matrix
    
    init(hsize: Float, vsize: Float, field_of_view: Float) {
        self.hsize = hsize
        self.vsize = vsize
        self.field_of_view = field_of_view
        
        let half_view = tanf(field_of_view/Float(2))
        let aspect = hsize / vsize
        
        if aspect >= 1 {
            half_width = half_view
            half_height = half_view / aspect
        } else {
            half_width = half_view * aspect
            half_height = half_view
        }
        self.pixel_size = (half_width * 2) / hsize
        self.transform = Matrix.identity()
    }
    
    func ray_for_pixel(px: Int, py: Int) -> Ray {
        let xoffset = (Float(px) + 0.5) * self.pixel_size
        let yoffset = (Float(py) + 0.5) * self.pixel_size
        
        let world_x = self.half_width - xoffset
        let world_y = self.half_height - yoffset
        
        let pixel = self.transform.inverse() * Point(x: world_x, y: world_y, z: -1)
        let origin = (self.transform.inverse() * Point(x: 0, y: 0, z: 0)).asPoint()
        let direction = (pixel - origin).asVector()
        
        return Ray(orig: origin, dir: direction.normalize())
    }
    
    func render(world: World) -> Canvas {
        let image = Canvas(w: Int(self.hsize), h: Int(self.vsize))
        
        for y in 0..<Int(self.vsize) {
            for x in 0..<Int(self.hsize) {
//                print("y = \(y) - x = \(x)")
                let ray = self.ray_for_pixel(px: x, py: y)
                let color = world.colorAt(ray: ray)
                image.write_pixel(x: x, y: y, color: color)
            }
        }
        return image
    }
    
    func render(world: World, externalCanvas: Canvas) -> Int {

        for y in 0..<Int(self.vsize) {
            for x in 0..<Int(self.hsize) {
                //                print("y = \(y) - x = \(x)")
                let ray = self.ray_for_pixel(px: x, py: y)
                let color = world.colorAt(ray: ray)
                externalCanvas.write_pixel(x: x, y: y, color: color)
            }
        }
        return Int(self.vsize * self.hsize)
    }
}

