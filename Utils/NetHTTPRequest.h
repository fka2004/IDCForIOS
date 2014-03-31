//
//  NetActionRequest.h
//  IDCForIOS
//
//  Created by Mac on 14-1-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
@protocol NetHTTPRequestDelegate ;


@interface NetHTTPRequest : NSObject<ASIHTTPRequestDelegate>
+(NSString *)getDateWithASIFormSynchronous:(NSString *)url params:(NSDictionary *)params;
+(void)setDelegate:(id)delegate;
-(void)getDataFromQueue:(NSString *)strUrl;
@property (nonatomic,strong) id<NetHTTPRequestDelegate> delegate;
@property (strong) ASINetworkQueue *networkQueue;
@end



@protocol NetHTTPRequestDelegate <NSObject>

@optional
//访问中
- (void)netRequestDidReceiveData:(NSMutableData *)requestData;
//失败
- (void)netRequestFailed:(NetHTTPRequest *)request didRequestError:(NSString *)error;

@required
//成功
- (void)netRequestFinished:(NetHTTPRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSData *)requestData;



@end
