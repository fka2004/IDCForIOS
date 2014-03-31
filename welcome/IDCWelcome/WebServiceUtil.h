//
//  WebServiceUtil.h
//  IDCWelcome
//
//  Created by Mac on 13-12-3.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceDelegate.h"

@interface WebServiceUtil : NSObject<NSURLConnectionDataDelegate>
-(NSString *)getDateFromWebService:(NSString *)soapMessage url:(NSString *)url;
@property (nonatomic,weak)id <WebServiceDelegate> delegate;
@end
