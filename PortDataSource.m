//
//  PortDataSource.m
//  IDCForIOS
//
//  Created by Mac on 14-3-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "PortDataSource.h"
#import "DatePickViewController.h"
#import "Item.h"
//流量图
@implementation PortDataSource
-(void)showViewController:(NSMutableArray *)param{
    UIViewController *viewController = [param objectAtIndex:1];
    DatePickViewController *datwView = [[DatePickViewController alloc]init];
    datwView.item = [param objectAtIndex:0];
    datwView.IDCItem = [param objectAtIndex:2];
    //跳转到列表界面
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:datwView];
    
    [viewController presentViewController:nav  animated:YES completion:nil];
}

@end
