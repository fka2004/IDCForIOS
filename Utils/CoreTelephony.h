//
//  CoreTelephony.h
//  IDCForIOS
//
//  Created by Mac on 14-1-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTelephony : NSObject

+(NSString * )getIMEI;
+ (NSString*) getDeviceIMSI;
+ (NSString*) getPhoneCodeByCT;
int * _CTServerConnectionCopyMobileEquipmentInfo (
                                                  struct CTResult * Status,
                                                  struct __CTServerConnection * Connection,
                                                  CFMutableDictionaryRef * Dictionary
                                                  );
struct CTServerConnection
{
    int a;
    int b;
    CFMachPortRef myport;
    int c;
    int d;
    int e;
    int f;
    int g;
    int h;
    int i;
};

struct CTResult
{
    int flag;
    int a;
};

struct CTServerConnection * _CTServerConnectionCreate(CFAllocatorRef, void *, int *);

void _CTServerConnectionCopyMobileIdentity(struct CTResult *, struct CTServerConnection *, NSString **);
@end
