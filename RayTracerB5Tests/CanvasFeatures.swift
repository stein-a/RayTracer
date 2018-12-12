//
//  CanvasFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class CanvasFeatures: XCTestCase {

    // Scenario: Creating a canvas
    // Given c ← canvas(10, 20)
    // Then c.width = 10
    // And c.height = 20
    // And every pixel of c is color(0, 0, 0)
    func testCreateCanvas() {
        let c = Canvas(w: 10, h: 20)
        XCTAssert(c.width == 10)
        XCTAssert(c.height == 20)
        XCTAssert(c.pixel_at(x: 2, y: 3).red == 0)
        XCTAssert(c.pixel_at(x: 2, y: 3).green == 0)
        XCTAssert(c.pixel_at(x: 2, y: 3).blue == 0)
    }
    
    // Scenario: Writing pixels to a canvas
    // Given c ← canvas(10, 20)
    // And red ← color(1, 0, 0)
    // When write_pixel(c, 2, 3, red)
    // Then pixel_at(c, 2, 3) = red
    func testWritePixelToCanvas() {
        let c = Canvas(w: 10, h: 20)
        let red = Color(r: 1, g: 0, b: 0)
        c.write_pixel(x: 2, y: 3, color: red)
        XCTAssert(c.pixel_at(x: 2, y: 3).red == 1)
        XCTAssert(c.pixel_at(x: 2, y: 3).green == 0)
        XCTAssert(c.pixel_at(x: 2, y: 3).blue == 0)
    }
    
    // PPM file format:
    // The first line is just the string “P3” (which is the identifier, or “magic number”, for the flavor of PPM we’re using), followed by a newline.
    // The second line consists of two numbers which describe the image’s width and height in pixels.
    // The third line specifies the maximum color value, which just means that each red, green, and blue value will be scaled to lie between 0 and 255, inclusive.
    
    // Write the following test. It introduces a function called canvas_to_ppm(canvas) which returns a PPM-formatted string.
    // This test will help ensure that the header is created properly.
    // Scenario: Constructing the PPM header
    // Given c ← canvas(5, 3)
    // When ppm ← canvas_to_ppm(c)
    // Then lines 1-3 of ppm are
    // """
    // P3
    // 5 3
    // 255
    // """
    func testPPMHeader() {
        let ppm_fasit = """
                        P3
                        5 3
                        255
                        """
        let c = Canvas(w: 5, h: 3)
        let ppm = c.canvas_to_ppm()
        let header = ppm.prefix(10)
        XCTAssert(header == ppm_fasit)
    }
    
    // Immediately following this header is the pixel data. This contains each pixel represented as three integers: red, green, and blue.
    // Each component should be scaled to be between 0 and the maximum color value given in the header (e.g. 255), and each value should be separated from its neighbors by a space.
    // Notice that the pixels are in row-major order. The first row of pixels comes first, then the second row, and so forth. Further, each row is terminated by a newline.
    // In addition, no line in a PPM file should be more than 70 characters long.
    
    // Scenario: Constructing the PPM pixel data
    // Given c ← canvas(5, 3)
    // And c1 ← color(1.5, 0, 0)
    // And c2 ← color(0, 0.5, 0)
    // And c3 ← color(-0.5, 0, 1)
    // When write_pixel(c, 0, 0, c1)
    // And write_pixel(c, 2, 1, c2)
    // And write_pixel(c, 4, 2, c3)
    // And ppm ← canvas_to_ppm(c)
    // Then lines 4-6 of ppm are
    // """
    // 255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    // 0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
    // 0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
    // """
    func testPPMPixelData() {
        let c = Canvas(w: 5, h: 3)
        let c1 = Color(r: 1.5, g: 0, b: 0)
        let c2 = Color(r: 0, g: 0.5, b: 0)
        let c3 = Color(r: -0.5, g: 0, b: 1)
        
        c.write_pixel(x: 0, y: 0, color: c1)
        c.write_pixel(x: 2, y: 1, color: c2)
        c.write_pixel(x: 4, y: 2, color: c3)
        
        let ppm = c.canvas_to_ppm()
        print(ppm)
    }
    
    // Scenario: Splitting long lines in PPM files
    // Given c ← canvas(10, 2)
    // When every pixel of c is set to color(1, 0.8, 0.6)
    // And ppm ← canvas_to_ppm(c)
    // Then lines 4-7 of ppm are
    // """
    // 255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
    // 153 255 204 153 255 204 153 255 204 153 255 204 153
    // 255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204
    // 153 255 204 153 255 204 153 255 204 153 255 204 153
    // """
    func testPPMPixelDataLongLines() {
        let c = Canvas(w: 10, h: 2)
        let c1 = Color(r: 1, g: 0.8, b: 0.6)
        
        c.write_pixel(x: 0, y: 0, color: c1)
        c.write_pixel(x: 1, y: 0, color: c1)
        c.write_pixel(x: 2, y: 0, color: c1)
        c.write_pixel(x: 3, y: 0, color: c1)
        c.write_pixel(x: 4, y: 0, color: c1)
        c.write_pixel(x: 5, y: 0, color: c1)
        c.write_pixel(x: 6, y: 0, color: c1)
        c.write_pixel(x: 7, y: 0, color: c1)
        c.write_pixel(x: 8, y: 0, color: c1)
        c.write_pixel(x: 9, y: 0, color: c1)
        c.write_pixel(x: 0, y: 1, color: c1)
        c.write_pixel(x: 1, y: 1, color: c1)
        c.write_pixel(x: 2, y: 1, color: c1)
        c.write_pixel(x: 3, y: 1, color: c1)
        c.write_pixel(x: 4, y: 1, color: c1)
        c.write_pixel(x: 5, y: 1, color: c1)
        c.write_pixel(x: 6, y: 1, color: c1)
        c.write_pixel(x: 7, y: 1, color: c1)
        c.write_pixel(x: 8, y: 1, color: c1)
        c.write_pixel(x: 9, y: 1, color: c1)
        
        let ppm = c.canvas_to_ppm()
        print(ppm)
    }
    
    // Scenario: PPM files are terminated by a newline
    // Given c ← canvas(5, 3)
    // When ppm ← canvas_to_ppm(c)
    // Then the last character of ppm is a newline
    

}
