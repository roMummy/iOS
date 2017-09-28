//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
/*
 *      下标
 */

struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 2)

print(threeTimesTable[6])

var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
numberOfLegs["bird"] = 2
print(numberOfLegs)

///下标选项
struct Matrix {
    let rows:Int, columns:Int
    var grid:[Double]
    init(rows:Int, columns:Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating:0.0, count:rows * columns)
    }
    func indexIsValidForRow(row:Int, column:Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row:Int, column:Int) -> Double {
        get{
            //断言 满足添加之后才会执行后面的方法 否则就打印提示消息
            assert(indexIsValidForRow(row: row, column: column), "index out of range")
            return grid[(row * columns) + column]
        }
        set{
            assert(indexIsValidForRow(row: row, column: column), "index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

var matrix = Matrix(rows:2, columns:2)
matrix[0,1] = 1.5
matrix[1,0] = 3.2
print(matrix)

		