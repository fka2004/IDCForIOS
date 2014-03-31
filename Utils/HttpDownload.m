//
//  HttpDownload.m
//  JsonDemo
//
//  Created by DuHaiFeng on 13-7-22.
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import "HttpDownload.h"
//包含第三方post请求类头文件
#import "ASIFormDataRequest.h"
#import "SBJson.h"
@implementation HttpDownload
@synthesize downloadData=_downloadData;
@synthesize delegate=_delegate;
@synthesize type=_type;

-(id)init
{
    if (self=[super init]) {
        //如果对象为空指针就实例化
        self.downloadData=[NSMutableData dataWithCapacity:0];
    }
    return self;
}
-(void)downloadFromUrlWithASI:(NSString *)url
{
    
    //创建第三方http get请求类实例
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    request.delegate=self;
    [request setTimeOutSeconds:30];
    //启动异步下载
    //清除旧数据
    [self.downloadData setLength:0];
    [request startAsynchronous];
    //[request startSynchronous];
    
}
-(NSMutableDictionary *)downloadFromUrlWithASIWithSynchronous:(NSString *)url dict:(NSDictionary *)dict
{
    
    //创建第三方http get请求类实例
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    request.delegate=self;
    [request setTimeOutSeconds:30];
    NSDictionary *dic;
    //启动异步下载
    //清除旧数据
    [self.downloadData setLength:0];
    //设置参数
    NSArray *keys;
    int count;
    id key,value;
    if(dict){
        keys = [dict allKeys];
        count = [keys count];
        for (int i=0; i<count; i++) {
            key = [keys objectAtIndex:i];
            value = [dict objectForKey:key];
            [request setPostValue:value forKey:key];
        }
    }
    [request startSynchronous];
//    [request startAsynchronous];
    
    NSError *error = [request error];
    
    if(!error){
        NSData *data = self.downloadData;
        SBJsonParser *json = [[SBJsonParser alloc]init];
        dic = [json objectWithData:data];
//        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        return dic;
    }else{
        return nil;
    }
   
}
-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    NSLog(@"%@",data);
    
    //保存第三方下载的数据
    [self.downloadData appendData:data];
    NSLog(@"文件下载中");
    
}
-(void)downloadFromUrlWithASI:(NSString *)url dict:(NSDictionary *)dict
{
    //实例化post请求对象
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    request.delegate=self;
    [request setTimeOutSeconds:30];
    //设置参数
    NSArray *keys;
    int count;
    id key,value;
    if(dict){
        keys = [dict allKeys];
        count = [keys count];
        for (int i=0; i<count; i++) {
            key = [keys objectAtIndex:i];
            value = [dict objectForKey:key];
            [request setPostValue:value forKey:key];
        }
    }

    
//    for (NSString *key in [dict allKeys]) {
//        id object=[dict objectForKey:key];
//        
//        //如果参数值为二进制数据(在我们例子中是上传图片)NSData为二级制类型
//        if ([object isKindOfClass:[NSData class]]) {
//            [request setData:object withFileName:@"1.png" andContentType:@"image/png" forKey:key];
//        }
//        //否则上传或下载正常数据
//        else{
//            [request setPostValue:object forKey:key];
//        }
//    }
    
    //启动异步下载
    [request startAsynchronous];
}
-(NSDictionary *)downLoadFromUrlWithGet:(NSString *)urlStr{
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"请求完成");
    NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return  resDict;
}
//第三方http请求完成的协议方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    //清除旧数据
//    [self.downloadData setLength:0];
    //保存第三方下载的数据
  //  [self.downloadData appendData:[request responseData]];
    NSLog(@"下载完成");
    //回调委拖方请求完成
    if ([self.delegate respondsToSelector:@selector(downloadComplete:)]) {
        [self.delegate downloadComplete:self];
    }
    
}
//第三方http请求失败的协议方法
-(void)requestFailed:(ASIHTTPRequest *)request
{
    //清除旧数据
    [self.downloadData setLength:0];
   
    //回调委拖方请求完成
    if ([self.delegate respondsToSelector:@selector(downloadFail::)]) {
        [self.delegate downloadFail:self];
    }
}
//从指定网址下载数据
-(void)downloadFromUrl:(NSString *)url
{
    //如果对象为空指针就实例化
    if (!self.downloadData) {
        self.downloadData=[NSMutableData dataWithCapacity:0];
    }
    if (httpConnection) {//释放旧对象
       // [httpConnection release];
        httpConnection= nil;
    }
    //用字符串的方法将网址编码(主要是针对中文)
    NSURL *newUrl=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //创建请求类对象
    NSURLRequest *request=[NSURLRequest requestWithURL:newUrl];
    //创建连接类对象,一旦创建，就启动了异步下载
    httpConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}
//收到服务器的回应（协议方法）
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *newResponse=(NSHTTPURLResponse*)response;
    //打印服务器返回的状态码
    NSLog(@"%d",[newResponse statusCode]);
    
    //收到新数据就清除旧数据
    [self.downloadData setLength:0];
}
//收到服务器发送的数据（多次调用）
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //保存每次接收到的数据
    [self.downloadData appendData:data];
}
//数据下载完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //检查self.delegate对象是否实现了方法downloadComplete:
    NSString *s = [[NSString alloc]initWithData:self.downloadData encoding:NSUTF8StringEncoding];
    NSLog(@"下载完成!!!%@",s);
    if ([self.delegate respondsToSelector:@selector(downloadComplete:)]) {
        //调用self.delegate对象方法downloadComplete:,参数为当前对象本身
        [self.delegate downloadComplete:self];
    }
}
//下载失败
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //检查self.delegate对象是否实现了方法downloadComplete:
    if ([self.delegate respondsToSelector:@selector(downloadFail:)]) {
        //调用self.delegate对象方法downloadComplete:,参数为当前对象本身
        [self.delegate downloadFail:self];
    }
}

@end




