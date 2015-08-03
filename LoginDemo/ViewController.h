//
//  ViewController.h
//  LoginDemo
//
//  Created by Apple on 8/3/15.
//  Copyright (c) 2015 华讯网络投资有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSXMLParserDelegate,NSURLConnectionDelegate>
{
    UITextField * phonenumText;
    UITextField * passwordText;
    UIButton *loginButton;
}

// 当前标签的名字 ,currentTagName 用于存储正在解析的元素名
@property (strong ,nonatomic) NSString * currentTagName;

@property (strong,nonatomic) NSMutableDictionary * dict;


@end

