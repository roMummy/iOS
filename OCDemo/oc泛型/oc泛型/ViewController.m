//
//  ViewController.m
//  oc泛型
//
//  Created by TW on 2018/7/19.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "ViewController.h"
#import "Stack.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray<__kindof UIView *> * subviews;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Stack * stack;
    Stack<NSString *> * stringStack;
    Stack<NSMutableString *> * mStringStack;
    
    stack = stringStack;
    stack = mStringStack;
    stringStack = stack;
//    stringStack = mStringStack; 指定类型了就不能强转
    mStringStack = stack;
//    mStringStack = stringStack;
    
    UITableView * t = [UITableView new];
    [t dequeueReusableCellWithIdentifier:@"t"];
    UIButton * button = self.subviews.lastObject;
    NSDictionary * dic = @{@"aaa":@{@"1":@[@"A"],@"2":@[],@"41":@[@"T"],@"30":@[@"A",@"B"]}};
//    NSString * dicParam = [self makeParamtersString:dic withEncoding:NSUTF8StringEncoding];
    NSString * dicParam = [self convertToJsonData:dic];
    NSLog(@"%@",dicParam);
    
    NSArray * arr = @[@"1",@"2"];    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSString*)makeParamtersString:(NSDictionary*)parameters withEncoding:(NSStringEncoding)encoding
{
    if (nil == parameters || [parameters count] == 0)
        return nil;
    
    NSMutableString* stringOfParamters = [[NSMutableString alloc] init];
    NSEnumerator *keyEnumerator = [parameters keyEnumerator];
    id key = nil;
    while ((key = [keyEnumerator nextObject]))
    {
        NSString *value = [[parameters valueForKey:key] isKindOfClass:[NSString class]] ?
        [parameters valueForKey:key] : [[parameters valueForKey:key] stringValue];
        [stringOfParamters appendFormat:@"%@=%@&",
         [self URLEscaped:key withEncoding:encoding],
         [self URLEscaped:value withEncoding:encoding]];
    }
    NSRange lastCharRange = {[stringOfParamters length] - 1, 1};
    [stringOfParamters deleteCharactersInRange:lastCharRange];
    return stringOfParamters;
}

- (NSString *)URLEscaped:(NSString *)strIn withEncoding:(NSStringEncoding)encoding
{
    CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)strIn, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", CFStringConvertNSStringEncodingToEncoding(encoding));
    NSString *strOut = [NSString stringWithString:(__bridge NSString *)escaped];
    CFRelease(escaped);
    return strOut;
}

-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
