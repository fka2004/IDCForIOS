//
//  HttpDownloadDelegate.h
//  JsonDemo
//
//  Created by DuHaiFeng on 13-7-22.
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HttpDownload;
@protocol HttpDownloadDelegate <NSObject>
//下载完成协议方法
-(void)downloadComplete:(HttpDownload*)hd;
//下载失败协议方法
-(void)downloadFail:(HttpDownload*)hd;
@end
