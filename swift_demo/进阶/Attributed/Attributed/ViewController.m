//
//  ViewController.m
//  Attributed
//
//  Created by TW on 2017/9/1.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * message = @"aljdflajflajlkjflajfalk;fjkladfjdiofjaifjds";
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:message];
    
//    NSRange range = NSMakeRange(message.length - content.length, content.length);
    NSRange range1 = NSMakeRange(0, 2);
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0f] range:NSMakeRange(0, 2)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0f] range:NSMakeRange(2, 2)];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    label.font = [UIFont systemFontOfSize:22];
    [label setAttributedText:attributedStr];
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
