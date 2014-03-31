//
//  CNWelcomeViewController.m
//  IDCWelcome
//
//  Created by Mac on 13-11-25.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
#include <sys/param.h>
#include <sys/mount.h>
#import "CNWelcomeViewController.h"
#import "LDProgressView.h"
#import "HttpUtils.h"
#import "CNXMLParser.h"
#import "ServiceDB.h"
#import "ParamDB.h"
#import "ParamMapping.h"
#import "DownLoadQueue.h"
#import "AESCrypt.h"
#import "Reachability.h"
#import "LoginController.h"
@interface CNWelcomeViewController (){
    UIProgressView *progressView;
    UILabel *label;
    UILabel *info;
    NSMutableArray *urlArray;
    NSMutableArray *pathArray;
    
}
@property (nonatomic, strong) NSMutableArray *progressViews;
@property (nonatomic, strong) UIButton *button;
@end

@implementation CNWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    //设置背景
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"1.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    //设置进度条
    info  = [[UILabel alloc]initWithFrame:CGRectMake(150, 256, 120, 20)];
    info.text = @"正在加载数据";
    info.font = [UIFont fontWithName:@"American Typewriter" size:15];
    info.backgroundColor = [UIColor clearColor];
    [self.view addSubview:info];
    label = [[UILabel alloc]initWithFrame:CGRectMake(250, 255, 60, 20)];
    label.text = @"0\%";
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(20, 280, self.view.frame.size.width - 40, 15)];
    [progressView setProgressViewStyle:UIProgressViewStyleBar];
    progressView.progress = 0;
    [self.view addSubview:progressView];
    
    
//    _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    _button.backgroundColor = [UIColor blackColor];
//    [_button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_button];
    
    //访问webservice获取数据
    
    [self setProgressVlue:0.2f];
    if(![self isConnectionAvailable]){
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不通,请连接网络后再试." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertview.tag = 2;
        [alertview show];
    }else{
        //判断磁盘剩余空间
        // long freeDisk = freeDiskSpaceInBytes();
        NSDictionary *fsAttr = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
        //系统空间
        CGFloat diskSize = [[fsAttr objectForKey:NSFileSystemSize]doubleValue] / 1000000000;
        //剩余空间
        CGFloat diskSizeTemp = [[fsAttr objectForKey:NSFileSystemFreeSize]doubleValue] / 1000000000 *1024;
        if(diskSizeTemp<1.0){
            //磁盘控件不足1m提示
            UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"磁盘控件不足,请清理后再试." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertview.tag = 2;
            [alertview show];
        }else{
            //下载文件
            [self createFile];
        }
    }
    
    [super viewDidLoad];
	
}

//设置进度值
-(void)setProgressVlue:(CGFloat)value{
    NSMutableString *labelText = [[NSMutableString alloc]initWithFormat:@"%.0f",value*100 ];
    [labelText appendString:@"\%"];
    label.text = labelText;
    progressView.progress = value;
}
-(void)createFile{
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *home = [@"~" stringByExpandingTildeInPath];
    NSString *fileDirName = @"cntomorrow";
    NSString *path = [home stringByAppendingString:@"/Documents"];
    path = [path stringByAppendingPathComponent:fileDirName];
    [manager removeItemAtPath:path error:nil];
    //判断文件夹是否存在,不存在则创建
    if(![manager fileExistsAtPath:path]){
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        NSString *urlOne = @"http://1.202.208.29:8899/download/com.cntomorrow.mobile.framework/Service/ParamMapping.xml";
        //NSString *urlOne2 = @"http://192.168.203.51:8080/download/test1.zip";
        NSString *pathOne = [path stringByAppendingString:@"/ParamMapping.xml"];
        NSString *urlTwo = @"http://1.202.208.29:8899/download/com.cntomorrow.mobile.framework/Service/ServiceUri.xml";
        NSString *pathTwo = [path stringByAppendingString:@"/ServiceUri.xml"];
        urlArray = [[NSMutableArray alloc]init];
        pathArray = [[NSMutableArray alloc]init];
        [urlArray addObject:urlOne];
        [urlArray addObject:urlTwo];
        [pathArray addObject:pathOne];
        [pathArray addObject:pathTwo];
        [self downLoadFiles];
    }
}
//解析xml
-(void)parserXMLandCreateDB:(NSString *)filePath{
    
    CGFloat value = progressView.progress+0.3f;
    [self setProgressVlue:value];
    NSString *home = [@"~" stringByExpandingTildeInPath];
    NSString *path = [home stringByAppendingString:@"/Documents"];
    NSString *fileDirName = @"cntomorrow";
    path = [path stringByAppendingPathComponent:fileDirName];
    
    //解析下载后的文件
    CNXMLParser *parser = [[CNXMLParser alloc]init];
    if([filePath isEqualToString:[path stringByAppendingString:@"/ParamMapping.xml"]]){
        NSMutableArray *paramArray = [parser parserParamMapping:[path stringByAppendingString:@"/ParamMapping.xml"]];
        //创建数据库并插入数据
        ParamDB *db = [[ParamDB alloc]init];
        [db createDB];
        for (int i=0; i<[paramArray count]; i++) {
            ParamMapping *paramMapping = [paramArray objectAtIndex:i];
            [db insertParam:paramMapping];
        }
        //测试
        //        [db editParam:@"MAPPING-USERNAME" value:@"2222" ];
        //        ParamMapping *paramMapping = [db searchServiceFromName:@"MAPPING-USERNAME"];
        //        NSLog(@"%@",paramMapping.value);
        
    }else if([filePath isEqualToString:[path stringByAppendingString:@"/ServiceUri.xml"]]){
        NSMutableArray *serviceArray = [parser parserServiceUri:[path stringByAppendingString:@"/ServiceUri.xml"]];
        ServiceDB *db = [[ServiceDB alloc]init];
        //创建数据库并插入数据
        [db createDB];
        for (int i=0; i<[serviceArray count]; i++) {
            
            ServiceUri *uri = [serviceArray objectAtIndex:i];
            [db insertService:uri];
        }
        //测试获取数据
        //        ServiceUri *uri = [db searchServiceFromName:@"regist"];
        //NSLog(@"1%@",uri.name);
        //        NSLog(@"2%@",uri.method);
        //        NSLog(@"3%@",uri.tagname);
        //        NSLog(@"4%@",uri.webservice);
        
    }
    
    
}
-(void)downLoadFiles{
    if (!_networkQueue) {
        _networkQueue = [[ASINetworkQueue alloc] init];
    }
    
    // 停止以前的队列
	[_networkQueue cancelAllOperations];
	
	// 创建ASI队列
	[_networkQueue setDelegate:self];
	[_networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
	[_networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
	[_networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
    
    for (int i=0; i<urlArray.count; i++) {
        NSURL *url = [NSURL URLWithString:[urlArray objectAtIndex:i]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.tag = i;
        [_networkQueue addOperation:request];
        
        
    }
    
	[_networkQueue go];
    
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"请求成功");
    NSData *requestData = [request responseData];
    NSLog(@"下载完毕");
    if(requestData){
        NSString *datastr = [[NSString alloc]initWithData:requestData encoding:NSUTF8StringEncoding];
        NSLog(@"完整数据:%@",datastr);
        [self writeToFile:requestData :[pathArray objectAtIndex:request.tag]];
        [self parserXMLandCreateDB:[pathArray objectAtIndex:request.tag]];
        [self setProgressVlue:1.0f];
        //跳刀登录界面
        LoginController *loginView = [[LoginController alloc]init];
        [self presentViewController:loginView animated:YES completion:nil];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",[error localizedDescription]);
    if ([_networkQueue requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
    UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"下载文件失败,请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertview.tag = 1;
    [alertview show];
    NSLog(@"请求失败");
}


- (void)queueFinished:(ASIHTTPRequest *)request
{
	if ([_networkQueue requestsCount] == 0) {
		[self setNetworkQueue:nil];
	}
    NSLog(@"队列完成");
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

-(void)getWebServiceDate:(NSString *)xmlStr{
    //解析返回的xmlStr
    
    
    //判断软件版本
    NSString *curVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    //如果需要更新
    if(YES){
        //弹窗
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否更新版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertview.tag = 0;
        [alertview show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"click : %i",buttonIndex);
    if(buttonIndex == 1 && alertView.tag == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    }else if(alertView.tag == 1){
        // 停止以前的队列
        if(_networkQueue){
            [_networkQueue cancelAllOperations];
        }
        //删除文件
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *home = [@"~" stringByExpandingTildeInPath];
        NSString *fileDirName = @"cntomorrow";
        NSString *path = [home stringByAppendingString:@"/Documents"];
        path = [path stringByAppendingPathComponent:fileDirName];
        [manager removeItemAtPath:path error:nil];
    }else if(alertView.tag == 2){
        [self dismissViewControllerAnimated:YES completion:nil];
        exit(0);
    }
}
//获取剩余磁盘空间
+ (long long) freeDiskSpaceInBytes{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return freespace;
}
-(void)click{
    [self setProgressVlue:0.9f];
}
//判断是否连接网络
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    return isExistenceNetwork;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
