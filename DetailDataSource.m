//
//  DetailDataSource.m
//  IDCForIOS
//
//  Created by Mac on 14-1-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "DetailDataSource.h"
#import "DetailListViewController.h"
#import "DetailListViewController.h"
#import "HHNetwork.h"
#import "SBJson.h"
#import "DetailItem.h"
#import "LoadingView.h"
@interface DetailDataSource(){
    DetailListViewController *tableView;
    LoadingView *loadView;
}
@end
@implementation DetailDataSource
-(void)showTableViewController:(NSMutableArray *)param{
    self.item = [param objectAtIndex:0];
    UIViewController *viewController = [param objectAtIndex:1];
    tableView = [[DetailListViewController alloc] initWithNibName: @"DetailListViewController" bundle:nil];
    tableView.delegate = self;

    //跳转到列表界面
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tableView];
    
    [viewController presentViewController:nav  animated:YES completion:nil];
}
//获取数据
-(void)getDate{
    loadView = [LoadingView shareLoadingView:@"加载中.."];
    [loadView show];
    //获取数据
    //得到urlParmas 设置分页参数
    NSMutableDictionary *param = self.item.dataSourceInfo;
    HHNetwork *hh = [[HHNetwork alloc]init];
    NSString *baseUrl = [self.item.dataSourceInfo objectForKey:@"baseUri"];
    NSString *action = [self.item.dataSourceInfo objectForKey:@"action"];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSMutableString *url = [baseUrl stringByAppendingFormat:@"/%@?",action];
    //@"http://192.168.203.129:8080/MobileIDC/mobile.do?"
    [hh downloadFromPostUrl:url dict:param completionHandler:^(NSData *data,NSError *error){
        [loadView close];
        if(error){
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取数据失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [view show];
        }else{
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableArray *infos = [parser objectWithString:result];
            for (int i=0; i<infos.count; i++) {
                DetailItem *item = [[DetailItem alloc]init];
                item.detailLabel = [[infos objectAtIndex:i] objectForKey:@"name"];
                item.detailContent = [[infos objectAtIndex:i] objectForKey:@"value"];
                [array addObject:item];
            }
            [tableView refreshTableView:array];
        }
    }];
    
}
 //设置cell点击事件
-(void)setDetailCellOnClick:(NSIndexPath *)indexPath{

}
//link按钮点击事件
-(void)setLinkButtonOnClick:(NSInteger)section row:(NSInteger)row detailItem:(DetailItem *)detailItem{

}


@end
