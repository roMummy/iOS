//
//  LGPerson.m
//  KCObjc
//
//  Created by Cooci on 2020/7/24.
//

#import "LGPerson.h"

@implementation LGPerson
- (void)sayHello {
  NSLog(@"LGPerson say: %s", __func__);
}
- (void)sayCode {
  NSLog(@"LGPerson say: %s", __func__);
}
- (void)sayMaster {
  NSLog(@"LGPerson say: %s", __func__);
}
- (void)sayNB {
  NSLog(@"LGPerson say: %s", __func__);
}

+ (void)sayBye {
  NSLog(@"LGPerson say: %s", __func__);
}
@end
