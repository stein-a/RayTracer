//
//  MatrixFeatures.swift
//  RayTracerB5Tests
//
//  Created by Stein Alver on 12/12/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import XCTest
@testable import RayTracerB5

class MatrixFeatures: XCTestCase {

    // Scenario: Constructing and inspecting a 4x4 matrix
    // Given the following 4x4 matrix M:
    // | 1    | 2    | 3    | 4    |
    // | 5.5  | 6.5  | 7.5  | 8.5  |
    // | 9    | 10   | 11   | 12   |
    // | 13.5 | 14.5 | 15.5 | 16.5 |
    // Then M[0,0] = 1 And M[0,3] = 4
    // And M[1,0] = 5.5 And M[1,2] = 7.5
    // And M[2,2] = 11 And M[3,0] = 13.5 And M[3,2] = 15.5
    func testConstructingAndInspectingA4x4Matrix() {
        let M = Matrix([1,2,3,4,5.5,6.5,7.5,8.5,9,10,11,12,13.5,14.5,15.5,16.5], rows: 4, columns: 4)
        XCTAssertEqual(M[0,0], 1)
        XCTAssertEqual(M[0,3], 4)
        XCTAssertEqual(M[1,0], 5.5)
        XCTAssertEqual(M[1,2], 7.5)
        XCTAssertEqual(M[2,2], 11)
        XCTAssertEqual(M[3,0], 13.5)
        XCTAssertEqual(M[3,2], 15.5)
    }
    
    // Scenario: A 2x2 matrix ought to be representable
    // Given the following 2x2 matrix M:
    // | -3 | 5 |
    // | 1 | -2 |
    // Then M[0,0] = -3 And M[0,1] = 5 And M[1,0] = 1 And M[1,1] = -2
    func testA2x2Matrix() {
        let M = Matrix([-3,5,1,-2], rows: 2, columns: 2)
        XCTAssertEqual(M[0,0], -3)
        XCTAssertEqual(M[0,1], 5)
        XCTAssertEqual(M[1,0], 1)
        XCTAssertEqual(M[1,1], -2)
    }
    
    // Scenario: A 3x3 matrix ought to be representable
    // Given the following 3x3 matrix M:
    // | -3 | 5  | 0  |
    // | 1  | -2 | -7 |
    // | 0  | 1  | 1  |
    // Then M[0,0] = -3 And M[1,1] = -2 And M[2,2] = 1
    func testA3x3Matrix() {
        let M = Matrix([-3,5,0,1,-2,-7,0,1,1], rows: 3, columns: 3)
        XCTAssertEqual(M[0,0], -3)
        XCTAssertEqual(M[1,1], -2)
        XCTAssertEqual(M[2,2], 1)
    }
    
    // Scenario: Matrix equality with identical matrices
    // Given the following matrix A:
    // | 1 | 2 | 3 | 4 | | 5 | 6 | 7 | 8 | | 9 | 8 | 7 | 6 | | 5 | 4 | 3 | 2 |
    // And the following matrix B:
    // | 1 | 2 | 3 | 4 | | 5 | 6 | 7 | 8 | | 9 | 8 | 7 | 6 | | 5 | 4 | 3 | 2 |
    // Then A = B
    func testMatrixEqualityWithIdenticalMatrices() {
        let A = Matrix([1,2,3,4,5,6,7,8,9,8,7,6,5,4,3,2], rows: 4, columns: 4)
        let B = Matrix([1,2,3,4,5,6,7,8,9,8,7,6,5,4,3,2], rows: 4, columns: 4)
        XCTAssertTrue(A == B)
    }
    
    // Scenario: Matrix equality with different matrices
    // Given the following matrix A:
    // | 1 | 2 | 3 | 4 || 5 | 6 | 7 | 8 || 9 | 8 | 7 | 6 || 5 | 4 | 3 | 2 |
    // And the following matrix B:
    // | 2 | 3 | 4 | 5 || 6 | 7 | 8 | 9 || 8 | 7 | 6 | 5 || 4 | 3 | 2 | 1 |
    // Then A != B
    func testMatrixEqualityWithDifferentMatrices() {
        let A = Matrix([1,2,3,4,5,6,7,8,9,8,7,6,5,4,3,2], rows: 4, columns: 4)
        let B = Matrix([2,3,4,5,6,7,8,9,8,7,6,5,4,3,2,1], rows: 4, columns: 4)
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
        let A = Matrix([1,2,3,4,5,6,7,8,9,8,7,6,5,4,3,2], rows: 4, columns: 4)
        let B = Matrix([-2,1,2,3,3,2,1,-1,4,3,6,5,1,2,7,8], rows: 4, columns: 4)
        XCTAssertEqual(A * B, Matrix([20,22,50,48,44,54,114,108,40,58,110,102,16,26,46,42], rows: 4, columns: 4))
    }
    
    // Scenario: A matrix multiplied by a tuple
    // Given the following matrix A:
    // |1|2|3|4||2|4|4|2||8|6|4|1||0|0|0|1|
    // And b ← tuple(1, 2, 3, 1)
    // Then A * b = tuple(18, 24, 33, 1)
    func testAMatrixMultipliedByATuple() {
        let A = Matrix([1,2,3,4,2,4,4,2,8,6,4,1,0,0,0,1], rows: 4, columns: 4)
        let b = Tuple(x: 1, y: 2, z: 3, w: 1)
        XCTAssertEqual(A * b, Tuple(x: 18, y: 24, z: 33, w: 1))
    }
    
    // Scenario: Multiplying a matrix by the identity matrix
    // Given the following matrix A:
    // |0|1|2|4||1|2|4|8||2|4|8|16||4|8|16|32|
    // Then A * identity_matrix = A
    func testMultiplyingAMatrixByTheIdentityMatrix() {
        let A = Matrix([0,1,2,4,1,2,4,8,2,4,8,16,4,8,16,32], rows: 4, columns: 4)
        XCTAssertEqual(A * Matrix.identity(), A)
    }
    
    // Scenario: Multiplying the identity matrix by a tuple
    // Given a ← tuple(1, 2, 3, 4)
    // Then identity_matrix * a = a
    func testMultiplyingTheIdentityMatrixByATuple() {
        let a = Tuple(x: 1, y: 2, z: 3, w: 4)
        XCTAssertEqual(Matrix.identity() * a, a)
    }
    
    // Scenario: Transposing a matrix
    // Given the following matrix A:
    // |0|9|3|0||9|8|0|8||1|8|5|3||0|0|5|8|
    // Then transpose(A) is the following matrix:
    // |0|9|1|0||9|8|8|0||3|0|5|5||0|8|3|8|
    func testTransposingAMatrix() {
        let A = Matrix([0,9,3,0,9,8,0,8,1,8,5,3,0,0,5,8], rows: 4, columns: 4)
        XCTAssertEqual(A^, Matrix([0,9,1,0,9,8,8,0,3,0,5,5,0,8,3,8], rows: 4, columns: 4))
    }
    
    // Scenario: Transposing the identity matrix
    // Given A ← transpose(identity_matrix)
    // Then A = identity_matrix
    func testTransposingTheIdentityMatrix() {
        let A = Matrix.identity()^
        XCTAssertEqual(A, Matrix.identity())
    }
    
    // Scenario: Calculating the determinant of a 2x2 matrix
    // Given the following 2x2 matrix A:|1|5||-3|2|
    // Then determinant(A) = 17
    func testCalculatingTheDeterminantOfA2x2Matrix() {
        let A = Matrix([1,5,-3,2], rows: 2, columns: 2)
        XCTAssertEqual(A.determinant(), 17)
    }
    
    // Scenario: A submatrix of a 3x3 matrix is a 2x2 matrix
    // Given the following 3x3 matrix A:|1|5|0||-3|2|7||0|6|-3|
    // Then submatrix(A, 0, 2) is the following 2x2 matrix:
    // |-3|2||0|6|
    func testASubmatrixOfA3x3MatrixIsA2x2Matrix() {
        let A = Matrix([1,5,0,-3,2,7,0,6,-3], rows: 3, columns: 3)
        XCTAssertEqual(A.submatrix(rowToOmit: 0, colToOmit: 2),
                       Matrix([-3,2,0,6], rows: 2, columns: 2))
    }
    
    // Scenario: A submatrix of a 4x4 matrix is a 3x3 matrix
    // Given the following 4x4 matrix A:
    // |-6|1|1|6||-8|5|8|6||-1|0|8|2||-7|1|-1|1|
    // Then submatrix(A, 2, 1) is the following 3x3 matrix:
    // |-6|1|6||-8|8|6||-7|-1|1|
    func testASubmatrixOfA4x4MatrixIsA3x3Matrix() {
        let A = Matrix([-6,1,1,6,-8,5,8,6,-1,0,8,2,-7,1,-1,1], rows: 4, columns: 4)
        XCTAssertEqual(A.submatrix(rowToOmit: 2, colToOmit: 1),
                       Matrix([-6,1,6,-8,8,6,-7,-1,1], rows: 3, columns: 3))
    }
    
    // Scenario: Calculating a minor of a 3x3 matrix
    // Given the following 3x3 matrix A: |3|5|0||2|-1|-7||6|-1|5|
    // And B ← submatrix(A, 1, 0)
    // Then determinant(B) = 25 And minor(A, 1, 0) = 25
    func testCalculatingAMinorOfA3x3Matrix() {
        let A = Matrix([3,5,0,2,-1,-7,6,-1,5], rows: 3, columns: 3)
        let B = A.submatrix(rowToOmit: 1, colToOmit: 0)
        XCTAssertEqual(B.determinant(), 25)
        XCTAssertEqual(A.minor(row: 1, column: 0), 25)
    }
    
    // Scenario: Calculating a cofactor of a 3x3 matrix
    // Given the following 3x3 matrix A:|3|5|0||2|-1|-7||6|-1|5|
    // Then minor(A, 0, 0) = -12 And cofactor(A, 0, 0) = -12
    // And minor(A, 1, 0) = 25 And cofactor(A, 1, 0) = -25
    func testCalculatingACofactorOfA3x3Matrix() {
        let A = Matrix([3,5,0,2,-1,-7,6,-1,5], rows: 3, columns: 3)
        XCTAssertEqual(A.minor(row: 0, column: 0), -12)
        XCTAssertEqual(A.cofactor(row: 0, column: 0), -12)
        XCTAssertEqual(A.minor(row: 1, column: 0), 25)
        XCTAssertEqual(A.cofactor(row: 1, column: 0), -25)
    }
    
    // Scenario: Calculating the determinant of a 3x3 matrix
    // Given the following 3x3 matrix A:|1|2|6||-5|8|-4||2|6|4|
    // Then cofactor(A, 0, 0) = 56 And cofactor(A, 0, 1) = 12
    // And cofactor(A, 0, 2) = -46 And determinant(A) = -196
    func testCalculatingTheDeterminantOfA3x3Matrix() {
        let A = Matrix([1,2,6,-5,8,-4,2,6,4], rows: 3, columns: 3)
        XCTAssertEqual(A.cofactor(row: 0, column: 0), 56)
        XCTAssertEqual(A.cofactor(row: 0, column: 1), 12)
        XCTAssertEqual(A.cofactor(row: 0, column: 2), -46)
        XCTAssertEqual(A.determinant(), -196)
    }
    
    // Scenario: Calculating the determinant of a 4x4 matrix
    // Given the 4x4 matrix A:|-2|-8|3|5||-3|1|7|3||1|2|-9|6||-6|7|7|-9|
    // Then cofactor(A, 0, 0) = 690 And cofactor(A, 0, 1) = 447
    // And cofactor(A, 0, 2) = 210 And cofactor(A, 0, 3) = 51
    // And determinant(A) = -4071
    func testCalculatingTheDeterminantOfA4x4Matrix() {
        let A = Matrix([-2,-8,3,5,-3,1,7,3,1,2,-9,6,-6,7,7,-9], rows: 4, columns: 4)
        XCTAssertEqual(A.cofactor(row: 0, column: 0), 690)
        XCTAssertEqual(A.cofactor(row: 0, column: 1), 447)
        XCTAssertEqual(A.cofactor(row: 0, column: 2), 210)
        XCTAssertEqual(A.cofactor(row: 0, column: 3), 51)
        XCTAssertEqual(A.determinant(), -4071)
    }
    
    // Scenario: Testing an invertible matrix for invertibility
    // Given the 4x4 matrix A:|6|4|4|4||5|5|7|6||4|-9|3|-7||9|1|7|-6|
    // Then determinant(A) = -2120 And A is invertible
    func testAnInvertibleMatrixForInvertibility() {
        let A = Matrix([6,4,4,4,5,5,7,6,4,-9,3,-7,9,1,7,-6], rows: 4, columns: 4)
        XCTAssertEqual(A.determinant(), -2120)
        XCTAssertTrue(A.isInvertible())
    }
    
    // Scenario: Testing a non-invertible matrix for invertibility
    // Given the 4x4 matrix A:|-4|2|-2|-3||9|6|2|6||0|-5|1|-5||0|0|0|0|
    // Then determinant(A) = 0 And A is not invertible
    func testANonInvertibleMatrixForInvertibility() {
        let A = Matrix([-4,2,-2,-3,9,6,2,6,0,-5,1,-5,0,0,0,0], rows: 4, columns: 4)
        XCTAssertEqual(A.determinant(), 0)
        XCTAssertFalse(A.isInvertible())
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
    func testCalculatingTheInverseOfAMatrix() {
        let A = Matrix([-5,2,6,-8,1,-5,1,8,7,7,-6,-7,1,-3,7,4], rows: 4, columns: 4)
        let B = A.inverse()
        XCTAssertEqual(A.determinant(), 532)
        XCTAssertEqual(A.cofactor(row: 2, column: 3), -160)
        XCTAssertEqual(B[3,2], -160/532, accuracy: 0.00001)
        XCTAssertEqual(A.cofactor(row: 3, column: 2), 105)
        XCTAssertEqual(B[2,3], 105/532, accuracy: 0.00001)
        XCTAssertEqual(B[0,0], 0.21805, accuracy: 0.00001)
        XCTAssertEqual(B[0,1], 0.45113, accuracy: 0.00001)
        XCTAssertEqual(B[0,2], 0.24060, accuracy: 0.00001)
        XCTAssertEqual(B[0,3], -0.04511, accuracy: 0.00001)
        XCTAssertEqual(B[1,0], -0.80827, accuracy: 0.00001)
        XCTAssertEqual(B[1,1], -1.45677, accuracy: 0.00001)
        XCTAssertEqual(B[1,2], -0.44361, accuracy: 0.00001)
        XCTAssertEqual(B[1,3], 0.52068, accuracy: 0.00001)
        XCTAssertEqual(B[2,0], -0.07895, accuracy: 0.00001)
        XCTAssertEqual(B[2,1], -0.22368, accuracy: 0.00001)
        XCTAssertEqual(B[2,2], -0.05263, accuracy: 0.00001)
        XCTAssertEqual(B[2,3], 0.19737, accuracy: 0.00001)
        XCTAssertEqual(B[3,0], -0.52256, accuracy: 0.00001)
        XCTAssertEqual(B[3,1], -0.81391, accuracy: 0.00001)
        XCTAssertEqual(B[3,2], -0.30075, accuracy: 0.00001)
        XCTAssertEqual(B[3,3], 0.30639, accuracy: 0.00001)
    }
    
    // Scenario: Calculating the inverse of another matrix
    // Given the 4x4 matrix A:|8|-5|9|2||7|5|6|1||-6|0|9|6||-3|0|-9|-4|
    // Then inverse(A) is the following 4x4 matrix:
    // | -0.15385 | -0.15385 | -0.28205 | -0.53846 |
    // | -0.07692 |  0.12308 |  0.02564 |  0.03077 |
    // |  0.35897 |  0.35897 |  0.43590 |  0.92308 |
    // | -0.69231 | -0.69231 | -0.76923 | -1.92308 |
    func testCalculatingTheInverseOfAnotherMatrix() {
        let A = Matrix([8,-5,9,2,7,5,6,1,-6,0,9,6,-3,0,-9,-4], rows: 4, columns: 4)
        let B = A.inverse()
        XCTAssertEqual(B[0,0], -0.15385, accuracy: 0.00001)
        XCTAssertEqual(B[0,1], -0.15385, accuracy: 0.00001)
        XCTAssertEqual(B[0,2], -0.28205, accuracy: 0.00001)
        XCTAssertEqual(B[0,3], -0.53846, accuracy: 0.00001)
        XCTAssertEqual(B[1,0], -0.07692, accuracy: 0.00001)
        XCTAssertEqual(B[1,1],  0.12308, accuracy: 0.00001)
        XCTAssertEqual(B[1,2],  0.02564, accuracy: 0.00001)
        XCTAssertEqual(B[1,3],  0.03077, accuracy: 0.00001)
        XCTAssertEqual(B[2,0],  0.35897, accuracy: 0.00001)
        XCTAssertEqual(B[2,1],  0.35897, accuracy: 0.00001)
        XCTAssertEqual(B[2,2],  0.43590, accuracy: 0.00001)
        XCTAssertEqual(B[2,3],  0.92308, accuracy: 0.00001)
        XCTAssertEqual(B[3,0], -0.69231, accuracy: 0.00001)
        XCTAssertEqual(B[3,1], -0.69231, accuracy: 0.00001)
        XCTAssertEqual(B[3,2], -0.76923, accuracy: 0.00001)
        XCTAssertEqual(B[3,3], -1.92308, accuracy: 0.00001)
    }
    
    // Scenario: Calculating the inverse of a third matrix
    // Given the 4x4 matrix A:|9|3|0|9||-5|-2|-6|-3||-4|9|6|4||-7|6|6|2|
    // Then inverse(A) is the following 4x4 matrix:
    // | -0.04074 | -0.07778 |  0.14444 | -0.22222 |
    // | -0.07778 |  0.03333 |  0.36667 | -0.33333 |
    // | -0.02901 | -0.14630 | -0.10926 |  0.12963 |
    // |  0.17778 |  0.06667 | -0.26667 |  0.33333 |
    func testCalculatingTheInverseOfAThirdMatrix() {
        let A = Matrix([9,3,0,9,-5,-2,-6,-3,-4,9,6,4,-7,6,6,2], rows: 4, columns: 4)
        let B = A.inverse()
        XCTAssertEqual(B[0,0], -0.04074, accuracy: 0.00001)
        XCTAssertEqual(B[0,1], -0.07778, accuracy: 0.00001)
        XCTAssertEqual(B[0,2],  0.14444, accuracy: 0.00001)
        XCTAssertEqual(B[0,3], -0.22222, accuracy: 0.00001)
        XCTAssertEqual(B[1,0], -0.07778, accuracy: 0.00001)
        XCTAssertEqual(B[1,1],  0.03333, accuracy: 0.00001)
        XCTAssertEqual(B[1,2],  0.36667, accuracy: 0.00001)
        XCTAssertEqual(B[1,3], -0.33333, accuracy: 0.00001)
        XCTAssertEqual(B[2,0], -0.02901, accuracy: 0.00001)
        XCTAssertEqual(B[2,1], -0.14630, accuracy: 0.00001)
        XCTAssertEqual(B[2,2], -0.10926, accuracy: 0.00001)
        XCTAssertEqual(B[2,3],  0.12963, accuracy: 0.00001)
        XCTAssertEqual(B[3,0],  0.17778, accuracy: 0.00001)
        XCTAssertEqual(B[3,1],  0.06667, accuracy: 0.00001)
        XCTAssertEqual(B[3,2], -0.26667, accuracy: 0.00001)
        XCTAssertEqual(B[3,3],  0.33333, accuracy: 0.00001)
    }
    
    // Scenario: Multiplying a product by its inverse
    // Given the 4x4 matrix A:|3|-9|7|3||3|-8|2|-9||-4|4|4|1||-6|5|-1|1|
    // And the 4x4 matrix B:|8|2|2|2||3|-1|7|0||7|0|5|4||6|-2|0|5|
    // And C ← A * B Then C * inverse(B) = A
    func testMultiplyingAProductByItsInverse() {
        let A = Matrix([3,-9,7,3,3,-8,2,-9,-4,4,4,1,-6,5,-1,1], rows: 4, columns: 4)
        let B = Matrix([8,2,2,2,3,-1,7,0,7,0,5,4,6,-2,0,5], rows: 4, columns: 4)
        let C = A * B
        let D = C * B.inverse()
        XCTAssertEqual(D[0,0], A[0,0], accuracy: 0.00001)
        XCTAssertEqual(D[0,1], A[0,1], accuracy: 0.00001)
        XCTAssertEqual(D[0,2], A[0,2], accuracy: 0.00001)
        XCTAssertEqual(D[0,3], A[0,3], accuracy: 0.00001)
        XCTAssertEqual(D[1,0], A[1,0], accuracy: 0.00001)
        XCTAssertEqual(D[1,1], A[1,1], accuracy: 0.00001)
        XCTAssertEqual(D[1,2], A[1,2], accuracy: 0.00001)
        XCTAssertEqual(D[1,3], A[1,3], accuracy: 0.00001)
        XCTAssertEqual(D[2,0], A[2,0], accuracy: 0.00001)
        XCTAssertEqual(D[2,1], A[2,1], accuracy: 0.00001)
        XCTAssertEqual(D[2,2], A[2,2], accuracy: 0.00001)
        XCTAssertEqual(D[2,3], A[2,3], accuracy: 0.00001)
        XCTAssertEqual(D[3,0], A[3,0], accuracy: 0.00001)
        XCTAssertEqual(D[3,1], A[3,1], accuracy: 0.00001)
        XCTAssertEqual(D[3,2], A[3,2], accuracy: 0.00001)
        XCTAssertEqual(D[3,3], A[3,3], accuracy: 0.00001)
    }

}
