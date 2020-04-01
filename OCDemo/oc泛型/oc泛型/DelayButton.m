//
//  DelayButton.m
//  HDCommon
//
//  Created by ZQ on 2020/3/17.
//  Copyright © 2020 中国家医网. All rights reserved.
//

#import "DelayButton.h"

@implementation DelayButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
  DelayButton * btn = [super buttonWithType:buttonType];
  btn.delayTime = 1;
  return btn;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.delayTime = 1;
  }
  return self;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.delayTime = 1;
  }
  return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.userInteractionEnabled) {
        self.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.userInteractionEnabled = true;
        });
    }
}



@end
