//
//  ObjFileFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class ObjFileFeatures: XCTestCase {

    // Scenario: Ignoring unrecognized lines
    // Given gibberish ← a file containing:
    // """
    // There was a young lady named Bright
    // who traveled much faster than light.
    // She set out one day
    // in a relative way,
    // and came back the previous night.
    // """
    // When parser ← parse_obj_file(gibberish)
    // Then parser should have ignored 5 lines
    func testIgnoringUnrecognizedLines() {
        let gibberish = """
There was a young lady named Bright
who traveled much faster than light.
She set out one day
in a relative way,
and came back the previous night.
"""
        let parser = Parser()
        parser.parseObj(file: gibberish)
        XCTAssertEqual(parser.ignoredLines, 5)
    }
    
    // Scenario: Vertex records
    // Given file ← a file containing:
    // """
    // v -1 1 0
    // v -1.0000 0.5000 0.0000
    // v 1 0 0
    // v 1 1 0
    // """
    // When parser ← parse_obj_file(file)
    // Then parser.vertices[1] = point(-1, 1, 0)
    // And parser.vertices[2] = point(-1, 0.5, 0)
    // And parser.vertices[3] = point(1, 0, 0)
    // And parser.vertices[4] = point(1, 1, 0)
    func testVertexRecords() {
        let file = """
v -1 1 0
v -1.0000 0.5000 0.0000
v 1 0 0
v 1 1 0
"""
        let parser = Parser()
        parser.parseObj(file: file)
        XCTAssertEqual(parser.processedLines, 4)
        XCTAssertEqual(parser.vertices[1], Point(x: -1, y: 1, z: 0))
        XCTAssertEqual(parser.vertices[2], Point(x: -1, y: 0.5, z: 0))
        XCTAssertEqual(parser.vertices[3], Point(x: 1, y: 0, z: 0))
        XCTAssertEqual(parser.vertices[4], Point(x: 1, y: 1, z: 0))
    }
    
    // Scenario: Parsing triangle faces
    // Given file ← a file containing:
    // """
    // v -1 1 0
    // v -1 0 0
    // v 1 0 0
    // v 1 1 0
    // f 1 2 3
    // f 1 3 4
    // """
    // When parser ← parse_obj_file(file)
    // And g ← parser.default_group
    // And t1 ← first child of g And t2 ← second child of g
    // Then t1.p1 = parser.vertices[1] And t1.p2 = parser.vertices[2]
    // And t1.p3 = parser.vertices[3] And t2.p1 = parser.vertices[1]
    // And t2.p2 = parser.vertices[3] And t2.p3 = parser.vertices[4]
    func testParsingTriangleFaces() {
        let file = """
v -1 1 0
v -1 0 0
v 1 0 0
v 1 1 0
f 1 2 3
f 1 3 4
"""
        let parser = Parser()
        parser.parseObj(file: file)
        XCTAssertEqual(parser.processedLines, 6)
        let g = parser.defaultGroup
        XCTAssertEqual(g.shapes.count, 2)
        let t1 = g.shapes[0] as! Triangle
        let t2 = g.shapes[1] as! Triangle
        XCTAssertEqual(t1.p1, parser.vertices[1])
        XCTAssertEqual(t1.p2, parser.vertices[2])
        XCTAssertEqual(t1.p3, parser.vertices[3])
        XCTAssertEqual(t2.p1, parser.vertices[1])
        XCTAssertEqual(t2.p2, parser.vertices[3])
        XCTAssertEqual(t2.p3, parser.vertices[4])
    }
    
    // Scenario: Triangulating polygons
    // Given file ← a file containing:
    // """
    // v -1 1 0
    // v -1 0 0
    // v 1 0 0
    // v 1 1 0
    // v 0 2 0
    // f 1 2 3 4 5
    // """
    // When parser ← parse_obj_file(file) And g ← parser.default_group
    // And t1 ← first child of g And t2 ← second child of g
    // And t3 ← third child of g
    // Then t1.p1 = parser.vertices[1] And t1.p2 = parser.vertices[2]
    // And t1.p3 = parser.vertices[3] And t2.p1 = parser.vertices[1]
    // And t2.p2 = parser.vertices[3] And t2.p3 = parser.vertices[4]
    // And t3.p1 = parser.vertices[1] And t3.p2 = parser.vertices[4]
    // And t3.p3 = parser.vertices[5]
    func testTriangulatingPolygons() {
        let file = """
v -1 1 0
v -1 0 0
v 1 0 0
v 1 1 0
v 0 2 0
f 1 2 3 4 5
"""
        let parser = Parser()
        parser.parseObj(file: file)
        XCTAssertEqual(parser.processedLines, 6)
        let g = parser.defaultGroup
        XCTAssertEqual(g.shapes.count, 3)
        let t1 = g.shapes[0] as! Triangle
        let t2 = g.shapes[1] as! Triangle
        let t3 = g.shapes[2] as! Triangle
        XCTAssertEqual(t1.p1, parser.vertices[1])
        XCTAssertEqual(t1.p2, parser.vertices[2])
        XCTAssertEqual(t1.p3, parser.vertices[3])
        XCTAssertEqual(t2.p1, parser.vertices[1])
        XCTAssertEqual(t2.p2, parser.vertices[3])
        XCTAssertEqual(t2.p3, parser.vertices[4])
        XCTAssertEqual(t3.p1, parser.vertices[1])
        XCTAssertEqual(t3.p2, parser.vertices[4])
        XCTAssertEqual(t3.p3, parser.vertices[5])
    }
    
    // Scenario: Triangles in groups
    // Given file ← the file "triangles.obj"
    // When parser ← parse_obj_file(file)
    // And g1 ← "FirstGroup" from parser And g2 ← "SecondGroup" from parser
    // And t1 ← first child of g1 And t2 ← first child of g2
    // Then t1.p1 = parser.vertices[1] And t1.p2 = parser.vertices[2]
    // And t1.p3 = parser.vertices[3] And t2.p1 = parser.vertices[1]
    // And t2.p2 = parser.vertices[3] And t2.p3 = parser.vertices[4]
    func testTrianglesInGroups() {
        let file = try! String.init(contentsOfFile: "/Users/salver/Development/RayTracerB5/RayTracerB5Tests/OBJfiles/triangles.obj")
        let parser = Parser()
        parser.parseObj(file: file)
        XCTAssertEqual(parser.processedLines, 8)
        if let g1 = parser.group(name: "FirstGroup") {
            let t1 = g1.shapes[0] as! Triangle
            XCTAssertEqual(t1.p1, parser.vertices[1])
            XCTAssertEqual(t1.p2, parser.vertices[2])
            XCTAssertEqual(t1.p3, parser.vertices[3])
        }
        if let g2 = parser.group(name: "SecondGroup") {
            let t2 = g2.shapes[0] as! Triangle
            XCTAssertEqual(t2.p1, parser.vertices[1])
            XCTAssertEqual(t2.p2, parser.vertices[3])
            XCTAssertEqual(t2.p3, parser.vertices[4])
        }
    }
    
    // Scenario: Converting an OBJ file to a group
    // Given file ← the file "triangles.obj" And parser ← parse_obj_file(file)
    // When g ← obj_to_group(parser)
    // Then g includes "FirstGroup" from parser
    // And g includes "SecondGroup" from parser
    func testConvertingAnOBJFileToAGroup() {
        let file = try! String.init(contentsOfFile: "/Users/salver/Development/RayTracerB5/RayTracerB5Tests/OBJfiles/triangles.obj")
        let parser = Parser()
        parser.parseObj(file: file)
        XCTAssertEqual(parser.processedLines, 8)
        let g = parser.ObjToGroup()
        let g1 = g.shapes[0] as! Group
        let g2 = g.shapes[1] as! Group
        XCTAssertEqual(g1.name, "FirstGroup")
        XCTAssertEqual(g2.name, "SecondGroup")
    }
    
    // Scenario: Vertex normal records
    // Given file ← a file containing:
    // """ vn 0 0 1 vn 0.707 0 -0.707 vn 1 2 3 """
    // When parser ← parse_obj_file(file)
    // Then parser.normals[1] = vector(0, 0, 1)
    // And parser.normals[2] = vector(0.707, 0, -0.707)
    // And parser.normals[3] = vector(1, 2, 3)
    func testVertexNormalRecords() {
        let file = """
vn 0 0 1
vn 0.707 0 -0.707
vn 1 2 3
"""
        let parser = Parser()
        parser.parseObj(file: file)
        XCTAssertEqual(parser.processedLines, 3)
        XCTAssertEqual(parser.normals[1], Vector(x: 0, y: 0, z: 1))
        XCTAssertEqual(parser.normals[2], Vector(x: 0.707, y: 0, z: -0.707))
        XCTAssertEqual(parser.normals[3], Vector(x: 1, y: 2, z: 3))
    }
    
    // Scenario: Faces with normals
    //Given file ← a file containing:
    // """ v 0 1 0 v -1 0 0 v 1 0 0 vn -1 0 0 vn 1 0 0 vn 0 1 0
    // f 1//3 2//1 3//2 f 1/0/3 2/102/1 3/14/2 """
    // When parser ← parse_obj_file(file) And g ← parser.default_group
    // And t1 ← first child of g And t2 ← second child of g
    // Then t1.p1 = parser.vertices[1]
    // And t1.p2 = parser.vertices[2]
    // And t1.p3 = parser.vertices[3]
    // And t1.n1 = parser.normals[3]
    // And t1.n2 = parser.normals[1]
    // And t1.n3 = parser.normals[2]
    // And t2 = t1
    func testFacesWithNormals() {
        let file = """
v 0 1 0
v -1 0 0
v 1 0 0
vn -1 0 0
vn 1 0 0
vn 0 1 0
f 1//3 2//1 3//2
f 1/0/3 2/102/1 3/14/2
"""
        let parser = Parser()
        parser.parseObj(file: file)
        XCTAssertEqual(parser.processedLines, 8)
        let g = parser.defaultGroup
        let t1 = g.shapes[0] as! SmoothTriangle
        let t2 = g.shapes[1] as! SmoothTriangle
        XCTAssertEqual(t1.p1, parser.vertices[1])
        XCTAssertEqual(t1.p2, parser.vertices[2])
        XCTAssertEqual(t1.p3, parser.vertices[3])
        XCTAssertEqual(t1.n1, parser.normals[3])
        XCTAssertEqual(t1.n2, parser.normals[1])
        XCTAssertEqual(t1.n3, parser.normals[2])
        XCTAssertEqual(t2, t1)
    }
    
    // Processing an obj-file with a teapot
    func testProcessingAnOBJFileWithATeapot() {
        let file = try! String.init(contentsOfFile: "/Users/salver/Development/RayTracerB5/RayTracerB5Tests/OBJfiles/teapot.obj")
        let parser = Parser()
        parser.parseObj(file: file)
        XCTAssertEqual(parser.processedLines, 404)
        XCTAssertEqual(parser.ignoredLines, 79)
        let g = parser.ObjToGroup()
        let g1 = g.shapes[0] as! Group
        XCTAssertEqual(g1.name, "Teapot001")
    }

}
