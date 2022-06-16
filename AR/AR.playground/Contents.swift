import UIKit
import Foundation
import simd

var greeting = "Hello, playground"


struct Line {
    var position = simd_float3.zero
    var direction = simd_float3.zero
}

struct Plane {
    var position = simd_float3.zero
    var normal = simd_float3.zero
}

/// 点到横线的距离
func distance(point: simd_float3, line: Line) -> Float {

    let tarPoint = projectionOnLine(point: point, line: line)
    // 点在是否在直线上
    let disVector = point - tarPoint
    if length_squared(disVector) < 0.001 {
        return 0
    }
    // 利用点乘 投影求距离
//    return dot(vector, normalize(disVector))
    return distance_squared(tarPoint, point)
}

/// 点到横线的垂直投影点
func projectionOnLine(point: simd_float3, line: Line) -> simd_float3 {
    // 点到横线上的垂直投影点
    let vector = point - line.position
    let normalizedDirection = normalize(line.direction)
    let dotValue = dot(vector, normalizedDirection)
    let tarPoint = line.position + dotValue*normalizedDirection
    return tarPoint
}
/// 点是否在直线上
func isPointOnline(point: simd_float3, line: Line) -> Bool {
    let tarPoint = projectionOnLine(point: point, line: line)
    return distance_squared(tarPoint, point) < 0.0001
}
/// 叉乘
func isPointOnline1(point: simd_float3, line: Line) -> Bool {
    let vector = point - line.position
    let crossValue = cross(vector, line.direction)
    return length_squared(crossValue) < 0.0001
}

// MARK: - 平面
func distanceBetween(point: simd_float3, plane: Plane) -> Float {
    let vector = point - plane.position
    let dotValue = dot(vector, normalize(plane.normal))
    return dotValue
}



//extension Array {
//    subscript(safa idx: Int) -> Element? {
//        return idx < endIndex ? self[idx] : nil
//    }
//}
//
//let aaa: [Int] = [1,2,3,4]
//
//aaa[safa: 5]
//aaa[5]
