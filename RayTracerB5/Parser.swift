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
    }
    
    func parseObj(file: String) {
        let lines = file.components(separatedBy: CharacterSet.newlines)
        for line in lines {
            let symbols = line.components(separatedBy: CharacterSet.whitespaces)
            let command = symbols.first
            
            switch command {
            case "v":
                if let x = Float(symbols[1]), let y = Float(symbols[2]),
                    let z = Float(symbols[3]) {
                    let p = Point(x: x, y: y, z: z)
                    self.vertices.append(p)
                    self.processedLines = self.processedLines + 1
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
                    var p1: Point = Point(x: 0, y: 0, z: 0)
                    var p2: Point = Point(x: 0, y: 0, z: 0)
                    var p3: Point = Point(x: 0, y: 0, z: 0)
                    var n1: Vector = Vector(x: 0, y: 0, z: 0)
                    var n2: Vector = Vector(x: 0, y: 0, z: 0)
                    var n3: Vector = Vector(x: 0, y: 0, z: 0)
                    let numbers1 = symbols[1].components(separatedBy: "/")
                    if let ix = Int(numbers1[0]) {
                        p1 = self.vertices[ix]
                    }
                    if let ix = Int(numbers1[2]) {
                        n1 = self.normals[ix]
                    }
                    let numbers2 = symbols[2].components(separatedBy: "/")
                    if let ix = Int(numbers2[0]) {
                        p2 = self.vertices[ix]
                    }
                    if let ix = Int(numbers2[2]) {
                        n2 = self.normals[ix]
                    }
                    let numbers3 = symbols[3].components(separatedBy: "/")
                    if let ix = Int(numbers3[0]) {
                        p3 = self.vertices[ix]
                    }
                    if let ix = Int(numbers3[2]) {
                        n3 = self.normals[ix]
                    }
                    let tri = SmoothTriangle(p1: p1, p2: p2, p3: p3,
                                             n1: n1, n2: n2, n3: n3)
                    self.currentGroup.addChild(shape: tri)
                    self.processedLines = self.processedLines + 1
                } else {
                    // Simple format f 1 2 3
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
                if let x = Float(symbols[1]), let y = Float(symbols[2]),
                    let z = Float(symbols[3]) {
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
    
    func group(name: String) -> Group? {
        if let i = self.groupNames.firstIndex(of: name) {
            return self.groups[i]
        }
        return nil
    }
}
