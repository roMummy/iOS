//
//  ViewController.m
//  RAC
//
//  Created by ZQ on 2018/11/20.
//  Copyright © 2018 xieshou. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TestView.h"

@interface ViewController ()
@property (nonatomic, assign) NSInteger age;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

/*
    1.监听某个方法有没有调用（rac_signalForSelector）
    2.代替kvo
    3.监听事件
    4.代替通知
    5.监听文本框文字改变
    6.处理一个界面，多个请求的问题
 
 */

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self kvo];
//    [self event];
//    [self notification];
//    [self bind];
    [self moreNetword];
}

- (void)moreNetword {
    weakify(<#...#>)
    strongify(<#...#>)
    RACSignal * hotSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 获取热门数据
        [subscriber sendNext:@"热门数据"];
        return nil;
    }];
    RACSignal * newSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 获取热门数据
        [subscriber sendNext:@"最新数据"];
        return nil;
    }];
    
    // selector: 当前数组所有信号都发送next才执行
    // rac_liftSelector硬性要求：有几个信号就必须要有几个参数，参数就是信号发出的值
    [self rac_liftSelector:@selector(updateUIWithHot:new:) withSignalsFromArray:@[hotSignal, newSignal]];
}

- (void)updateUIWithHot:(NSString *)hot new:(NSString *)new {
    NSLog(@"刷新界面 %@  %@",hot,new);
}

- (void)bind {
//    [[_textField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"%@",x);
//        self.label.text = x;
//    }];
//
    // 绑定
    RAC(self.label, text) = [self.textField rac_textSignal];
}

- (void)notification {
    // 监听通知
    // 管理观察者m：rac内部管理
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"note" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"note" object:nil];
    
}

- (void)event {
    // rac监听：subscribeNext 方法订阅
    [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)kvo {
    [[self rac_valuesForKeyPath:@keypath(self, age) observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    // 简便写法
    [RACObserve(self, age) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
}

- (void)selector {
    TestView * view = [[TestView alloc] init];
    view.backgroundColor = [UIColor cyanColor];
    view.frame = CGRectMake(50, 50, 80, 80);
    [self.view addSubview:view];
    
    [[view rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"点击view");
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.age++;
}

@end
