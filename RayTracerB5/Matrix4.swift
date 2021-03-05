//
//  Matrix4.swift
//  RayTracerB5
//
//  Created by Stein Alver on 04/03/2021.
//  Copyright © 2021 Stein Alver. All rights reserved.
//

import Foundation
import simd

postfix operator ^ 
class Matrix4: CustomStringConvertible, Equatable {
    var matrix: simd_double4x4
    
    init(row0: simd_double4, row1: simd_double4, row2: simd_double4, row3: simd_double4) {
        self.matrix = simd_matrix_from_rows(row0, row1, row2, row3)
    }
    
    init(matrix: simd_double4x4) {
        self.matrix = matrix
    }
    
    public var description: String {
        get {
            return "Matrix4 = (\(self.matrix[0][0])  \(self.matrix[1][0])  \(self.matrix[2][0])  \(self.matrix[3][0]))  " +
            "(\(self.matrix[0][1])  \(self.matrix[1][1])  \(self.matrix[2][1])  \(self.matrix[3][1]))  " +
            "(\(self.matrix[0][2])  \(self.matrix[1][2])  \(self.matrix[2][2])  \(self.matrix[3][2]))  " +
            "(\(self.matrix[0][3])  \(self.matrix[1][3])  \(self.matrix[2][3])  \(self.matrix[3][3]))"
        }
    }
    
    class func identity() -> Matrix4 {
        return Matrix4(matrix: matrix_identity_double4x4)
    }
    
    subscript(row: Int, col: Int) -> Double {
        get {
            precondition(row >= 0 && col >= 0 && row < 4 && col < 4, "Index out of bounds")
            return self.matrix[col][row]
        }
        
        set {
            precondition(row >= 0 && col >= 0 && row < 4 && col < 4, "Index out of bounds")
            self.matrix[col][row] = newValue
        }
    }

        
    static func == (lhs: Matrix4, rhs: Matrix4) -> Bool {
        let epsilon : Double = 0.0002
        return simd_almost_equal_elements(lhs.matrix, rhs.matrix, epsilon)
    }
    
    func determinant() -> Double {
        return simd_determinant(self.matrix)
    }
    
    func inverse() -> Matrix4 {
        return Matrix4(matrix: simd_inverse(self.matrix))
    }
    
    static func +(left: Matrix4, right: Matrix4) -> Matrix4 {
        return Matrix4(matrix: left.matrix + right.matrix)
    }

    static func -(left: Matrix4, right: Matrix4) -> Matrix4 {
        return Matrix4(matrix: left.matrix - right.matrix)
    }

    static func *(left: Matrix4, right: Matrix4) -> Matrix4 {
        return Matrix4(matrix: left.matrix * right.matrix)
    }

    static func *(left: Matrix4, right: Double) -> Matrix4 {
        return Matrix4(matrix: simd_mul(right, left.matrix))
    }

    static func *(left: Double, right: Matrix4) -> Matrix4 {
        return Matrix4(matrix: simd_mul(left, right.matrix))
    }

    static func *(left: Matrix4, right: Tuple) -> Tuple {
        return Tuple(vector: simd_mul(left.matrix, right.vector4))
    }

    static postfix func ^(m:Matrix4) -> Matrix4 {
        return Matrix4(matrix: simd_transpose(m.matrix))
    }

    class func translation(x: Double, y: Double, z: Double) -> Matrix4 {
        let M = Matrix4.identity()
        M[0,3] = x
        M[1,3] = y
        M[2,3] = z
        return M
    }
    
    class func scaling(x: Double, y: Double, z: Double) -> Matrix4 {
        let M = Matrix4.identity()
        M[0,0] = x
        M[1,1] = y
        M[2,2] = z
        return M
    }
    
    class func rotation_x(r: Double) -> Matrix4 {
        let M = Matrix4.identity()
        M[1,1] = cos(r)
        M[1,2] = -sin(r)
        M[2,1] = sin(r)
        M[2,2] = cos(r)
        return M
    }
    
    class func rotation_y(r: Double) -> Matrix4 {
        let M = Matrix4.identity()
        M[0,0] = cos(r)
        M[0,2] = sin(r)
        M[2,0] = -sin(r)
        M[2,2] = cos(r)
        return M
    }
    
    class func rotation_z(r: Double) -> Matrix4 {
        let M = Matrix4.identity()
        M[0,0] = cos(r)
        M[0,1] = -sin(r)
        M[1,0] = sin(r)
        M[1,1] = cos(r)
        return M
    }
    
    class func shearing(xy: Double, xz: Double, yx: Double, yz: Double, zx: Double, zy: Double) -> Matrix4 {
        let M = Matrix4.identity()
        M[0,1] = xy
        M[0,2] = xz
        M[1,0] = yx
        M[1,2] = yz
        M[2,0] = zx
        M[2,1] = zy
        return M
    }
    
    class func viewTransform(from: Point, to: Point, up: Vector) -> Matrix4 {
        let forward = (to - from).normalize()
        let left = forward.cross(up.normalize())
        let true_up = left.cross(forward)
        let orientation = Matrix4(row0: simd_double4(left.x, left.y, left.z, 0),
                                  row1: simd_double4(true_up.x, true_up.y, true_up.z, 0),
                                  row2: simd_double4(-forward.x, -forward.y, -forward.z, 0),
                                  row3: simd_double4(0, 0, 0, 1))
    
        return orientation * Matrix4.translation(x: -from.x, y: -from.y, z: -from.z)
    }
}
