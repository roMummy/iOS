//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

/*
 *      解析器组合算子
 */

struct Parser<Token, Result>{
    let p: (ArraySlice<Token>) -> AnySequence<(Result, ArraySlice<Token>)>//传入一个符号数组的切片，返回一个包含处理结果和剩余符号的多元组
}


func parseA() -> Parser<Character, Character> {
    let a: Character = "a"
    return Parser{x in        
        guard let (head, tail) = x, head == a else {
            return none()
        }
        return one(x: tail)
    }
    
}

//生成一个序列
func one<A>(x: A) -> AnySequence<A> {
    return AnySequence(IteratorOverOne(_elements: x))
}
//空序列
func none<T>() -> AnySequence<T> {
    return AnySequence(AnyIterator{nil})
}

let three = Array(IteratorOverOne(_elements: 3))
print(three)
