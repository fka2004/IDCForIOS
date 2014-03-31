//
//  HttpDownload.h
//  JsonDemo
//
//  Created by DuHaiFeng on 13-7-22.
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "RootViewController.h"
#import "HttpDownloadDelegate.h"
//第三方http get请求类头文件
#import "ASIHTTPRequest.h"
@interface HttpDownload : NSObject<NSURLConnectionDataDelegate,ASIHTTPRequestDelegate>
{
    //系统Http请求类
    NSURLConnection *httpConnection;
    
    
    
}
//委拖对象(回调对象)
@property (nonatomic,assign) id<HttpDownloadDelegate> delegate;
//用来保存下载的(二进制)数据
@property (nonatomic,strong) NSMutableData *downloadData;
//接口类型
@property (nonatomic,assign) NSInteger type;

//用系统类从指定的网址下载数据
-(void)downloadFromUrl:(NSString*)url;
//用第三方库从指定网址下载数据 get方式
-(void)downloadFromUrlWithASI:(NSString *)url;
//用第三方库从指定网址下载和上传数据 post方式*（可上传图片）
-(void)downloadFromUrlWithASI:(NSString *)url dict:(NSDictionary*)dict;
//同步下载
-(NSMutableDictionary *)downloadFromUrlWithASIWithSynchronous:(NSString *)url dict:(NSDictionary *)dict;
-(NSDictionary *)downLoadFromUrlWithGet:(NSString *)urlStr;
@end
