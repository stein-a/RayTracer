//
//  Camera.swift
//  RayTracerB4
//
//  Created by Stein Alver on 19/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Camera {
    
    var hsize : Double
    var vsize : Double
    var field_of_view : Double
    var pixel_size : Double
    var half_width : Double
    var half_height : Double
    
    var invTransform : Matrix4
    var transform : Matrix4 {
        didSet {
            invTransform = transform.inverse()
        }
    }
    
    init(hsize: Double, vsize: Double, field_of_view: Double) {
        self.hsize = hsize
        self.vsize = vsize
        self.field_of_view = field_of_view
        
        let half_view = tan(field_of_view/Double(2))
        let aspect = hsize / vsize
        
        if aspect >= 1 {
            half_width = half_view
            half_height = half_view / aspect
        } else {
            half_width = half_view * aspect
            half_height = half_view
        }
        self.pixel_size = (half_width * 2) / hsize
        print("Pixel_size: \(self.pixel_size)")
        self.transform = Matrix4.identity()
        self.invTransform = Matrix4.identity()
    }
    
    func ray_for_pixel(px: Int, py: Int) -> Ray {
        let xoffset = (Double(px) + 0.5) * self.pixel_size
        let yoffset = (Double(py) + 0.5) * self.pixel_size
        
        let world_x = self.half_width - xoffset
        let world_y = self.half_height - yoffset
        
        let pixel = self.invTransform * Point(x: world_x, y: world_y, z: -1)
        let origin = (self.invTransform * Point(x: 0, y: 0, z: 0)).asPoint()
        let direction = (pixel - origin).asVector()
        
        return Ray(orig: origin, dir: direction.normalize())
    }
    
    func render(world: World) -> Canvas {
//        let image = Canvas(w: Int(self.hsize), h: Int(self.vsize))
//
//        for y in 0..<Int(self.vsize) {
//
//            for x in 0..<Int(self.hsize) {
//                let ray = self.ray_for_pixel(px: x, py: y)
//                let color = world.colorAt(ray: ray, remaining: 4)
//                image.write_pixel(x: x, y: y, color: color)
//            }
//        }
//        return image
        
        return renderParallell(world: world)
    }
    
    func renderDebug(x: Int, y: Int, world: World) {
        let ray = self.ray_for_pixel(px: x, py: y)
        let color = world.colorAt(ray: ray, remaining: 3)
        print("color at \(x),\(y) = \(color)")
    }
    
    struct RenderPoint {
        var x: Int
        var y: Int
    }
    
    func renderParallell(world: World) -> Canvas {
        var renderPoints: [RenderPoint] = []
        var images: [Canvas] = []
        let returnImage = Canvas(w: Int(self.hsize), h: Int(self.vsize))
        
        for y in 0..<Int(self.vsize) {
            for x in 0..<Int(self.hsize) {
                let point = RenderPoint(x: x, y: y)
                renderPoints.append(point)
            }
        }
        
        let firstBlock = renderPoints[..<(renderPoints.count / 4)]
        let secondBlock = renderPoints[(renderPoints.count / 4)..<(renderPoints.count * 2 / 4)]
        let thirdBlock = renderPoints[(renderPoints.count * 2 / 4)..<(renderPoints.count * 3 / 4)]
        let fourthBlock = renderPoints[(renderPoints.count * 3 / 4)...]
        
        
        let inputs = [firstBlock, secondBlock, thirdBlock, fourthBlock]
        
        images.append(Canvas(w: Int(self.hsize), h: Int(self.vsize)))
        images.append(Canvas(w: Int(self.hsize), h: Int(self.vsize)))
        images.append(Canvas(w: Int(self.hsize), h: Int(self.vsize)))
        images.append(Canvas(w: Int(self.hsize), h: Int(self.vsize)))

//        DispatchQueue.concurrentPerform(iterations: 4) { index in
//            let low_y = index * Int(self.vsize) / 4
//            let high_y = low_y + (Int(self.vsize) / 4)
//
//            for y in low_y..<high_y {
//                for x in 0..<Int(self.hsize) {
//                    let ray = self.ray_for_pixel(px: x, py: y)
//                    let color = world.colorAt(ray: ray, remaining: 4)
//                    images[index].write_pixel(x: x, y: y, color: color)
//                }
//            }
//        }
        
        DispatchQueue.concurrentPerform(iterations: 4) { ix in
            let rPoints = inputs[ix]
            for point in rPoints {
                let ray = self.ray_for_pixel(px: point.x, py: point.y)
                let color = world.colorAt(ray: ray, remaining: 4)
                images[ix].write_pixel(x: point.x, y: point.y, color: color)
            }
        }

        for y in 0..<Int(self.vsize) {
            for x in 0..<Int(self.hsize) {
                let pixel_color =   images[0].pixel_at(x: x, y: y) +
                                    images[1].pixel_at(x: x, y: y) +
                                    images[2].pixel_at(x: x, y: y) +
                                    images[3].pixel_at(x: x, y: y)
                returnImage.write_pixel(x: x, y: y, color: pixel_color)
            }
        }

        return returnImage
    }
}

