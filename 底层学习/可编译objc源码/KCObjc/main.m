//
//  main.m
//  KCObjc
//
//  Created by Cooci on 2020/7/24.
//

#import <Foundation/Foundation.h>
#import "LGPerson.h"
#import "TWPerson.h"
#import "TWTeacher.h"

void testOffset() {
  int a = 10; //变量
  int b = 10;
  NSLog(@"%d -- %p", a, &a);
  NSLog(@"%d -- %p", b, &b);
}

typedef uint32_t mask_t;  // x86_64 & arm64 asm are less efficient with 16-bits

struct lg_bucket_t {
    SEL _sel;
    IMP _imp;
};

struct lg_cache_t {
    struct lg_bucket_t * _buckets;
    mask_t _mask;
    uint16_t _flags;
    uint16_t _occupied;
};

struct lg_class_data_bits_t {
    uintptr_t bits;
};

struct lg_objc_class {
    Class ISA;
    Class superclass;
    struct lg_cache_t cache;             // formerly cache pointer and vtable
    struct lg_class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
};

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        // objc_alloc VS alloc
        // NSObject LGPerson
        // NSObject 根类
        // sel 处理 llvm
        
      //内存中只存在存在一份根元类NSObject，根元类的元类是指向它自己
      
//      LGPerson * person = [[LGPerson alloc] init];
//      TWTeacher * teacher = [[TWTeacher alloc] init];
//
//      NSLog(@"%@ - %@", person, teacher);
      
//        NSObject *objc1 = [[NSObject alloc] init];
//        LGPerson *objc2 = [LGPerson alloc];
        // LGPerson *objc3 = [LGPerson alloc];

//        NSLog(@"Hello, World!  %@",objc2);
            
//      testOffset();
      
      //-----使用 iskindOfClass & isMemberOfClass 类方法
//      BOOL re1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];       //
//      BOOL re2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];     //
//      BOOL re3 = [(id)[LGPerson class] isKindOfClass:[LGPerson class]];       //
//      BOOL re4 = [(id)[LGPerson class] isMemberOfClass:[LGPerson class]];     //
//      NSLog(@" re1 :%hhd\n re2 :%hhd\n re3 :%hhd\n re4 :%hhd\n",re1,re2,re3,re4);
      
//      LGPerson * p = [LGPerson alloc];
//      Class pCls = [LGPerson class];
//      [p sayHello];
//      [p sayCode];
//      [p sayMaster];
//      [p sayNB];
//
//      NSLog(@"%@", pCls);
      
      LGPerson *p  = [LGPerson alloc];
      Class pClass = [LGPerson class];  // objc_clas
      [p sayHello];
      [p sayMaster];
      [p sayNB];
      [p sayCode];

      struct lg_objc_class *lg_pClass = (__bridge struct lg_objc_class *)(pClass);
      NSLog(@"%hu - %u",lg_pClass->cache._occupied,lg_pClass->cache._mask);
      for (mask_t i = 0; i<lg_pClass->cache._mask; i++) {
          // 打印获取的 bucket
          struct lg_bucket_t bucket = lg_pClass->cache._buckets[i];
          NSLog(@"%@ - %p",NSStringFromSelector(bucket._sel),bucket._imp);
      }
    }
    return 0;
}

//void testClassNum() {
//  Class class1 = [TWPerson class];
//  Class class2 = [TWPerson alloc].class;
////  Class class3 = object_getClass([TWPerson alloc]);
//  NSLog(@"\n%p-\n%p-\n%p-\n%p", class1, class2, class3);
//}

