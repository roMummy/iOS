import UIKit
import SwiftUI

var greeting = "Hello, playground"

// source: https://xiaozhuanlan.com/topic/9042736581#sectiondsl


// MARK - Result Builder 的运作方式

struct VStack {
    init(@ViewBuilder content: () -> String) {
    }
}

@resultBuilder enum ViewBuilder {
    static func buildBlock(_ components: String...) -> [String] {
        return components
    }
}

//let v0 = Text("title").font(.title).foregroundColor(.green)



protocol Drawable {
    func draw() -> String
}
struct Line: Drawable {
    var elements: [Drawable]
    func draw() -> String {
        return elements.map { $0.draw() }.joined(separator: "")
    }
}
struct Text: Drawable {
    var content: String
    init(_ content: String) { self.content = content }
    func draw() -> String { return content }
}
struct Space: Drawable {
    func draw() -> String { return " " }
}
struct Stars: Drawable {
    var length: Int
    func draw() -> String { return String(repeating: "*", count: length) }
}
struct AllCaps: Drawable {
    var content: Drawable
    func draw() -> String { return content.draw().uppercased() }
}

let name: String? = "Ravi Patel"
let manualDrawing = Line(elements: [
    Stars(length: 3),
    Text("Hello"),
    Space(),
    AllCaps(content: Text((name ?? "World") + "!")),
    Stars(length: 2),
    ])
print(manualDrawing.draw())
// ----  DSL
@resultBuilder
struct DrawingBuilder {
    static func buildBlock(_ components: Drawable...) -> Drawable {
        return Line(elements: components)
    }
    /// if else
    static func buildEither(first component: Drawable) -> Drawable {
        return component
    }
    /// if else
    static func buildEither(second component: Drawable) -> Drawable {
        return component
    }
    /// 支持for
    static func buildArray(_ components: [Drawable]) -> Drawable {
        return Line(elements: components)
    }
}

func draw(@DrawingBuilder content: () -> Drawable) -> Drawable {
    return content()
}
func caps(@DrawingBuilder content: () -> Drawable) -> Drawable {
    return AllCaps(content: content())
}
func makeGreeting(for name: String? = nil) -> Drawable {
    let greeting = draw {
        Stars(length: 3)
        Text("Hello")
        Space()
        caps {
            if let name = name {
                Text(name + "!")
            } else {
                Text("World!")
            }
        }
        Stars(length: 2)
    }
    return greeting
}

let manyStars = draw {
    Text("Stars:")
    for length in 1...3 {
        Space()
        Stars(length: length)
    }
}


let genericGreeting = makeGreeting()
print(genericGreeting.draw())
print(manyStars.draw())


// MARK: - 设计一个DSL

struct Smoothie {}

@resultBuilder
enum SmoothieArrayBuiler {
    static func buildBlock(_ components: [Smoothie]...) -> [Smoothie] {
        return components.flatMap{$0}
    }
    // if ... else
    static func buildOptional(_ component: [Smoothie]?) -> [Smoothie] {
        return component ?? []
    }
    // if else ...
    static func buildEither(first component: [Smoothie]) -> [Smoothie] {
        return component
    }
    // if else ...
    static func buildEither(second component: [Smoothie]) -> [Smoothie] {
        return component
    }
    static func buildExpression(_ expression: Smoothie) -> [Smoothie] {
        return [expression]
    }
    static func buildExpression(_ expression: Void) -> [Smoothie] {
        return []
    }
}

@resultBuilder
enum IngredientsBuilder {
    static func buildBlock(_ description: NSAttributedString, _ components: String...) -> (NSAttributedString, [String]) {
        return (description, components)
    }
}

@SmoothieArrayBuiler
func all(includingPaid: Bool = true) -> [Smoothie] {
    let v0 = SmoothieArrayBuiler.buildExpression(Smoothie())
    let v1 = SmoothieArrayBuiler.buildExpression(Smoothie())

    var v2: [Smoothie]
    if includingPaid {
        print("")
        let v2_0 = SmoothieArrayBuiler.buildExpression(Smoothie())
        let v2_1 = SmoothieArrayBuiler.buildExpression(Smoothie())
        let  v2_block = SmoothieArrayBuiler.buildBlock(v2_1, v2_0)
        v2 = SmoothieArrayBuiler.buildEither(first: v2_block)
    } else {

        v2 = SmoothieArrayBuiler.buildEither(second: [])
    }

    return SmoothieArrayBuiler.buildBlock(v0, v1, v2)
}
@SmoothieArrayBuiler
func alls(includingPaid: Bool = true) -> [Smoothie] {
    Smoothie()
    Smoothie()
    if includingPaid {
        Smoothie()
    } else {
        Smoothie()
    }
}


print("hello")






