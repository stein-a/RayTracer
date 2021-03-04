//
//  Color.swift
//  RayTracerB4
//
//  Created by Stein Alver on 15/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Color : Equatable, CustomStringConvertible {
    static func == (lhs: Color, rhs: Color) -> Bool {
        let epsilon : Double = 0.00001
        if abs(lhs.red - rhs.red) < epsilon &&
           abs(lhs.green - rhs.green) < epsilon &&
           abs(lhs.blue - rhs.blue) < epsilon {
            return true
        } else {
            return false
        }
    }
    
    static func + (lhs: Color, rhs: Color) -> Color {
        let red = lhs.red + rhs.red
        let green = lhs.green + rhs.green
        let blue = lhs.blue + rhs.blue
        return Color(r: red, g: green, b: blue)
    }
    
    static func - (lhs: Color, rhs: Color) -> Color {
        let red = lhs.red - rhs.red
        let green = lhs.green - rhs.green
        let blue = lhs.blue - rhs.blue
        return Color(r: red, g: green, b: blue)
    }
 
    static func * (lhs: Color, scalar: Double) -> Color {
        let red = lhs.red * scalar
        let green = lhs.green * scalar
        let blue = lhs.blue * scalar
        return Color(r: red, g: green, b: blue)
    }
    
    // Hadamard product
    static func * (lhs: Color, rhs: Color) -> Color {
        let red = lhs.red * rhs.red
        let green = lhs.green * rhs.green
        let blue = lhs.blue * rhs.blue
        return Color(r: red, g: green, b: blue)
    }
    
    var red : Double
    var green : Double
    var blue : Double

    var description: String {
        return "red=\(red), green=\(green), blue=\(blue)"
    }
    

    
    init(r: Double, g: Double, b: Double) {
        self.red = r
        self.green = g
        self.blue = b
    }
}

