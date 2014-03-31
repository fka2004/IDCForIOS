//
//  DownLoadQueue.m
//  IDCWelcome
//
//  Created by Mac on 13-12-2.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "DownLoadQueue.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
@interface DownLoadQueue()
-(void)downloadComplete:(ASIHTTPRequest *)request;
-(void)imageFetchFailed:(ASIHTTPRequest *)request;
@end
@implementation DownLoadQueue

-(void)downloadFileFromQueue:(NSString *)strUrl FilePath:(NSString *)filePath{
    if (!_networkQueue) {
		_networkQueue = [[ASINetworkQueue alloc] init];
	}
    [_networkQueue cancelAllOperations];
    [_networkQueue setDelegate:self];
  
    [_networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
	[_networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
    //[networkQueue setShowAccurateProgress:[accurateProgress isOn]];
    
    
    ASIHTTPRequest *request;
	request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:strUrl]];
    //[request setDownloadDestinationPath:filePath];
	
    
    
    
	[_networkQueue addOperation:request];
    [_networkQueue go];
    

}
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"下载完毕");
}

-(void)downloadComplete:(ASIHTTPRequest *)request
{
    NSLog(@"下载完毕");

}
-(void)imageFetchFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载异常");
    
}


@end
