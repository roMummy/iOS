//
//  UYMarkerAlamofire.swift
//  UYiFinance
//
//  Created by TW on 2018/1/22.
//  Copyright © 2018年 凤凰. All rights reserved.
//

import UIKit
import Alamofire
//拦截 Alamofire 网络请求 
class UYMarkerAlamofire: NSObject {
    static let sharedMarkerAlamofire = UYMarkerAlamofire()
    private override init() {
        startDates = [URLSessionTask: Date]()
    }
    private var startDates: [URLSessionTask: Date]
    deinit {
        ll_markerStopLogging()
    }
    public func ll_markerStopLogging() {
        NotificationCenter.default.removeObserver(self)
    }
    public func ll_markerStart()  {
        //1.0 添加Alamofire的通知
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(UYMarkerAlamofire.ll_markerNetworkRequestDidStart(notification:)),
            name: Notification.Name.Task.DidResume,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(UYMarkerAlamofire.ll_markerNetworkRequestDidComplete(notification:)),
            name: Notification.Name.Task.DidComplete,
            object: nil
        )
    }
    // MARK: - Private  Notifications
    @objc private func ll_markerNetworkRequestDidStart(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let task = userInfo[Notification.Key.Task] as? URLSessionTask
            else {
                return
        }
        startDates[task] = Date()
    }
    
    @objc private func ll_markerNetworkRequestDidComplete(notification: Notification) {
        guard let sessionDelegate = notification.object as? Alamofire.SessionDelegate,
            let userInfo = notification.userInfo,
            let task = userInfo[Notification.Key.Task] as? URLSessionTask,
            let request = task.originalRequest,
            let httpMethod = request.httpMethod,
            let requestURL = request.url
            else {
                return
        }
        guard let httpBody = request .httpBody else {
            return
        }
//        let json = try? JSONSerialization.jsonObject(with: httpBody,
//                                                     options:.allowFragments)
//        print("request---\(request)")
//        print("json------\(json ?? "nil")")
        
        var elapsedTime: TimeInterval = 0.0
        var startTime:Date?
        if let startDate = startDates[task] {
            elapsedTime = Date().timeIntervalSince(startDate)
            startTime = startDate
            startDates[task] = nil
        }
    }
}
