//
//  CoreTelephony.m
//  IDCForIOS
//
//  Created by Mac on 14-1-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "CoreTelephony.h"

@implementation CoreTelephony

struct CTServerConnection *sc=NULL;
struct CTResult result;
void callback(){};
+(NSString * )getIMEI{
    sc = _CTServerConnectionCreate(kCFAllocatorDefault, callback, NULL);
    
    NSString *imei;
    _CTServerConnectionCopyMobileIdentity(&result, sc, &imei);
    return imei;

}

extern NSString* CTSIMSupportCopyMobileSubscriberIdentity();

+ (NSString*) getDeviceIMSI {
    return CTSIMSupportCopyMobileSubscriberIdentity();
}
extern NSString* CTSettingCopyMyPhoneNumber();
//获得本机号码
+ (NSString*) getPhoneCodeByCT {
    return CTSettingCopyMyPhoneNumber();
}
@end
