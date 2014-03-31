//
//  HttpUtils.h
//  IDCWelcome
//
//  Created by Mac on 13-11-27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "CNWelcomeViewDelegate.h"
#import "ASINetworkQueue.h"
@interface HttpUtils : NSObject<ASIHTTPRequestDelegate>{
    ASINetworkQueue *networkQueue;  
}
-(void)downloadFileFromUrl:(NSString *)strUrl FilePath:(NSString *)filePath;
-(void)downloadFileFromQueue:(NSString *)strUrl FilePath:(NSString *)filePath;
+ (NSMutableDictionary *)pressJson:(NSString *)json;
+ (NSMutableDictionary *)pressJsonWithSB:(NSString *)json;
@property (nonatomic,weak) id<CNWelcomeViewDelegate> delegate;
@end
