//
//  Stack.h
//  oc泛型
//
//  Created by TW on 2018/7/19.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>


///__covariant 协变性，子类型可以强转到父类型（里氏替换原则）
///__contravariant - 逆变性，父类型可以强转到子类型

@interface Stack<__covariant T> : NSObject

- (void)pushObject:(T)object;
- (T)popObject;
@property (nonatomic, strong) NSArray<T> * allObjects;
@end
