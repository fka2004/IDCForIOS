//
//  HHNetwork.h
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HHNetwork : NSObject<NSURLConnectionDataDelegate>
{
    NSURLConnection *_httpConnection;
    NSMutableData *_downloadData;
}
@property(strong,nonatomic)NSString *ContentType;//上传NSData文件的格式
//设置连接超时时间
@property(assign,nonatomic)NSTimeInterval timeoutInterval;
@property(copy,nonatomic)void(^completeBlock)(NSData *,NSError *);
//GET请求
-(void)downloadFromGetUrl:(NSString *)url completionHandler:(void (^)(NSData *data, NSError *error))handler;
//POST请求不带NSData数据的
-(void)downloadFromPostUrl:(NSString *)url dict:(NSDictionary *)dict completionHandler:(void (^)(NSData *data, NSError *error))handler;
//POST请求带NSData数据的
-(void)downloadNSDataFromPostUrl:(NSString *)url dict:(NSDictionary *)dict completionHandler:(void (^)(NSData *data, NSError *error))handler;
@end
