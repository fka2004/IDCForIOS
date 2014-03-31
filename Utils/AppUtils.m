//
//  AppUtils.m
//  IDCForIOS
//
//  Created by Mac on 14-1-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "AppUtils.h"
#import "CoreTelephony.h"
#import <UIKit/UIDevice.h>
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
@implementation AppUtils
+(NSString *)getImei{
    return [CoreTelephony getIMEI];
}
+(NSString *)getImsi{
    return [CoreTelephony getDeviceIMSI];
}
+(NSString *)getPhoneNumber{
    return [CoreTelephony getIMEI];
}
+(NSString *)getDeviceModel{
    return  [[UIDevice currentDevice] model];
}
+(NSString *)getSystemName{
    return  [[UIDevice currentDevice] systemName];
}
+(NSString *)getSystemVersion{
    return  [[UIDevice currentDevice] systemVersion];
}
+(NSString *)encryptWithMD5:(NSString *)str{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    NSString *mdfiveString = [hash lowercaseString];
    NSLog(@"Encryption Result = %@",mdfiveString);
    return mdfiveString;
}
#pragma mark 判断网络连接
+(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    return isExistenceNetwork;
}
+ (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}
+(NSString *)getAppIdentifier{
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    return [dic objectForKey:@"CFBundleIdentifier"];
}
+(NSString *)getAppVersion{
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    return [dic objectForKey:@"CFBundleShortVersionString"];
}
+(NSString *)getInfoFromCNInfo:(NSString *)key{
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"CNInfo" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *info = [dic objectForKey:key];
    return info;
}
+(NSString *)replaceStr:(NSMutableString *)str{
    [str replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    
    [str replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    
    [str replaceOccurrencesOfString:@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><ns1:Search_Month_InfoResponse xmlns:ns1=\"http://mobileinterface.webservice\"><return>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"</return></ns1:Search_Month_InfoResponse></soap:Body></soap:Envelope>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><ns1:Search_Month_InfoResponse xmlns:ns1=\"http://mobileinterface.webservice\"><Result>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"</Result></ns1:Search_Month_InfoResponse></soap:Body></soap:Envelope>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    return str;

}
+(NSString *)replaceStrForLogin:(NSMutableString *)str{
    [str replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    
    [str replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    
    [str replaceOccurrencesOfString:@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><ns1:MobileLoginResponse xmlns:ns1=\"http://idc.webservice\"><Result>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"</ns1:MobileLoginResponse></soap:Body></soap:Envelope>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><ns1:Search_Month_InfoResponse xmlns:ns1=\"http://mobileinterface.webservice\"><Result>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    [str replaceOccurrencesOfString:@"</Result></ns1:Search_Month_InfoResponse></soap:Body></soap:Envelope>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
    return str;
    
}
//去特殊符号
+(NSMutableData *)replaceHtmlEntities:(NSMutableData *)data
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
@end
