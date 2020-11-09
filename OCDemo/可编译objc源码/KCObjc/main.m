//
//  main.m
//  KCObjc
//
//  Created by Cooci on 2020/7/24.
//

#import <Foundation/Foundation.h>
#import "LGPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        // objc_alloc VS alloc
        // NSObject LGPerson
        // NSObject 根类
        // sel 处理 llvm
        
        NSObject *objc1 = [NSObject alloc];
        LGPerson *objc2 = [LGPerson alloc];
        // LGPerson *objc3 = [LGPerson alloc];

        NSLog(@"Hello, World!  %@",objc2);
    }
    return 0;
}
