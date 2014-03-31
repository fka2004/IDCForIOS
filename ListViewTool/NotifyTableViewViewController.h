//
//  NotifyTableViewViewController.h
//  IDCForIOS
//
//  Created by Mac on 14-3-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
@protocol NotifyTableViewModelDelegate;
@interface NotifyTableViewViewController :  UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) id<NotifyTableViewModelDelegate> delegate;
@property (nonatomic,assign) NSString *pageNum;

@property CGFloat cellHight;
@property BOOL hitSearchBar;

-(void)refreshTableView:(NSMutableArray *)data;
@end

@protocol NotifyTableViewModelDelegate <NSObject>

@required

-(void)setCellOnClick:(NSIndexPath *)indexPath item:(Item *)item; //设置cell点击事件
-(void)getDate:(NSInteger)pageNum searchText:(NSString *)text tableView:(NotifyTableViewViewController *) selectTable ;//获取数据,pageNum:获取页数   text 搜索输入内容

@end
