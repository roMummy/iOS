//
//  UYMarkerURLProtocol.swift
//  UYiFinance
//
//  Created by TW on 2018/1/22.
//  Copyright © 2018年 凤凰. All rights reserved.
//

import UIKit
let hasInitKey = "UYMarkerURLProtocol"
class UYMarkerURLProtocol: URLProtocol {
    //URLSession数据请求任务
    var dataTask:URLSessionDataTask?
    //url请求响应
    var urlResponse: URLResponse?
    //url请求获取到的数据
    var receivedData: NSMutableData?
    
    //子类是否响应该请求
    open override class func canInit(with request: URLRequest) -> Bool {
        if (URLProtocol.property(forKey: hasInitKey, in: request) != nil) {
            return false
        }else {
            return true
        }
    }
    //判断两个请求是否为同一个请求，如果为同一个请求那么就会使用缓存数据。
    //通常都是调用父类的该方法。我们也不许要特殊处理。
    open override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to:b)
    }
    //自定义网络请求
    open override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    //开始网络请求
    override func startLoading() {
        let newRequest = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        //NSURLProtocol接口的setProperty()方法可以给URL请求添加自定义属性。
        //（这样把处理过的请求做个标记，下一次就不再处理了，避免无限循环请求）
        URLProtocol.setProperty(true, forKey: "UYMarkerURLProtocol",
                                in: newRequest)
        
        //使用URLSession从网络获取数据
        let defaultConfigObj = URLSessionConfiguration.default
        let defaultSession = Foundation.URLSession(configuration: defaultConfigObj,
                                                   delegate: self, delegateQueue: nil)
        self.dataTask = defaultSession.dataTask(with: self.request)
        self.dataTask!.resume()
    }
    //停止网络请求
    override func stopLoading() {
        self.dataTask?.cancel()
        self.dataTask       = nil
        self.receivedData   = nil
        self.urlResponse    = nil
    }
    //重新配置URLSessionConfiguration
    open class func defaultSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses!.insert(UYMarkerURLProtocol.self, at: 0)
        return configuration
    }
}
extension UYMarkerURLProtocol: URLSessionDataDelegate, URLSessionTaskDelegate{
    //URLSessionDataDelegate相关的代理方法
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        self.client?.urlProtocol(self, didReceive: response,
                                 cacheStoragePolicy: .notAllowed)
        self.urlResponse = response
        self.receivedData = NSMutableData()
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        self.client?.urlProtocol(self, didLoad: data)
        self.receivedData?.append(data)
    }
    
    //URLSessionTaskDelegate相关的代理方法
    func urlSession(_ session: URLSession, task: URLSessionTask
        , didCompleteWithError error: Error?) {
        if error != nil {
            self.client?.urlProtocol(self, didFailWithError: error!)
        } else {
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
}
