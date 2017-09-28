//: Playground - noun: a place where people can play

import UIKit
import CoreImage

var str = "Hello, playground"
/*
 *      封装Core Image 
    Core Image 的 API 是弱类型的 —— 我们通过键值编码 (KVC) 来配置图像滤镜 (filter)。在使用参数的类型或名字时，我们都使用字符串来进行表示，这十分容易出错，极有可能导致运行时错误。而我们开发的新 API 将会利用类型来避免这些原因导致的运行时错误，最终我们将得到一组类型安全而且高度模块化的 API。
 */
//滤镜类型 传入一个图像 并返回一个图像
typealias Filter = (CIImage) -> CIImage
//自定义运算符
infix operator >>> {associativity left}

///高斯模糊滤镜

func blur(_ radius: Double) -> Filter {
    return { image in
        let parameters = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image
        ] as [String : Any]
        guard let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters) else {
            fatalError() //无条件输出给定消息，并停止执行
        }
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        return outputImage
    }
}

///颜色叠层

//固定颜色滤镜
func colorGenerator(_ color: CGColor) -> Filter {
    return {_ in
//        guard let c = CIColor(cgColor: color) else {
//            fatalError()
//        }
        let c = CIColor(cgColor: color)
        let parameters = [kCIInputColorKey: c]
        guard let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters) else {
            fatalError()
        }
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        return outputImage
    }
}

//合成滤镜
func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        guard let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: parameters) else {
            fatalError()
        }
        guard let outputImage = filter.outputImage else {
            fatalError()
        }
        let cropRect = image.extent
        return outputImage.cropping(to: cropRect)
    }
}

//创建颜色叠层滤镜
func colorOverlay(color: CGColor) -> Filter {
    return { image in
        let overlay = colorGenerator(color)(image)
        return compositeSourceOver(overlay: overlay)(image)
    }
}

///组合滤镜
URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil) //设定一个沙箱 用来存缓存数据

let url = URL(string: "http://www.objc.io/images/covers/16.jpg")
let image = CIImage(contentsOf: url!)

let blurRadius = 5.0
let overlayColor = UIColor.red.withAlphaComponent(0.2)
let blurredImage = blur(blurRadius)(image!)
//let overlaidImage = colorOverlay(color: overlayColor.cgColor)(blurredImage)

//复合函数 将一个滤镜叠加到另外一个滤镜上

func >>>(_ filter1: @escaping Filter, _ filter2: @escaping Filter) -> Filter {
    return {image in filter2(filter1(image))}
}
//let myFilter1 = composeFilters(blur(blurRadius), colorOverlay(color: overlayColor.cgColor))
let myFilter1 = blur(blurRadius) >>> colorOverlay(color: overlayColor.cgColor)
//let result1 = myFilter1(image!)

///柯里化 将多参数的函数变成一系列只接受单个参数的函数

//普通函数
func add1(x: Int, y: Int) -> Int {
    return x + y
}
//柯里化
func add2(x: Int) -> (Int) -> Int {
    return {y in x + y}
}
let one = add1(x: 1, y: 2)
let two = add2(x: 1)(2)
let two1 = add2(x: 1)

