//
//  UYSessionManger.swift
//  UYiFinance
//
//  Created by TW on 2018/1/22.
//  Copyright © 2018年 凤凰. All rights reserved.
//

import UIKit
import Alamofire

class UYSessionManger: Alamofire.SessionManager {
    public static let sharedManager: SessionManager = {
        let configuration = UYMarkerURLProtocol.defaultSessionConfiguration()
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()
}
