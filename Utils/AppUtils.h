//
//  AppUtils.h
//  IDCForIOS
//
//  Created by Mac on 14-1-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtils : NSObject
+(NSString *)getUdid;
+(NSString *)getImei;
+(NSString *)getPhoneNumber;
+(NSString *)getImsi;
+(NSString *)getDeviceModel;
+(NSString *)getSystemName;
+(NSString *)getSystemVersion;
+(NSString *)getLocalizedModel;//本地设备模式
+(NSString *)getAppIdentifier;
+(NSString *)getAppVersion;
+(NSString *)encryptWithMD5:(NSString *)str;
+(NSString *)decodingWithMD5:(NSString *)str;
+(NSString *)getInfoFromCNInfo:(NSString *)key;
+ (BOOL) IsEnableWIFI;
+ (BOOL) IsEnable3G ;
+(NSString *)replaceStr:(NSMutableString *)str;
+(NSMutableData *)replaceHtmlEntities:(NSMutableData *)data;
+(NSString *)replaceStrForLogin:(NSMutableString *)str;
@end
