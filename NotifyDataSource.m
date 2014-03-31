//
//  NotifyDataSource.m
//  IDCForIOS
//
//  Created by Mac on 14-3-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "NotifyDataSource.h"
#import "NotifyTableViewViewController.h"
#import "HHNetwork.h"
#import "SBJson.h"
#import "LoadingView.h"
@interface NotifyDataSource(){
    NotifyTableViewViewController *tableView ;
    LoadingView *loadView;
}
@end
@implementation NotifyDataSource
-(void)showTableViewController:(NSMutableArray *)param{
    self.item = [param objectAtIndex:0];
    UIViewController *viewController = [param objectAtIndex:1];
    tableView = [[NotifyTableViewViewController alloc]init];
    tableView.delegate = self;
    //tableView.pageNum= @"2/10";
    tableView.hitSearchBar = YES;
    //    CGFloat cellHight = 200.0f;
    //    tableView.cellHight = cellHight;
    
    
    //跳转到列表界面
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tableView];
    
    [viewController presentViewController:nav  animated:YES completion:nil];
}

-(void)getDate:(NSInteger)pageNum searchText:(NSString *)text tableView:(NotifyTableViewViewController *)table{
    loadView = [LoadingView shareLoadingView:@"加载中.."];
    [loadView show];
    //获取数据
    //得到urlParmas 设置分页参数
    NSMutableDictionary *param = self.item.dataSourceInfo;
    NSInteger pageSize = [[param objectForKey:@"pageSize"] integerValue];
    
    if(pageNum == 1){
        [self.item.dataSourceInfo setObject:@"1" forKey:@"isFirst"];
    }else{
        [self.item.dataSourceInfo setObject:@"0" forKey:@"isFirst"];
    }
    NSInteger start = (pageNum-1) * pageSize;
    NSString *startStr = [[NSString alloc]initWithFormat:@"%d",start+1];
    [param setObject:startStr forKey:@"start"];
    [self.item.dataSourceInfo setObject:startStr forKey:@"start"];
    NSString *pageSizeStr = [[NSString alloc]initWithFormat:@"%d",pageSize];
    [self.item.dataSourceInfo setObject:pageSizeStr forKey:@"limit"];
    
    
    HHNetwork *hh = [[HHNetwork alloc]init];
    NSString *baseUrl = [self.item.dataSourceInfo objectForKey:@"baseUri"];
    NSString *action = [self.item.dataSourceInfo objectForKey:@"action"];
    
    NSMutableString *url = [baseUrl stringByAppendingFormat:@"/%@?",action];
    //@"http://192.168.203.129:8080/MobileIDC/mobile.do?"
    [hh downloadFromPostUrl:url dict:self.item.dataSourceInfo completionHandler:^(NSData *data,NSError *error){
        [loadView close];
        if(error){
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取数据失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [view show];
        }else{
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *infos = [parser objectWithString:result];
            NSMutableArray *info = [infos objectForKey:@"pList"];
            
            NSString *total = [infos objectForKey:@"total"];
            int totalInt = [total intValue];
            int pageSize = [[self.item.dataSourceInfo objectForKey:@"pageSize"] intValue];
            int current = totalInt / pageSize ;
            current = current +((totalInt % pageSize)==0?0:1);
            NSNumber *countPage = [NSNumber numberWithInt:current];
            NSMutableString *pageText = [[NSMutableString alloc]initWithFormat:@"%d",[countPage intValue]];
            NSMutableString *pageNumStr = [[NSMutableString alloc]initWithFormat:@"%d",pageNum];
            pageText = [pageNumStr stringByAppendingFormat:@"/%@",pageText];
            
            [array addObject:pageText];
            
            NSMutableArray *subArray = [[NSMutableArray alloc] init];
            for (int j = 0; j < [info count]; j++) {
                NSDictionary *itemDic = [info objectAtIndex:j];
                Item *item = [[Item alloc] init];
                item.title = [itemDic objectForKey:@"title"];
                item.content = [itemDic objectForKey:@"desc"];
                item.indexPath = self.item.indexPath;
                [subArray addObject:item];
            }
            
            
            [array addObject:subArray];
            [table refreshTableView:array];
            
        }
    }];
}

-(NSString *)getParamFromDictionary:(NSDictionary *)dic{
    NSString *paramStr = [[NSString alloc]init];
    NSArray *keys;
    int i,count;
    id key,value;
    key = [dic allKeys];
    count = [key count];
    for (int i=0; i<count; i++) {
        [paramStr stringByAppendingFormat:@"%@",[dic objectForKey:key]];
    }
    return paramStr;
}
@end

