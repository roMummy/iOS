//
//  Stack.m
//  oc泛型
//
//  Created by TW on 2018/7/19.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "Stack.h"
#import "Test.h"

@implementation Stack

- (void)pushObject:(id)object {
//    indexNumber = @"1111";
    NSLog(@"view---- %@--index %@",object,indexNumber);
}
- (id)popObject {
    return [Stack new];
}


@end
