//
//  Parser.swift
//  RayTracerB5
//
//  Created by Stein Alver on 14/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation

class Parser {
    
    var vertices: [Point]
    var defaultGroup: Group
    var ignoredLines: Int
    var processedLines: Int
    var groups: [Group]
    var groupNames: [String]
    var currentGroupName: String
    var currentGroup: Group
    
    init() {
        self.vertices = [Point]()
        self.defaultGroup = Group()
        self.ignoredLines = 0
        self.processedLines = 0
        self.vertices.append(Point(x: 0, y: 0, z: 0))  // Dummy index 0
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
                var points = [Point]()
                for i in 1..<symbols.count {
                    if let ix = Int(symbols[i]) {
                        let p = self.vertices[ix]
                        points.append(p)
                    } 
                }
                self.fanTriangulation(vertices: points)
                self.processedLines = self.processedLines + 1

            case "g":
                let groupName = symbols[1]
                let group = Group(name: groupName)
                self.groupNames.append(groupName)
                self.groups.append(group)
                self.currentGroupName = groupName
                self.currentGroup = group
                self.processedLines = self.processedLines + 1

            case "vn": print(symbols)
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
