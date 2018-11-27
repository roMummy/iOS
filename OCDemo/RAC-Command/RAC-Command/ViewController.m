//
//  ViewController.m
//  RAC-Command
//
//  Created by ZQ on 2018/11/25.
//  Copyright © 2018 xieshou. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

// RACCommand 实际用途
// 监听按钮点击，网络请求

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self base];
    [self useButton];
}

- (void)useButton {
//    _loginButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        // 执行点击需要做的事情
//        NSLog(@"command Block %@",input);
//        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//            // 点击之后传出去的事情
//            NSLog(@"信号 block");
//            [subscriber sendNext:@"你好啊"];
//            return nil;
//        }];
//    }];
//
    // 控制是否执行block
    RACSubject * enabledSignal = [RACSubject subject];
    _loginButton.rac_command = [[RACCommand alloc] initWithEnabled:enabledSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        // 执行点击需要做的事情
        NSLog(@"command Block %@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            // 点击之后传出去的事情
            NSLog(@"信号 block");
            [subscriber sendNext:@"你好啊"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    // j监听
//    [_loginButton.rac_command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        NSLog(@"点击事件 %@",x);
//    }];
    
    [[_loginButton.rac_command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        BOOL executing = [x boolValue];
        [enabledSignal sendNext:@(!executing)];
    }];
}

- (void)base {
    RACCommand * command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        // 执行block
        NSLog(@"执行block %@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSLog(@"信号block %@",subscriber);
            [subscriber sendNext:@"你好"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    
    // executing 获取执行状态
    // skip 跳过次数  第一次不准确 一般需要跳过
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        BOOL isExecuting = [x boolValue];
        if (isExecuting) {
            NSLog(@"正在执行");
        }else {
            // 需要再signal中执行 sendCompleted 方法  否则永远不会执行完成
            NSLog(@"执行完成");
        }
    }];
    
    // executionSignals 信号中的信号
    // switchToLatest 获取最近的一次信号
    
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //    [command.executionSignals subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);
    //        [x subscribeNext:^(id  _Nullable x) {
    //            NSLog(@"%@",x);
    //        }];
    //    }];
    
    [command execute:@"111"];
    
    //    // 执行execute 就会执行block
    //    [[command execute:@1] subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"订阅信号 %@",x);
    //    }];
}

@end
