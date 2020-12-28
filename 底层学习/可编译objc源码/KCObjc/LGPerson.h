//
//  LGPerson.h
//  KCObjc
//
//  Created by Cooci on 2020/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGPerson : NSObject
{
  NSString * hobby;
}
@property (nonatomic, copy) NSString *cjl_name;
@property (nonatomic, strong) NSString *name;

- (void)sayHello;
- (void)sayCode;
- (void)sayMaster;
- (void)sayNB;

+ (void)sayBye;
@end

NS_ASSUME_NONNULL_END
