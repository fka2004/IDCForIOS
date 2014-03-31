//
//  HHNetwork
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import "HHNetwork.h"
#define SYMBOL @"AaB03x" //分界线的标识符
@implementation HHNetwork


-(id)init
{
    if (self=[super init])
    {
        _downloadData=[[NSMutableData alloc]init];
    }
    return self;
}
-(void)downloadFromGetUrl:(NSString *)url completionHandler:(void (^)(NSData *, NSError *))handler
{
    NSURL *newUrl=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    if (_httpConnection) {
//       
//        _httpConnection=nil;
//    }
    NSURLRequest *request=[NSURLRequest requestWithURL:newUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.];
    _httpConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    self.completeBlock=handler;
}
-(void)downloadFromPostUrl:(NSString *)url dict:(NSDictionary *)dict completionHandler:(void (^)(NSData *, NSError *))handler
{
     NSURL *newUrl=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:newUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
//    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:newUrl];
//    request.timeoutInterval=20.;
    [request setHTTPMethod:@"POST"];
    NSMutableArray *arr=[NSMutableArray array];
    for(NSString *key in [dict allKeys]){
        [arr addObject:[NSString stringWithFormat:@"%@=%@",key,[dict objectForKey:key]]];
    }
    NSString *bodyString=[arr componentsJoinedByString:@"&"];

    
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);  
    [request setHTTPBody:[bodyString dataUsingEncoding:enc]];
    
//    [request setHTTPBody:bodyString];
    
    
//    NSString *jsonStr= nil;
//    NSData *body= nil;
//    NSMutableString *params= nil;
//    NSString *contentType= @"text/html; charset=utf-8";
//    NSURL *finalURL= url;
//    if(nil != dict){
//        params = [[NSMutableString alloc] init];
//        for(id key in dict){
//            NSString *encodedkey= [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            CFStringRef encodedValue= CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)([dict objectForKey:key]), NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
//            [params appendFormat:@"%@=%@&",encodedkey, encodedValue];
//        }
//        [params deleteCharactersInRange:NSMakeRange([params length]- 1, 1)];
//    }
//    //
//    
//    contentType = @"application/x-www-form-urlencoded;charset=utf-8";
//    body = [params dataUsingEncoding:NSUTF8StringEncoding];
//   
//    NSMutableDictionary *headers= [[NSMutableDictionary alloc] init];
//    [headers setValue:contentType forKey:@"Content-Type"];
//    [headers setValue:@"text/html" forKey:@"Accept"];
//    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
//    [headers setValue:@"no-cache" forKey:@"Pragma"];
//    [headers setValue:@"close" forKey:@"Connection"];
//   
//    
//    [request setAllHTTPHeaderFields:headers];
//    
//    [request setHTTPBody:body];
    

    
    
    
    _httpConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    self.completeBlock=handler;
}
-(NSString *)sendRequestTo:(NSURL *)url usingVerb:(NSString *)verb withParameters:(NSDictionary *)parameters{
    NSString *jsonStr= nil;
    NSData *body= nil;
    NSMutableString *params= nil;
    NSString *contentType= @"text/html; charset=utf-8";
    NSURL *finalURL= url;
//    if(nil != parameters){
//        params = [[NSMutableString alloc] init];
//        for(id key in parameters){
//            NSString *encodedkey= [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            CFStringRef encodedValue= CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)([parameters objectForKey:key]), NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
//            [params appendFormat:@"%@=%@&",encodedkey, encodedValue];
//        }
//        [params deleteCharactersInRange:NSMakeRange([params length]- 1, 1)];
//    }
    //
    if([verb isEqualToString:@"POST"]){
        contentType = @"application/x-www-form-urlencoded;charset=utf-8";
        body = [params dataUsingEncoding:NSUTF8StringEncoding];
    }else{
        if(nil != parameters){
            NSString *urlWithParams= [[url absoluteString] stringByAppendingFormat:@"?%@",params];
            finalURL = [NSURL URLWithString:urlWithParams];
        }
    }
    NSMutableDictionary *headers= [[NSMutableDictionary alloc] init];
    [headers setValue:contentType forKey:@"Content-Type"];
    [headers setValue:@"text/html" forKey:@"Accept"];
    [headers setValue:@"no-cache" forKey:@"Cache-Control"];
    [headers setValue:@"no-cache" forKey:@"Pragma"];
    [headers setValue:@"close" forKey:@"Connection"];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:finalURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:verb];
    [request setAllHTTPHeaderFields:headers];
    if(nil != parameters){
        [request setHTTPBody:body];
    }
    params = nil;
    //
    NSURLResponse *response;
    NSError *error= nil;
    NSData *responseData= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error){
        NSLog(@"something is wrong: %@", [error description]);
    }else{
        if(responseData){
            jsonStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        }
    }
    return jsonStr;
}
-(void)downloadNSDataFromPostUrl:(NSString *)url dict:(NSDictionary *)dict completionHandler:(void (^)(NSData *, NSError *))handler
{
    NSURL *newUrl=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSTimeInterval timeOut=_timeoutInterval?_timeoutInterval:10.;
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:newUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeOut];
    [request setHTTPMethod:@"POST"];
    //分界线 --AaB03x
    NSString *startSymbol=[NSString stringWithFormat:@"--%@",SYMBOL];
    //结束符 AaB03x--
    NSString *endSymbol=[NSString stringWithFormat:@"--%@--",SYMBOL];
    NSMutableString *bodyString=[[NSMutableString alloc]init];
    NSString *dataKey;
    for(NSString *key in [dict allKeys])
    {
        id object=[dict objectForKey:key];
        if (![object isKindOfClass:[NSData class]]) {
            [bodyString appendFormat:@"%@\r\n",startSymbol];
            //添加字段名称，换2行
            [bodyString appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [bodyString appendFormat:@"%@\r\n",[dict objectForKey:key]];
        }
        else{
            dataKey=[NSString stringWithFormat:@"%@",key];
        }
        
    }
    
    //添加分界线，换行
    [bodyString appendFormat:@"%@\r\n",startSymbol];
    //声明pic字段，文件名为boris.png
    [bodyString appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.%@\"\r\n",dataKey,dataKey,_ContentType];
    //声明上传文件的格式
    [bodyString appendFormat:@"Content-Type: %@\r\n\r\n",_ContentType];
    //声明结束符：--AaB03x--
    NSString *end=[NSString stringWithFormat:@"\r\n%@",endSymbol];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:[dict objectForKey:dataKey]];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",SYMBOL];
    //设置HTTPHeader  
    //[request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request addValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request addValue:[NSString stringWithFormat:@"%d",[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:myRequestData];
//    if (_httpConnection) {
//        _httpConnection=nil;
//    }
    _httpConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    self.completeBlock=handler;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *newResponse=(NSHTTPURLResponse*)response;
    
    if ([newResponse isKindOfClass:[NSHTTPURLResponse class]]) 
    {
        NSLog(@"返回状态:%d",[newResponse statusCode]);
        NSLog(@"返回请求头:%@",[newResponse allHeaderFields]);
    }
    [_downloadData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"正在接收文件");
    [_downloadData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"接收文件完成");
    if (_completeBlock)
    {
        _completeBlock(_downloadData,nil);
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"接收文件失败");
    if (_completeBlock)
    {
        _completeBlock(_downloadData,error);
    }
}
@end
