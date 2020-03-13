//
//  YCDOHTTPClient.m
//  ShecareSDKDemo-OC
//
//  Created by 罗培克 on 2018/3/20.
//  Copyright © 2018年 北京爱康泰科技有限责任公司. All rights reserved.
//

#import "YCDOHTTPClient.h"
#import "AFNetworking/AFHTTPSessionManager.h"

@interface YCDOHTTPClient()

@end

@implementation YCDOHTTPClient

+ (YCDOHTTPClient *)sharedClient {
    static YCDOHTTPClient *client;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc] init];
    });
    
    return client;
}

- (instancetype)init {
    if (self = [super init]) {
        self.sessionManager = [[AFHTTPSessionManager alloc] init];
        AFJSONResponseSerializer *responseSerializer = [[AFJSONResponseSerializer alloc] init];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
        self.sessionManager.responseSerializer = responseSerializer;
        
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        self.sessionManager.requestSerializer = requestSerializer;
        
        self.sessionManager.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    }
    
    return self;
}

@end
