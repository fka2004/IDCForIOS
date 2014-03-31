//
//  DefaultDataSource.m
//  IDCForIOS
//
//  Created by Mac on 14-1-8.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "DefaultDataSource.h"
#import "TableViewModelViewController.h"
#import "HHNetwork.h"
#import "SBJson.h"
#import "LoadingView.h"
#import "AppDelegate.h"
#import "GroupModel.h"
#import "ActionDoFactory.h"
@interface DefaultDataSource(){
    TableViewModelViewController *tableView ;
    LoadingView *loadView;
}
@end
@implementation DefaultDataSource
-(void)showTableViewController:(NSMutableArray *)param{
    self.item = [param objectAtIndex:0];
    UIViewController *viewController = [param objectAtIndex:1];
    tableView = [[TableViewModelViewController alloc]init];
    tableView.delegate = self;

    tableView.hitSearchBar = YES;
    //    CGFloat cellHight = 200.0f;
    //    tableView.cellHight = cellHight;
    
    
    //跳转到列表界面
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tableView];
    tableView.title = self.item.text;
    [viewController presentViewController:nav  animated:YES completion:nil];
}

-(void)getDate:(NSInteger)pageNum searchText:(NSString *)text tableView:(TableViewModelViewController *)table{
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
                item.itemId = [itemDic objectForKey:@"id"];
                if ([self.item.dataSourceInfo objectForKey:@"itemClick"]) {
                    if ([[self.item.dataSourceInfo objectForKey:@"itemClick"]integerValue] == 1) {
                        item.hasLink = YES;
                    }
                }
                [subArray addObject:item];
            }
            
            
            [array addObject:subArray];
            [table refreshTableView:array];
            
        }
    }];
    //    [hh downloadFromGetUrl:@"http://192.168.203.129:8080/MobileIDC/mobile.do?dispatch=getProductInfo&accountName=百度（亦庄）&productType=04&limit=15&start=1&getAll=1&isFirst=1&userName=bdyz&imei=898600610112F0047045&imsi=460001231136971&model=HUAWEIP6-U06&FUNCID=IDC2&FUNCNAME=机架信息" completionHandler:^(NSData *data,NSError *error){
    //        if(error){
    //
    //        }else{
    //            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //            NSMutableDictionary *json = [HttpUtils pressJsonWithSB: result];
    //            NSLog(@"%@",[json objectForKey:@"total"]);
    //            NSMutableArray *jsonArray = [json objectForKey:@"pList"];
    //
    //            NSNumber *countPage = [NSNumber numberWithInt:100];
    //            [array addObject:countPage];
    //
    //            NSMutableArray *subArray = [[NSMutableArray alloc] init];
    //            //            for (int j = 0; j < [jsonArray count]; j++) {
    //            //                NSDictionary *itemDic = [jsonArray objectAtIndex:j];
    //            //                Item *item = [[Item alloc] init];
    //            //                item.title = [itemDic objectForKey:@"title"];
    //            //                item.content = [itemDic objectForKey:@"desc"];
    //            //                [subArray addObject:item];
    //            //            }
    //            for (int j = 0; j < 5; j++) {
    //                NSDictionary *itemDic = [jsonArray objectAtIndex:j];
    //                Item *item = [[Item alloc] init];
    //                item.title = @"你好";
    //                item.content = @"世界";
    //                [subArray addObject:item];
    //            }
    //
    //            [array addObject:subArray];
    //            [table refreshTableView:array];
    //        }
    //    }];
    
    //    [hh downloadNSDataFromPostUrl:self.item.url dict:self.item.urlParams completionHandler:^(NSData *data,NSError *error){
    //        if(error){
    //
    //        }else{
    //            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //            NSMutableDictionary *json = [HttpUtils pressJsonWithSB: result];
    //            NSLog(@"%@",[json objectForKey:@"total"]);
    //            NSMutableArray *jsonArray = [json objectForKey:@"pList"];
    //
    //            NSNumber *countPage = [NSNumber numberWithInt:100];
    //            [array addObject:countPage];
    //
    //            NSMutableArray *subArray = [[NSMutableArray alloc] init];
    ////            for (int j = 0; j < [jsonArray count]; j++) {
    ////                NSDictionary *itemDic = [jsonArray objectAtIndex:j];
    ////                Item *item = [[Item alloc] init];
    ////                item.title = [itemDic objectForKey:@"title"];
    ////                item.content = [itemDic objectForKey:@"desc"];
    ////                [subArray addObject:item];
    ////            }
    //            for (int j = 0; j < 5; j++) {
    //                NSDictionary *itemDic = [jsonArray objectAtIndex:j];
    //                Item *item = [[Item alloc] init];
    //                item.title = @"你好";
    //                item.content = @"世界";
    //                [subArray addObject:item];
    //            }
    //
    //            [array addObject:subArray];
    //            [table refreshTableView:array];
    //        }
    //    }];
    
    
}
-(void)setCellOnClick:(NSIndexPath *)indexPath item:(Item *)item view:(UIViewController *)viewController{
    NSLog(@"%d   %d",item.indexPath.section,item.indexPath.row);
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    GroupModel *group = [appdelegate.groups objectAtIndex:item.indexPath.section];
    IDCGroupItem *idcItem = [group.items objectAtIndex:item.indexPath.row];
    if([[idcItem.dataSourceInfo objectForKey:@"itemClick"]integerValue]==1){
        [ActionDoFactory itemActionDo:idcItem viewController:viewController cellItem:item];
    }
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
