//
//  Matrix4Features.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 04/03/2021.
//  Copyright © 2021 Stein Alver. All rights reserved.
//

import Foundation
import simd
import os

import XCTest
@testable import RayTracerB5

class Matrix4Features: XCTestCase {
    
    // Scenario: Constructing and inspecting a 4x4 matrix
    // Given the following 4x4 matrix M:
    // | 1    | 2    | 3    | 4    |
    // | 5.5  | 6.5  | 7.5  | 8.5  |
    // | 9    | 10   | 11   | 12   |
    // | 13.5 | 14.5 | 15.5 | 16.5 |
    // Then M[0,0] = 1 And M[0,3] = 4
    // And M[1,0] = 5.5 And M[1,2] = 7.5
    // And M[2,2] = 11 And M[3,0] = 13.5 And M[3,2] = 15.5
    func testConstructingAndInspectingA4x4Matrix4() {
        let M4 = Matrix4(row0: simd_double4(1, 2, 3, 4),
                         row1: simd_double4(5.5, 6.5, 7.5, 8.5),
                         row2: simd_double4(9, 10, 11, 12),
                         row3: simd_double4(13.5, 14.5, 15.5, 16.5))
        XCTAssertEqual(M4[0,0], 1)
        XCTAssertEqual(M4[0,3], 4)
        XCTAssertEqual(M4[1,0], 5.5)
        XCTAssertEqual(M4[1,2], 7.5)
        XCTAssertEqual(M4[2,2], 11)
        XCTAssertEqual(M4[3,0], 13.5)
        XCTAssertEqual(M4[3,2], 15.5)
    }
    
    // Scenario: Matrix equality with identical matrices
    // Given the following matrix A:
    // | 1 | 2 | 3 | 4 | | 5 | 6 | 7 | 8 | | 9 | 8 | 7 | 6 | | 5 | 4 | 3 | 2 |
    // And the following matrix B:
    // | 1 | 2 | 3 | 4 | | 5 | 6 | 7 | 8 | | 9 | 8 | 7 | 6 | | 5 | 4 | 3 | 2 |
    // Then A = B
    func testMatrix4EqualityWithIdenticalMatrices() {
        let A = Matrix4(row0: simd_double4(1, 2, 3, 4),
                        row1: simd_double4(5, 6, 7, 8),
                        row2: simd_double4(9, 8, 7, 6),
                        row3: simd_double4(5, 4, 3, 2))
        let B = Matrix4(row0: simd_double4(1, 2, 3, 4),
                        row1: simd_double4(5, 6, 7, 8),
                        row2: simd_double4(9, 8, 7, 6),
                        row3: simd_double4(5, 4, 3, 2))
        XCTAssertTrue(A == B)
    }
    
    // Scenario: Matrix equality with different matrices
    // Given the following matrix A:
    // | 1 | 2 | 3 | 4 || 5 | 6 | 7 | 8 || 9 | 8 | 7 | 6 || 5 | 4 | 3 | 2 |
    // And the following matrix B:
    // | 2 | 3 | 4 | 5 || 6 | 7 | 8 | 9 || 8 | 7 | 6 | 5 || 4 | 3 | 2 | 1 |
    // Then A != B
    func testMatrix4EqualityWithDifferentMatrices() {
        let A = Matrix4(row0: simd_double4(1, 2, 3, 4),
                        row1: simd_double4(5, 6, 7, 8),
                        row2: simd_double4(9, 8, 7, 6),
                        row3: simd_double4(5, 4, 3, 2))
        let B = Matrix4(row0: simd_double4(2, 3, 4, 5),
                        row1: simd_double4(6, 7, 8, 9),
                        row2: simd_double4(8, 7, 6, 5),
                        row3: simd_double4(4, 3, 2, 1))
        XCTAssertFalse(A == B)
    }
    
    // Scenario: Multiplying two matrices
    // Given the following matrix A:
    // |1|2|3|4||5|6|7|8||9|8|7|6||5|4|3|2|
    // And the following matrix B:
    // |-2|1|2|3||3|2|1|-1||4|3|6|5||1|2|7|8|
    // Then A * B is the following 4x4 matrix:
    // |20|22|50|48||44|54|114|108||40|58|110|102||16|26|46|42|
    func testMultiplyingTwoMatrices() {
        let A = Matrix4(row0: simd_double4(1, 2, 3, 4),
                        row1: simd_double4(5, 6, 7, 8),
                        row2: simd_double4(9, 8, 7, 6),
                        row3: simd_double4(5, 4, 3, 2))
        let B = Matrix4(row0: simd_double4(-2, 1, 2, 3),
                        row1: simd_double4(3, 2, 1, -1),
                        row2: simd_double4(4, 3, 6, 5),
                        row3: simd_double4(1, 2, 7, 8))
        let C = Matrix4(row0: simd_double4(20, 22, 50, 48),
                        row1: simd_double4(44, 54, 114, 108),
                        row2: simd_double4(40, 58, 110, 102),
                        row3: simd_double4(16, 26, 46, 42))
        XCTAssertEqual(A * B, C)
    }
    
    // Scenario: A matrix multiplied by a tuple
    // Given the following matrix A:
    // |1|2|3|4||2|4|4|2||8|6|4|1||0|0|0|1|
    // And b ← tuple(1, 2, 3, 1)
    // Then A * b = tuple(18, 24, 33, 1)
    func testAMatrix4MultipliedByATuple() {
        let A = Matrix4(row0: simd_double4(1, 2, 3, 4),
                        row1: simd_double4(2, 4, 4, 2),
                        row2: simd_double4(8, 6, 4, 1),
                        row3: simd_double4(0, 0, 0, 1))
        let b = Tuple(x: 1, y: 2, z: 3, w: 1)
        XCTAssertEqual(A * b, Tuple(x: 18, y: 24, z: 33, w: 1))
    }
    
    // Scenario: Multiplying a matrix by the identity matrix
    // Given the following matrix A:
    // |0|1|2|4||1|2|4|8||2|4|8|16||4|8|16|32|
    // Then A * identity_matrix = A
    func testMultiplyingAMatrix4ByTheIdentityMatrix4() {
        let A = Matrix4(row0: simd_double4(0, 1, 2, 4),
                        row1: simd_double4(1, 2, 4, 8),
                        row2: simd_double4(2, 4, 8, 16),
                        row3: simd_double4(4, 8, 16, 32))
        XCTAssertEqual(A * Matrix4.identity(), A)
    }
    
    // Scenario: Multiplying the identity matrix by a tuple
    // Given a ← tuple(1, 2, 3, 4)
    // Then identity_matrix * a = a
    func testMultiplyingTheIdentityMatrix4ByATuple() {
        let I = Matrix4.identity()
        let a = Tuple(x: 1, y: 2, z: 3, w: 4)
        XCTAssertEqual(I * a, a)
    }
    
    // Scenario: Transposing a matrix
    // Given the following matrix A:
    // |0|9|3|0||9|8|0|8||1|8|5|3||0|0|5|8|
    // Then transpose(A) is the following matrix:
    // |0|9|1|0||9|8|8|0||3|0|5|5||0|8|3|8|
    func testTransposingAMatrix4() {
        let A = Matrix4(row0: simd_double4(0, 9, 3, 0),
                        row1: simd_double4(9, 8, 0, 8),
                        row2: simd_double4(1, 8, 5, 3),
                        row3: simd_double4(0, 0, 5, 8))
        let B = Matrix4(row0: simd_double4(0, 9, 1, 0),
                        row1: simd_double4(9, 8, 8, 0),
                        row2: simd_double4(3, 0, 5, 5),
                        row3: simd_double4(0, 8, 3, 8))
        XCTAssertEqual(A^, B)
    }
    
    // Scenario: Transposing the identity matrix
    // Given A ← transpose(identity_matrix)
    // Then A = identity_matrix
    func testTransposingTheIdentityMatrix4() {
        let A = Matrix4.identity()^
        XCTAssertEqual(A, Matrix4.identity())
    }
    
    // Scenario: Calculating the determinant of a 4x4 matrix
    // Given the 4x4 matrix A:|-2|-8|3|5||-3|1|7|3||1|2|-9|6||-6|7|7|-9|
    // Then cofactor(A, 0, 0) = 690 And cofactor(A, 0, 1) = 447
    // And cofactor(A, 0, 2) = 210 And cofactor(A, 0, 3) = 51
    // And determinant(A) = -4071
    func testCalculatingTheDeterminantOfA4x4Matrix() {
        let A = Matrix4(row0: simd_double4(-2, -8, 3, 5),
                        row1: simd_double4(-3, 1, 7, 3),
                        row2: simd_double4(1, 2, -9, 6),
                        row3: simd_double4(-6, 7, 7, -9))
        XCTAssertEqual(A.determinant(), -4071)
    }

    // Scenario: Calculating the inverse of a matrix
    // Given the 4x4 matrix A:|-5|2|6|-8||1|-5|1|8||7|7|-6|-7||1|-3|7|4|
    // And B ← inverse(A)
    // Then determinant(A) = 532 And cofactor(A, 2, 3) = -160
    // And B[3,2] = -160/532 And cofactor(A, 3, 2) = 105
    // And B[2,3] = 105/532 And B is the following 4x4 matrix:
    // | 0.21805| 0.45113| 0.24060|-0.04511|
    // |-0.80827|-1.45677|-0.44361| 0.52068|
    // |-0.07895|-0.22368|-0.05263| 0.19737|
    // |-0.52256|-0.81391|-0.30075| 0.30639|
    func testCalculatingTheInverseOfAMatrix4() {
        let A = Matrix4(row0: simd_double4(-5, 2, 6, -8),
                        row1: simd_double4(1, -5, 1, 8),
                        row2: simd_double4(7, 7, -6, -7),
                        row3: simd_double4(1, -3, 7, 4))
        let B = A.inverse()
        let C = Matrix4(row0: simd_double4(0.21805, 0.45113, 0.24060, -0.04511),
                        row1: simd_double4(-0.80827, -1.45677, -0.44361, 0.52068),
                        row2: simd_double4(-0.07895, -0.22368, -0.05263, 0.19737),
                        row3: simd_double4(-0.52256, -0.81391, -0.30075, 0.30639))
        XCTAssertEqual(A.determinant(), 532)
        XCTAssertEqual(B, C)
    }
    
    // Scenario: Calculating the inverse of another matrix
    // Given the 4x4 matrix A:|8|-5|9|2||7|5|6|1||-6|0|9|6||-3|0|-9|-4|
    // Then inverse(A) is the following 4x4 matrix:
    // | -0.15385 | -0.15385 | -0.28205 | -0.53846 |
    // | -0.07692 |  0.12308 |  0.02564 |  0.03077 |
    // |  0.35897 |  0.35897 |  0.43590 |  0.92308 |
    // | -0.69231 | -0.69231 | -0.76923 | -1.92308 |
    func testCalculatingTheInverseOfAnotherMatrix4() {
        let A = Matrix4(row0: simd_double4(8, -5, 9, 2),
                        row1: simd_double4(7, 5, 6, 1),
                        row2: simd_double4(-6, 0, 9, 6),
                        row3: simd_double4(-3, 0, -9, -4))
        let B = A.inverse()
        let C = Matrix4(row0: simd_double4(-0.15385, -0.15385, -0.28205, -0.53846),
                        row1: simd_double4(-0.07692, 0.12308, 0.02564, 0.03077),
                        row2: simd_double4(0.35897, 0.35897, 0.43590, 0.92308),
                        row3: simd_double4(-0.69231, -0.69231, -0.76923, -1.92308))
        XCTAssertEqual(B, C)
    }
    
    // Scenario: Calculating the inverse of a third matrix
    // Given the 4x4 matrix A:|9|3|0|9||-5|-2|-6|-3||-4|9|6|4||-7|6|6|2|
    // Then inverse(A) is the following 4x4 matrix:
    // | -0.04074 | -0.07778 |  0.14444 | -0.22222 |
    // | -0.07778 |  0.03333 |  0.36667 | -0.33333 |
    // | -0.02901 | -0.14630 | -0.10926 |  0.12963 |
    // |  0.17778 |  0.06667 | -0.26667 |  0.33333 |
    func testCalculatingTheInverseOfAThirdMatrix4() {
        let A = Matrix4(row0: simd_double4(9, 3, 0, 9),
                        row1: simd_double4(-5, -2, -6, -3),
                        row2: simd_double4(-4, 9, 6, 4),
                        row3: simd_double4(-7, 6, 6, 2))
        let B = A.inverse()
        let C = Matrix4(row0: simd_double4(-0.04074, -0.07778, 0.14444, -0.22222),
                        row1: simd_double4(-0.07778, 0.03333, 0.36667, -0.33333),
                        row2: simd_double4(-0.02901, -0.14630, -0.10926, 0.12963),
                        row3: simd_double4(0.17778, 0.06667, -0.26667, 0.33333))
        XCTAssertEqual(B, C)
    }
    
    // Scenario: Multiplying a product by its inverse
    // Given the 4x4 matrix A:|3|-9|7|3||3|-8|2|-9||-4|4|4|1||-6|5|-1|1|
    // And the 4x4 matrix B:|8|2|2|2||3|-1|7|0||7|0|5|4||6|-2|0|5|
    // And C ← A * B Then C * inverse(B) = A
    func testMultiplyingAProductByItsInverse() {
        let A = Matrix4(row0: simd_double4(3, -9, 7, 3),
                        row1: simd_double4(3, -8, 2, -9),
                        row2: simd_double4(-4, 4, 4, 1),
                        row3: simd_double4(-6, 5, -1, 1))
        let B = Matrix4(row0: simd_double4(8, 2, 2, 2),
                        row1: simd_double4(3, -1, 7, 0),
                        row2: simd_double4(7, 0, 5, 4),
                        row3: simd_double4(6, -2, 0, 5))
        let C = A * B
        let D = C * B.inverse()
        XCTAssertEqual(D, A)
    }
    
    func testMatrix4Description() {
        let A = Matrix4(row0: simd_double4(3, -9, 7, 3),
                        row1: simd_double4(3, -8, 2, -9),
                        row2: simd_double4(-4, 4, 4, 1),
                        row3: simd_double4(-6, 5, -1, 1))

        let logger = Logger()
        logger.log("Logging a Matrix4 description: \(A.description)")
    }

}
