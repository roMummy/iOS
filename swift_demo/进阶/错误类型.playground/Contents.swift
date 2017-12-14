//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

///Result 类型

/**
 “Result 类型和可选值非常相似。可选值其实就是有两个成员的枚举：一个不包含关联值的 .none 或者 nil，以及一个包含关联值的 some。Result 类型也是两个成员组成的枚举：一个代表失败的情况，并关联了具体的错误值；另一个代表成功的情况，它也关联了一个值”
 */
enum Result<A>{
    case failure(Error)
    case success(A)
}
//func contentsOrNil(ofFile filename: String) -> String? //这种方式不能获取到失败的具体原因

enum FileError: Error {
    case fileDoesNotExist
    case noPermisson
}
//func contents(ofFile filename: String) -> Result<String>{
//    return Result.failure(.fileDoesNotExist)
//}  //必须返回错误类型
//let result = contents(ofFile: "input.txt")
//switch result {
//case .success(let contents):
//    print(contents)
//    break
//case .failure(let error):
//    if let fileError = error as? FileError,
//        fileError == .fileDoesNotExist {
//        print("file not found")
//    }else {
//
//    }
//    break
//}

///捕获和抛出

func contents(ofFile filename: String) throws -> String {return ""}

do {
    let result_try = try contents(ofFile: "input.txt")
    print(result_try)
} catch FileError.fileDoesNotExist {
    print("file not found")
} catch {
    print(error)
}

///带有类型的错误

//enum Result<A, ErrorType: Error>{
//    case failure(ErrorType)
//    case success(A)
//}

//func parse(text: String) -> Result<[String], FileError>

func setupServerConnection() throws {}

try setupServerConnection()

///将错误桥接到OC
//扩展 CustomNSError
extension FileError: CustomNSError {
    static let errorDomain = "io.objc.parseError"
    var errorCode: Int {
        switch self {
        case .fileDoesNotExist:
            return 100
        default:
            return 200
        }
    }
    var errorUserInfo: [String : Any] {
        return [:]
    }
}

///错误和函数参数
func checkFile(filename: String)throws -> Bool{return false}

func checkAllFile(filenames: [String])throws -> Bool{
    for filename in filenames {
        guard try checkFile(filename: filename) else {
            return false
        }
    }
    return true
}

//func checkPrimes(_ numbers: [Int]) -> Bool {
//    for number in numbers {
//        guard number.isPrime else {
//            return false
//        }
//    }
//    return true
//}

///Rethrows 函数只会在它的参数函数抛出错误的时候抛出错误
extension Sequence {
    func all(condition: (Iterator.Element)throws -> Bool)rethrows -> Bool {
        for element in self {
            guard try condition(element) else {
                return false
            }
        }
        return true
    }
}
func checkAllFiles(filenames: [String])throws -> Bool {
    return try filenames.all(condition: checkFile)
}

///使用defer进行清理 与finally差不多 defer不需要之前出现try或者do这样的语句  多个defer时，逆序执行 每个作用域结束就执行defer

func contentsDefer(ofFile fileName: String)throws -> String {
    let file = open("test.txt", O_RDONLY)
    defer {
        close(file)
    }
    let contents = "\(file)"
    return contents
}

///错误和可选值
//错误->可选值 我们可以使用try？来忽略throws函数返回的错误 只返回nil或者成功的信息
//可选值->错误
enum ReadIntError: Error {
    case couldNotRead
}
extension Optional {
    func or(error: Error)throws -> Wrapped {
        switch self {
        case let x?:
            return x
        case nil:
            throw error
        }
    }
}

do {
    let int = try Int("a").or(error: ReadIntError.couldNotRead)
} catch {
    print(error)
}

///错误链
func checkFilesAndFetchProcessID(filenames: [String]) -> Int {
    do {
        try filenames.all(condition: checkFile)
        let pidString = try contents(ofFile: "pidfile")
        return try Int(pidString).or(error: ReadIntError.couldNotRead)
    } catch {
        return 42
    }
}

///链接果
extension Result {
    func flatMap<B>(transform: (A) -> Result<B>) -> Result<B>{
        switch self {
        case .failure(let m):return .failure(m)
        case .success(let x):return transform(x)
        }
    }
}
//错误链的新写法
//func checkFilesAndFetchProcessID(filenames: [String]) -> Result<Int> {
//    return filenames
//        .all(condition: checkFile)
//        .flatMap { _ in contents(ofFile: "Pidfile") }
//        .flatMap { contents in
//            Int(contents).map(Result.success)
//                ?? .failure(ReadIntError.couldNotRead)
//    }
//}

///高阶函数和错误
func compute(callback: (Int) -> Void){}
compute { result in
    print(result)
}
//可选值
func computeOprional(callback: (Int?) -> Void){}
computeOprional { result in
    print(result ?? 0)
}
//throws 回调函数可能会失败
func computeThrows(callback: (Int)throws -> Void){}

//正确方式
func computeResult(callback: (Result<Int>) -> Void){}
func compute(callback: (()throws -> Int) -> Void) {}
compute { (resultFunc: ()throws -> Int) in
    do {
        let result = try resultFunc()
    } catch  {
        print(error)
    }
}




