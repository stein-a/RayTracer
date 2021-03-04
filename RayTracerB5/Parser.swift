//
//  Parser.swift
//  RayTracerB5
//
//  Created by Stein Alver on 14/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Parser {
    
    var ignoredLines: Int
    var processedLines: Int
    var vertices: [Point]
    var normals: [Vector]
    var defaultGroup: Group
    var groups: [Group]
    var groupNames: [String]
    var currentGroupName: String
    var currentGroup: Group
    var minX: Double
    var maxX: Double
    var minY: Double
    var maxY: Double
    var minZ: Double
    var maxZ: Double
    
    init() {
        self.vertices = [Point]()
        self.normals = [Vector]()
        self.defaultGroup = Group()
        self.ignoredLines = 0
        self.processedLines = 0
        self.vertices.append(Point(x: 0, y: 0, z: 0))  // Dummy index 0
        self.normals.append(Vector(x: 0, y: 0, z: 0))  // Dummy index 0
        self.groups = [Group]()
        self.groupNames = [String]()
        self.currentGroupName = "DefaultGroup"
        self.currentGroup = self.defaultGroup
        self.minX = 10.0
        self.minY = 10.0
        self.minZ = 10.0
        self.maxX = -10.0
        self.maxY = -10.0
        self.maxZ = -10.0
    }
    
    func parseObj(file: String) {
        let lines = file.components(separatedBy: CharacterSet.newlines)
        for line in lines {
            var symbols = line.components(separatedBy: CharacterSet.whitespaces)
            let command = symbols.first
            
            switch command {
            case "v":
                if symbols[1] == " " || symbols[1] == "" {
                    symbols[1] = symbols[2]
                    symbols[2] = symbols[3]
                    symbols[3] = symbols[4]
                }
                if let x = Double(symbols[1]), let y = Double(symbols[2]),
                    let z = Double(symbols[3]) {
                    let p = Point(x: x, y: y, z: z)
                    self.vertices.append(p)
                    self.processedLines = self.processedLines + 1
                    if x < minX {
                        minX = x
                    }
                    if x > maxX {
                        maxX = x
                    }
                    if y < minY {
                        minY = y
                    }
                    if y > maxY {
                        maxY = y
                    }
                    if z < minZ {
                        minZ = z
                    }
                    if z > maxZ {
                        maxZ = z
                    }
                } else {
                    self.ignoredLines = self.ignoredLines + 1
                    break
                }

            case "f":
                let symbol = symbols[1]
                if symbol.contains("/") {
                    // format:
                    // f 1/2/3 2/3/4 3/4/5
                    // f 1//3 2//4 3//5
                    var points = [Point]()
                    var normals = [Vector]()
                    for i in 1..<symbols.count {
                        let numbers = symbols[i].components(separatedBy: "/")
                        if let vi = Int(numbers[0]), let ni = Int(numbers[2]) {
                            let p = self.vertices[vi]
                            let n = self.normals[ni]
                            points.append(p)
                            normals.append(n)
                        }
                    }
                    self.smoothFanTriangulation(vertices: points, normals: normals)
                    self.processedLines = self.processedLines + 1
                } else {
                    // Simple format f 1 2 3 4 5 ...
                    var points = [Point]()
                    for i in 1..<symbols.count {
                        if let ix = Int(symbols[i]) {
                            let p = self.vertices[ix]
                            points.append(p)
                        }
                    }
                    self.fanTriangulation(vertices: points)
                    self.processedLines = self.processedLines + 1
                }

            case "g":
                let groupName = symbols[1]
                let group = Group(name: groupName)
                self.groupNames.append(groupName)
                self.groups.append(group)
                self.currentGroupName = groupName
                self.currentGroup = group
                self.processedLines = self.processedLines + 1

            case "vn":
                if let x = Double(symbols[1]), let y = Double(symbols[2]),
                    let z = Double(symbols[3]) {
                    let v = Vector(x: x, y: y, z: z)
                    self.normals.append(v)
                    self.processedLines = self.processedLines + 1
                } else {
                    self.ignoredLines = self.ignoredLines + 1
                    break
                }
                
            default:
                self.ignoredLines = self.ignoredLines + 1
            }
        }
        print("X - min \(minX) - max \(maxX) - sx = \(maxX - minX)")
        print("Y - min \(minY) - max \(maxY) - sy = \(maxY - minY)")
        print("Z - min \(minZ) - max \(maxZ) - sz = \(maxZ - minZ)")
    }
    
    func ObjToGroup() -> Group {
        if self.currentGroupName == "DefaultGroup" {
            return self.defaultGroup
        } else {
            let outGroup = Group(name: "OBJ-file")
            for group in self.groups {
                outGroup.addChild(shape: group)
            }
            return outGroup
        }
    }
    
    func fanTriangulation(vertices: [Point]) {
        for index in 1..<(vertices.count - 1) {
            let tri = Triangle(p1: vertices[0],
                               p2: vertices[index],
                               p3: vertices[index + 1])
            self.currentGroup.addChild(shape: tri)
        }
    }
    
    func smoothFanTriangulation(vertices: [Point], normals: [Vector]) {
        for index in 1..<(vertices.count - 1) {
            let tri = SmoothTriangle(p1: vertices[0],
                                     p2: vertices[index],
                                     p3: vertices[index + 1],
                                     n1: normals[0],
                                     n2: normals[index],
                                     n3: normals[index + 1])
            self.currentGroup.addChild(shape: tri)
        }
    }
    
    func group(name: String) -> Group? {
        if let i = self.groupNames.firstIndex(of: name) {
            return self.groups[i]
        }
        return nil
    }
}
