//
//  ViewController.m
//  图片切成圆
//
//  Created by TW on 2017/9/22.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "ViewController.h"
#import "TestLabel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    imageView.image =  [UIImage imageNamed:@"1"];
//    [self.view addSubview:imageView];
    
//    UIImage *newImg = [ViewController resizeImage:[UIImage imageNamed:@"1"] size:CGSizeMake(120, 120)];
    UIImage *maskImg = [UIImage imageNamed:@"1"];
    // 取得mask的圖片物件
    
    UIImage * newImg = [self circleImage:maskImg withParam:30];
    // 開始做裁切(Clip)圖片
    imageView.image = newImg;
    // Do any additional setup after loading the view, typically from a nib.
    
    TestLabel * label = [[TestLabel alloc] init];
    label.frame = CGRectMake(100, 100, 400, 200);
    label.text = @"和家欢乐";
    label.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:label];
//    label.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];    //设置文本的阴影色彩和透明度。
//    label.shadowOffset = CGSizeMake(1, 1);
    
}


//图片切成圆形 inset -- 偏移程度


-(UIImage *) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
