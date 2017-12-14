//
//  Request.swift
//  面向协议编程
//
//  Created by TW on 2017/12/11.
//  Copyright © 2017年 TW. All rights reserved.
//

import Foundation

protocol Deccodable {   //数据解析协议
    static func parse(data: Data) -> Self?
}

enum HTTPMethod: String {
    case GET
    case POST
}
protocol Request {
    associatedtype Response: Deccodable  //占位
    
    var path: String {get}
    
    var method: HTTPMethod {get}
    var parameter: [String : Any] {get}
    
}


struct UserRequest: Request {
    
    typealias Response = User
    
    
    let name: String
    
    var path: String{
        return "/users/\(name)"
    }
    
    let method: HTTPMethod = .GET
    
    let parameter: [String : Any] = [:]
}
