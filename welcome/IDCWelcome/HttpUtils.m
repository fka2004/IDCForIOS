//
//  HttpUtils.m
//  IDCWelcome
//
//  Created by Mac on 13-11-27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "HttpUtils.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
@interface HttpUtils(){
    NSString *path;
    NSMutableData *requestData;
}
@end
@implementation HttpUtils

-(void)downloadFileFromUrl:(NSString *)strUrl FilePath:(NSString *)filePath{
    path = [[NSString alloc]initWithString:filePath];
    requestData = [[NSMutableData alloc]init];
    NSURL *Url = [NSURL URLWithString:strUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:Url];
    [request setDelegate:self];
    //[request startAsynchronous];
    [request startSynchronous];
//    NSError *e = [request error];
//    if(!e){
//        NSData *data = [request responseData];
//        NSString *datastr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"同步数据:%@",datastr);
//        [[NSFileManager defaultManager]createFileAtPath:path contents:data attributes:nil];
//    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"%@",[error localizedDescription]);
}
-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    [requestData appendData:data];
    NSLog(@"文件下载中");
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"下载完毕");
    if(requestData){
        NSString *datastr = [[NSString alloc]initWithData:requestData encoding:NSUTF8StringEncoding];
        NSLog(@"完整数据:%@",datastr);
        [self writeToFile:requestData :path];
    }
    [self.delegate parserXMLandCreateDB:path];
}
//向文件中写入数据
-(void)writeToFile:(NSData *)data:(NSString *) fileName{
    NSString *filePath=[NSString stringWithFormat:@"%@",fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO){
        NSLog(@"file not exist,create it...");
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }else {
        NSLog(@"file exist!!!");
    }
    
    FILE *file = fopen([fileName UTF8String], [@"ab+" UTF8String]);
    
    if(file != NULL){
        fseek(file, 0, SEEK_END);
    }
    int readSize = [data length];
    fwrite((const void *)[data bytes], readSize, 1, file);
    fclose(file);
}

+ (NSMutableDictionary *)pressJson:(NSString *)json {
    
    NSError *error;
    //将请求的url数据放到NSData对象中
    NSData *response = [json dataUsingEncoding:NSUTF8StringEncoding];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    return dic;
}
+ (NSMutableDictionary *)pressJsonWithSB:(NSString *)json{
    NSError *error = nil;
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSDictionary *rootDic = [parser objectWithString:json error:&error];
    return rootDic;
}



@end
