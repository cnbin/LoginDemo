//
//  ViewController.m
//  LoginDemo
//
//  Created by Apple on 8/3/15.
//  Copyright (c) 2015 华讯网络投资有限公司. All rights reserved.
//

#import "ViewController.h"
#import "NSString+URLEncoding.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登录";
    [self initView];
     _dict =[[NSMutableDictionary alloc]init];
}

-(void)initView{
 
    UILabel *label= [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 160, 30)];
    label.text=@"华讯星园欢迎你!";
    [self.view addSubview:label];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 199/255.0f, 140/255.0f, 1 });
    
    phonenumText=[[UITextField alloc]initWithFrame:CGRectMake(20,80, 280, 30)];
    phonenumText.placeholder=@" 请输入手机号-1";
    phonenumText.keyboardType = UIKeyboardTypeNumberPad;
    phonenumText.returnKeyType=UIReturnKeyDone;
    phonenumText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phonenumText.layer setBorderWidth:1.0];
    [phonenumText.layer setCornerRadius:8.0];
    [phonenumText.layer setBorderColor:colorref];
    [self.view addSubview:phonenumText];
    
    passwordText=[[UITextField alloc]initWithFrame:CGRectMake(20,120,235, 30)];
    passwordText.placeholder=@" 请输入密码-12";
    passwordText.keyboardType = UIKeyboardTypeNumberPad;
    passwordText.returnKeyType=UIReturnKeyDone;
    passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [passwordText.layer setBorderWidth:1.0];
    [passwordText.layer setCornerRadius:8.0];
    [passwordText.layer setBorderColor:colorref];
    [self.view addSubview:passwordText];
    
    
    loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame=CGRectMake(20, passwordText.frame.origin.y+passwordText.frame.size.height+20, 280, 30);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor greenColor]];
    [loginButton.layer setBorderWidth:1.0];
    [loginButton.layer setBorderColor:colorref];//边框颜色;
    
    [loginButton.layer setMasksToBounds:YES];
    [loginButton.layer setCornerRadius:10.0];
    loginButton.tag=1;
    [loginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

-(void)buttonAction:(UIButton *)button{
    
    [self startRequest];
    
}

-(void)startRequest
{
    NSString *strURL = [[NSString alloc] initWithFormat:@"http://192.168.40.10/webservice/WebService1.asmx"];
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSString * envelopeText = [NSString stringWithFormat:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                               "<soap:Body>"
                               "<GetUserInfo xmlns=\"http://tempuri.org/\">"
                               "<i>%@</i>"
                               " <j>%@</j>"
                               "</GetUserInfo>"
                               "</soap:Body>"
                               "</soap:Envelope>",phonenumText.text,passwordText.text];
    
    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:envelope];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [envelope length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
    
    if (connection) {
    }
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    //     NSLog(@"开始解析文档");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    //      NSLog(@"结束解析文档");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    //把elementName 赋值给 成员变量 currentTagName
    _currentTagName  = elementName ;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    string  = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""]) {
        return;
    }

    if([_currentTagName isEqualToString:@"GetUserInfoResult"])
    {
        [_dict setObject:string forKey:@"GetUserInfoResult"];
    }

}

#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];

}

-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    
    NSLog(@"%@",[error localizedDescription]);
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
 
    
    NSLog(@"请求完成...");
    NSLog(@"GetUserInfoResult %@",[_dict objectForKey:@"GetUserInfoResult"]);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
