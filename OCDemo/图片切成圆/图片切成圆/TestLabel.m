//
//  TestLabel.m
//  图片切成圆
//
//  Created by TW on 2018/2/5.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "TestLabel.h"

@implementation TestLabel

- (void)drawRect:(CGRect)rect {
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf( 0 * (CGFloat)M_PI / 180), 1, 0, 0);
    self.transform = matrix;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0f);
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(context, kCGTextStroke);
    
//    CGContextSetShouldAntialias(context, NO ); //关闭锯齿
    self.textColor = [UIColor whiteColor];
    
    //描边空心字的 描边颜色
    
    
    [super drawTextInRect:rect];
    //画内文字
    CGContextSetTextDrawingMode(context, kCGTextFill);
    self.textColor = [UIColor redColor];
    
    self.layer.shadowOffset = CGSizeMake(0.5, 2.5);
    self.layer.shadowColor = [UIColor blackColor].CGColor;    //设置文本的阴影色彩和透明度。
    self.layer.shadowRadius = 1.8;
    self.layer.shadowOpacity = 0.8;
    [super drawTextInRect:rect];
    
    
}

@end
