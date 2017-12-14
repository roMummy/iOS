//
//  User.swift
//  面向协议编程
//
//  Created by TW on 2017/12/11.
//  Copyright © 2017年 TW. All rights reserved.
//

import Foundation

struct User {
    let name: String
    let message: String
    
    init?(data: Data) {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        guard let name = obj?["name"] as? String else {
            return nil
        }
        guard let message = obj?["message"] as? String else {
            return nil
        }
        self.name = name
        self.message = message
    }    
}
extension User: Deccodable {    //数据解析
    static func parse(data: Data) -> User? {
        return User(data: data)
    }
}



