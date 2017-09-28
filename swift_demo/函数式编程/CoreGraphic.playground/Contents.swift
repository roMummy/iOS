//: Playground - noun: a place where people can play

import UIKit
import CoreGraphics


var str = "Hello, playground"
/*
 *      图表
 */

//class Draw: UIView {
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        guard let context = UIGraphicsGetCurrentContext() else {//获取上下文
//            return
//        }
//        UIColor.blue.setFill()
//        CGContext.fill(context)(CGRect(x: 0.0, y: 37.5, width: 75.0, height: 75.0))
//        UIColor.red.setFill()
//        CGContext.fill(context)(CGRect(x: 75.0, y: 0.0, width: 150.0, height: 150.0))
//        UIColor.green.setFill()
//        CGContext.fill(context)(CGRect(x: 225.0, y: 37.5, width: 75.0, height: 75.0))
//    }
//}



///数据结构

enum Primitive {
    case Ellipse//椭圆
    case Rectangle//矩形
    case Text(String)
}
//属性
enum Attribute {
    case FillColor(UIColor)//填充颜色
}

indirect enum Diagram {
    case Primitive(CGSize, Primitive)//确定尺寸
    case Beside(Diagram, Diagram)//水平方向的图表
    case Below(Diagram, Diagram)//垂直方向的图表
    case Attributed(Attribute, Diagram)//设置图表的样式
    case Align(CGVector, Diagram)//对齐方式
}
//计算图的尺寸
extension Diagram {
    var size: CGSize {
        switch self {
        case .Primitive(let size, _):
            return size
        case .Attributed(_, let x):
            return x.size
        case .Beside(let l, let r)://水平方向宽度相加，高度取最大的高度
            let sizeL = l.size
            let sizeR = r.size
            return CGSize(width: sizeL.width + sizeR.width, height: max(sizeL.height, sizeR.height))
        case .Below(let l, let r)://垂直方向高度相加，宽度取最大的宽度
            return CGSize(width: max(l.size.width, r.size.width), height: l.size.height + r.size.height)
        case .Align(_, let x):
            return x.size
        }
    }
    
}

//CGSize CGPoint 计算符

func *(l: CGFloat, r: CGSize) -> CGSize {
    return CGSize(width: l * r.width, height: l * r.height)
}
func /(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width / r.width, height: l.height / r.height)
}
func *(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width * r.width, height: l.height * r.height)
}
func -(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width - r.width, height: l.height - r.height)
}
func -(l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(x: l.x - r.x, y: l.y - r.y)
}

extension CGSize {
    var point: CGPoint {
        return CGPoint(x: self.width, y: self.height)
    }
}
extension CGVector {
    var point: CGPoint {return CGPoint(x: dx, y: dy)}
    var size: CGSize {return CGSize(width: dx, height: dy)}
}

extension CGSize {
    //成比例的图表
    func fit(_ vector: CGVector, _ rect: CGRect) -> CGRect {
        let scaleSize = rect.size / self
        let scale = min(scaleSize.width, scaleSize.height)
        let size = scale * self
        let space = vector.size * (size - rect.size)
        return CGRect(origin: rect.origin - space.point, size: size)
        
    }
}

let fitCenter = CGSize(width: 1, height: 1).fit(CGVector.init(dx: 0.5, dy: 0.5), CGRect(x: 0, y: 0, width: 200, height: 100))
print(fitCenter)

extension CGRectEdge {
    var isHorizontal: Bool {
        return self == .maxXEdge || self == .minXEdge
    }
}

//根据某个比值来分割CGRect
extension CGRect {
    func split(ratio: CGFloat, edge: CGRectEdge) -> (CGRect, CGRect) {
        let length = edge.isHorizontal ? width : height
        return divided(atDistance: length*ratio, from: edge)//划分
    }
}

//画图
extension CGContext {
    func draw(_ bounds: CGRect, _ diagram: Diagram) {
        switch diagram {
        case .Primitive(let size, .Ellipse):
            let frame = size.fit(CGVector.init(dx: 0.5, dy: 0.5), bounds)
            CGContext.fillEllipse(self)(in: frame)
        case .Primitive(let size, .Rectangle):
            let frame = size.fit(CGVector.init(dx: 0.5, dy: 0.5), bounds)
            CGContext.fill(self)(frame)
        case .Primitive(let size, .Text(let text)):
            let frame = size.fit(CGVector.init(dx: 0.5, dy: 0.5), bounds)
            let font = UIFont.systemFont(ofSize: 14)
            let attributes = [NSFontAttributeName: font]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.draw(in: frame)
        case .Attributed(.FillColor(let color), let d):
            CGContext.saveGState(self)
            color.set()
            draw(bounds, d)
            CGContext.restoreGState(self)
        case .Beside(let left, let right):
            let (lFrame, rFrame) = bounds.split(ratio: left.size.width / diagram.size.width, edge: .minXEdge)
            draw(lFrame, left)
            draw(rFrame, right)
        case .Below(let top, let bottom):
            let (lFrame, rFrame) = bounds.split(ratio: bottom.size.height / diagram.size.height, edge: .minYEdge)
            draw(lFrame, top)
            draw(rFrame, bottom)
        case .Align(let vec, let diagram):
            let frame = diagram.size.fit(vec, bounds)
            draw(frame, diagram)
        }
    }
}

extension Sequence where Iterator.Element == CGFloat {
    //比例
    func normalize() -> [CGFloat] {
        let maxVal = self.reduce(0) { Swift.max($0, $1) }
        return self.map { $0 / maxVal }
    }
}

//绘制view
class Draw: UIView {
    let diagram: Diagram
    
    init(frame: CGRect, diagram: Diagram) {
        self.diagram = diagram
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let content = UIGraphicsGetCurrentContext() else {//获取上下文
            return
        }
        content.draw(self.bounds, diagram)
    }
}

///组合算子 选定一小部分核心的数据类型和函数，然后在它们之上构建一些便利函数

//矩形
func rect(width: CGFloat, height: CGFloat) -> Diagram {
    return .Primitive(CGSize.init(width: width, height: height), .Rectangle)
}

//圆形
func circle(diameter: CGFloat) -> Diagram {
    return .Primitive(CGSize.init(width: diameter, height: diameter), .Ellipse)
}

//文字
func text(theText: String, width: CGFloat, height: CGFloat) -> Diagram {
    return .Primitive(CGSize.init(width: width, height: height), .Text(theText))
}

//正方形
func square(side: CGFloat) -> Diagram {
    return rect(width: side, height: side)
}

//左右相邻
infix operator ||| {associativity left} //居中使用，左结合
func |||(l: Diagram, r: Diagram) -> Diagram {
    return Diagram.Beside(l, r)
}
//垂直相邻
infix operator --- {associativity left}
func ---(l: Diagram, r: Diagram) -> Diagram {
    return Diagram.Below(l, r)
}

extension Diagram {
    //填充
    func fill(color: UIColor) -> Diagram {
        return .Attributed(.FillColor(color), self)
    }
    //对齐方式
    func alignTop() -> Diagram {
        return .Align(CGVector.init(dx: 0.5, dy: 1), self)
    }
    func alignBottom() -> Diagram {
        return .Align(CGVector.init(dx: 0.5, dy: 0), self)
    }
}

///水平连接一组图
//定义一个空图
let empty: Diagram = rect(width: 0, height: 0)
func hcat(diagrams: [Diagram]) -> Diagram {
    return diagrams.reduce(empty, |||)
}

func barGraph(input: [(String, Double)]) -> Diagram {
    let values: [CGFloat] = input.map{CGFloat($0.1)}//将double类型转换成CGFloat
    let nValues = values.normalize()//获取每个元素对应的比例值
    let bars = hcat(diagrams: nValues.map({ (x: CGFloat) -> Diagram in
        return rect(width: 1, height: 3*x).fill(color: .black).alignBottom()
    }))//画图
    let labels = hcat(diagrams: input.map({ x in
        return text(theText: x.0, width: 1, height: 0.3).alignTop()
    }))//画文字
    return bars --- labels//垂直组成在一起
}

let cities = [
    ("Shanghai", 14.01),
    ("Istanbul", 13.3),
    ("Moscow", 10.56),
    ("New York", 8.33),
    ("Berlin", 3.43)
]
let example3 = barGraph(input: cities)


