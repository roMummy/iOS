//
//  UIImageView+Xib.m
//  StoryboardDemo
//
//  Created by TW on 2017/12/8.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "UIImageView+Xib.h"

@implementation UIImageView (Xib)

- (void)setCornerRedius:(CGFloat)cornerRedius {
    self.layer.cornerRadius = cornerRedius;
    self.layer.masksToBounds = cornerRedius > 0;
}

- (CGFloat)cornerRedius {
    return self.layer.cornerRadius;
}

@end
