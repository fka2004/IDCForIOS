//
//  WebServiceUtil.m
//  IDCWelcome
//
//  Created by Mac on 13-12-3.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "WebServiceUtil.h"
@interface WebServiceUtil(){
    NSMutableString *resultStr;
    NSMutableData *resultData;
}
@end
@implementation WebServiceUtil
-(NSString *)getDateFromWebService:(NSString *)soapMessage url:(NSString *)urlStr{
    NSLog(@"调用webserivce的字符串是:%@",soapMessage);
    //请求发送到的路径
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //以下对请求信息添加属性前四句是必有的，
    [urlRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: urlStr forHTTPHeaderField:@"SOAPAction"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    theConnection = nil;
}
//分批返回数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [resultData appendData:data];
    
}

//返回数据完毕
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    resultData = [self replaceHtmlEntities:resultData];
    //resultStr = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    resultStr = [[NSMutableString alloc]initWithBytes:[resultData mutableBytes] length:[resultData length] encoding:NSUTF8StringEncoding];
    resultStr = [self replaceStr:resultStr];
    NSLog(@"接收完毕:%@",resultStr);
    //将数据返回
    [self.delegate getWebServiceDate:resultStr];
}
//去特殊符号
- (NSMutableData *)replaceHtmlEntities:(NSMutableData *)data
{
    NSString *htmlCode = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    NSMutableString *temp = [NSMutableString stringWithString:htmlCode];
    [temp replaceOccurrencesOfString:@"&" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@" " withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"À" withString:@"à" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    NSData *finalData = [temp dataUsingEncoding:NSISOLatin1StringEncoding];
    [data setData:finalData];
    
    return data;
}
-(NSString *)replaceStr:(NSMutableString *)str{
    [str replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    
    [str replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    
    [str replaceOccurrencesOfString:@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><ns1:Search_Month_InfoResponse xmlns:ns1=\"http://mobileinterface.webservice\"><return>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"</return></ns1:Search_Month_InfoResponse></soap:Body></soap:Envelope>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><ns1:Search_Month_InfoResponse xmlns:ns1=\"http://mobileinterface.webservice\"><Result>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"</Result></ns1:Search_Month_InfoResponse></soap:Body></soap:Envelope>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    return str;
}
@end
