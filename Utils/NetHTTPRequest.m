//
//  NetActionRequest.m
//  IDCForIOS
//
//  Created by Mac on 14-1-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "NetHTTPRequest.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@interface NetHTTPRequest(){
    NSMutableData *requestData;
}
@end
@implementation NetHTTPRequest
+(NSString *)getDateWithASIFormSynchronous:(NSString *)url params:(NSDictionary *)params{
    NSURL *Url = [NSURL URLWithString:url];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:Url];
    NSArray *keys;
    int count;
    id key,value;
    if(params){
        keys = [params allKeys];
        count = [keys count];
        for (int i=0; i<count; i++) {
            key = [keys objectAtIndex:i];
            value = [params objectForKey:key];
            [request setPostValue:value forKey:key];
        }
    }

    request.delegate = self;
    [request setTimeOutSeconds:10000];
    [request startSynchronous];
    //[request startAsynchronous];
    NSError *e = [request error];
        if(!e){
            NSData *data = [request responseData];
            NSString *datastr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"同步数据:%@",datastr);
            return datastr;
        }
    return nil;
}

-(void)getDataFromQueue:(NSString *)strUrl{
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


//+(void)setDelegate:(id)delegate{
//    self.delegate = delegate;
//}

-(void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"%@",[error localizedDescription]);
    [self FaileddidRequestError:error];
}
-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    [requestData appendData:data];
    NSLog(@"文件下载中");
    [self netRequestDidReceiveData:requestData];
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"下载完毕");
    int statusCode = [request responseStatusCode];
    if(requestData && statusCode == 200){
        NSString *datastr = [[NSString alloc]initWithData:requestData encoding:NSUTF8StringEncoding];
        NSLog(@"完整数据:%@",datastr);
        [self FinisheddidRecvedInfoToResult:datastr responseData:requestData];
    }
}
- (void)netRequestDidReceiveData:(NSMutableData *)requestData
{
    if (_delegate && [_delegate respondsToSelector:@selector(netRequestDidReceiveData:)]) {
        [self.delegate netRequestDidReceiveData:requestData];
    }
 
}



- (void)FinisheddidRecvedInfoToResult:(NSString *)result responseData:(NSData*)requestData
{
    if (_delegate && [_delegate respondsToSelector:@selector(netRequestFinished: finishedInfoToResult: responseData:)]) {
		[_delegate netRequestFinished:self finishedInfoToResult:result responseData:requestData];
	}
 
}

- (void) FaileddidRequestError:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(netRequestFailed:didRequestError:)]) {
        [_delegate netRequestFailed:self didRequestError:error];
    }
    
}




@end
