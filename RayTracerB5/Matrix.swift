//
//  Matrix.swift
//  RayTracerB4
//
//  Created by Stein Alver on 15/11/2018.
//  Copyright © 2018 Stein Alver. All rights reserved.
//

import Foundation
import Accelerate

class Matrix: CustomStringConvertible, Equatable {
    
    internal var data:Array<Float>
    
    var rows: Int
    var columns: Int
    
    var size: Int {
        get {
            return rows * columns
        }
    }
    
    var description: String {
        
        var d = ""
        for row in 0..<rows {
            
            for col in 0..<columns {
                
                let s = String(self[row,col])
                d += s + " "
            }
            
            d += "\n"
        }
        return d
    }
    
    init(_ data:Array<Float>, rows:Int, columns:Int) {
        self.data = data
        self.rows = rows
        self.columns = columns
    }
    
    init(rows:Int, columns:Int) {
        self.data = [Float](repeating: 0.0, count: rows*columns)
        self.rows = rows
        self.columns = columns
    }
    
    func copy(with zone: NSZone? = nil) -> Matrix {
        let m = Matrix(self.data, rows:self.rows, columns:self.columns)
        return m
    }
    
    
    subscript(row: Int, col: Int) -> Float {
        get {
            precondition(row >= 0 && col >= 0 && row < self.rows && col < self.columns, "Index out of bounds")
            return data[(row * columns) + col]
        }
        
        set {
            precondition(row >= 0 && col >= 0 && row < self.rows && col < self.columns, "Index out of bounds")
            self.data[(row * columns) + col] = newValue
        }
    }
    
    
    func row(index:Int) -> [Float] {
        
        var r = [Float]()
        for col in 0..<columns {
            r.append(self[index,col])
        }
        return r
    }
    
    
    func col(index:Int) -> [Float] {
        var c = [Float]()
        for row in 0..<rows {
            c.append(self[row,index])
        }
        return c
    }
    
    func clear() {
        self.data = [Float](repeating: 0.0, count: self.rows * self.columns)
        self.rows = 0
        self.columns = 0
    }
    
    class func identity() -> Matrix {
        let I = Matrix([1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1], rows: 4, columns: 4)
        return I
    }
    
    func submatrix(rowToOmit: Int, colToOmit: Int) -> Matrix {
        
        var data : Array<Float> = Array()
        var rowdata : Array<Float> = Array()
        
        for idx in 0..<rows {
            rowdata = self.row(index: idx)
            rowdata.remove(at: colToOmit)
            
            if (idx == rowToOmit) {
                
            } else {
                data = data + rowdata
            }
        }
        
        let sub = Matrix(data, rows: self.rows - 1, columns: self.columns - 1)
        return sub
    }
    
    func determinant() -> Float {
        var det : Float = 0
        
        if (self.columns == 2) && (self.rows == 2) {
            det = self[0,0] * self[1,1] - self[0,1] * self[1,0]
        } else {
            let mcp = self.copy()
            var idx: Int = 0
            for num in mcp.row(index: 0) {
                det = det + num * mcp.cofactor(row: 0, column: idx)
                idx = idx + 1
            }
        }
        return det
    }
    
    func minor(row: Int, column: Int) -> Float {
        let sub = self.submatrix(rowToOmit: row, colToOmit: column)
        return sub.determinant()
    }
    
    func cofactor(row: Int, column: Int) -> Float {
        let sub = self.submatrix(rowToOmit: row, colToOmit: column)
        var cofact = sub.determinant()
        
        if (row + column) % 2 == 1 {
            cofact = -cofact
        }
        return cofact
    }
    
    func isInvertible() -> Bool {
        if self.determinant() == 0 {
            return false
        }
        return true
    }
    
    func inverse() -> Matrix {
        // create a matrix that consists of the cofactors of each of the original elements
        // transpose that cofactor matrix
        // divide each of the resulting elements by the determinant of the original matrix
        let m = Matrix(rows: self.rows, columns: self.columns)
        for row in 0..<self.rows {
            for col in 0..<self.columns {
                m[row,col] = self.cofactor(row: row, column: col)
            }
        }
        let t = m^
        let i = Matrix(t.data, rows: t.rows, columns: t.columns)
        
        let det = self.determinant()
        if det == 0 {
            fatalError()
        } else {
            for row in 0..<i.rows {
                for col in 0..<i.columns {
                    i[row,col] = i[row,col] / det
                }
            }
        }
        
        return i
    }
    
    class func translation(x: Float, y: Float, z: Float) -> Matrix {
        let M = Matrix.identity()
        M[0,3] = x
        M[1,3] = y
        M[2,3] = z
        return M
    }
    
    class func scaling(x: Float, y: Float, z: Float) -> Matrix {
        let M = Matrix.identity()
        M[0,0] = x
        M[1,1] = y
        M[2,2] = z
        return M
    }
    
    class func rotation_x(r: Float) -> Matrix {
        let M = Matrix.identity()
        M[1,1] = cos(r)
        M[1,2] = -sin(r)
        M[2,1] = sin(r)
        M[2,2] = cos(r)
        return M
    }
    
    class func rotation_y(r: Float) -> Matrix {
        let M = Matrix.identity()
        M[0,0] = cos(r)
        M[0,2] = sin(r)
        M[2,0] = -sin(r)
        M[2,2] = cos(r)
        return M
    }
    
    class func rotation_z(r: Float) -> Matrix {
        let M = Matrix.identity()
        M[0,0] = cos(r)
        M[0,1] = -sin(r)
        M[1,0] = sin(r)
        M[1,1] = cos(r)
        return M
    }
    
    class func shearing(xy: Float, xz: Float, yx: Float, yz: Float, zx: Float, zy: Float) -> Matrix {
        let M = Matrix.identity()
        M[0,1] = xy
        M[0,2] = xz
        M[1,0] = yx
        M[1,2] = yz
        M[2,0] = zx
        M[2,1] = zy
        return M
    }
    
    class func viewTransform(from: Point, to: Point, up: Vector) -> Matrix {
        let forward = (to - from).normalize()
        let left = forward.cross(up.normalize())
        let true_up = left.cross(forward)
        let orientation = Matrix([left.x, left.y, left.z, 0, true_up.x, true_up.y, true_up.z, 0, -forward.x, -forward.y, -forward.z, 0, 0, 0, 0, 1], rows: 4, columns: 4)
        return orientation * Matrix.translation(x: -from.x, y: -from.y, z: -from.z)
    }
}

// MARK: Matrix Operations
func +(left: Matrix, right: Matrix) -> Matrix {
    
    precondition(left.rows == right.rows && left.columns == right.columns)
    
    let m = Matrix(left.data, rows: left.rows, columns: left.columns)
    
    for row in 0..<left.rows {
        
        for col in 0..<left.columns {
            
            m[row,col] += right[row,col]
            
        }
    }
    return m
}

func -(left: Matrix, right: Matrix) -> Matrix {
    
    precondition(left.rows == right.rows && left.columns == right.columns)
    
    let m = Matrix(left.data, rows: left.rows, columns: left.columns)
    
    for row in 0..<left.rows {
        
        for col in 0..<left.columns {
            
            m[row,col] -= right[row,col]
            
        }
    }
    return m
}

func *(lhs: Matrix, rhs: Tuple) -> Tuple {
    let x = lhs[0,0] * rhs.x + lhs[0,1] * rhs.y + lhs[0,2] * rhs.z + lhs[0,3] * rhs.w
    let y = lhs[1,0] * rhs.x + lhs[1,1] * rhs.y + lhs[1,2] * rhs.z + lhs[1,3] * rhs.w
    let z = lhs[2,0] * rhs.x + lhs[2,1] * rhs.y + lhs[2,2] * rhs.z + lhs[2,3] * rhs.w
    let w = lhs[3,0] * rhs.x + lhs[3,1] * rhs.y + lhs[3,2] * rhs.z + lhs[3,3] * rhs.w
    
    let t = Tuple(x: x, y: y, z: z, w: w)
    return t
}


func *(left:Matrix, right:Float) -> Matrix {
    return Matrix(left.data * right, rows: left.rows, columns: left.columns)
}

func *(left:Float, right:Matrix) -> Matrix {
    return right * left
}

func *(left:Matrix, right:Matrix) -> Matrix {
    
    var lcp = left.copy()
    var rcp = right.copy()
    
    if (lcp.rows == 1 && rcp.rows == 1) && (lcp.columns == rcp.columns) { // exception for single row matrices (inspired by numpy)
        rcp = rcp^
    }
    else if (lcp.columns == 1 && rcp.columns == 1) && (lcp.rows == rcp.rows) { // exception for single row matrices (inspired by numpy)
        lcp = lcp^
    }
    
    guard lcp.columns == rcp.rows else {
        fatalError("These matrices cannot be multipied")
    }
    
    let dot = Matrix(rows:lcp.rows, columns:rcp.columns)
    
    for rindex in 0..<lcp.rows {
        
        for cindex in 0..<rcp.columns {
            
            let a = lcp.row(index: rindex) ** rcp.col(index: cindex)
            dot[rindex,cindex] = a
        }
    }
    
    return dot
}

func ==(left:Matrix, right:Matrix) -> Bool {
    return left.data == right.data
}


// Transpose
postfix operator ^

postfix func ^(m:Matrix) -> Matrix {
    let transposed = Matrix(rows:m.columns, columns:m.rows)
    for row in 0..<m.rows {
        for col in 0..<m.columns {
            transposed[col,row] = m[row,col]
        }
    }
    return transposed
}

typealias SAVector = [Float]

func *(left:SAVector, right:SAVector) -> SAVector {
    var d = [Float]()
    for i in 0..<left.count {
        d.append(left[i] * right[i])
    }
    return d
}

func *(left:SAVector, right:Float) -> SAVector {
    var d = [Float]()
    for i in 0..<left.count {
        d.append(left[i] * right)
    }
    return d
}

func *(left:Float, right:SAVector) -> SAVector {
    return right * left
}

infix operator **

func **(left:SAVector, right:SAVector) -> Float {
    
    precondition(left.count == right.count)
    
    var d : Float = 0
    for i in 0..<left.count {
        d += left[i] * right[i]
    }
    return d
    /* Comment out for Accelerated
     var d: Double = 0.0
     vDSP_dotprD(left, 1, right, 1, &d, vDSP_Length(left.count))
     return d
     */
}


