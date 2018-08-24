//
//  Stack.m
//  oc泛型
//
//  Created by TW on 2018/7/19.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "Stack.h"

@implementation Stack

- (void)pushObject:(id)object {
    NSLog(@"%@",object);
}
- (id)popObject {
    return [Stack new];
}


@end
