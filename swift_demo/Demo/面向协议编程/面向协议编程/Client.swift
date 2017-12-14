//
//  Client.swift
//  面向协议编程
//
//  Created by TW on 2017/12/11.
//  Copyright © 2017年 TW. All rights reserved.
//

import Foundation

protocol Client {
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void)  //发送
    
    var host: String {get}
}


struct URLSessionClient: Client {
    
    let host: String = "https://api.onevcat.com"
    
    func send<T>(_ r: T, handler: @escaping (T.Response?) -> Void) where T : Request {
        let url = URL(string: host.appending(r.path))!
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            print(data ?? "nil")
            if let data = data, let res = T.Response.parse(data: data) {
                DispatchQueue.main.async {handler(res)}
            }else {
                DispatchQueue.main.async {handler(nil)}
            }
        }
        task.resume()
    }
    
}
