import UIKit

var str = "Hello, playground"
/// 延迟调用 多个defer会逆序执行 栈  在最后释放资源

func test() {
    defer {
        print("1")
    }
    defer {
        print("2")
    }
    defer {
        print("3")
    }
    print("out")
}
test()

print("aaa")
defer {
    print("sss")
    defer {
        print("hhh")
    }
}
print("bbb")
