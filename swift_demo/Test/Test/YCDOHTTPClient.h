//
//  YCDOHTTPClient.h
//  ShecareSDKDemo-OC
//
//  Created by 罗培克 on 2018/3/20.
//  Copyright © 2018年 北京爱康泰科技有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;
@interface YCDOHTTPClient : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;


///  网络通信中心的单例方法
+ (YCDOHTTPClient *)sharedClient;

@end
