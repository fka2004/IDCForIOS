//
//  TableViewModelViewController.h
//  ListViewTool
//
//  Created by Mac on 13-10-27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@protocol  TableViewModelDelegate;

@interface TableViewModelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) id<TableViewModelDelegate> delegate;
@property (nonatomic,assign) NSString *pageNum;

@property CGFloat cellHight;
@property BOOL hitSearchBar;

-(void)refreshTableView:(NSMutableArray *)data;
@end

@protocol TableViewModelDelegate <NSObject>

@required

-(void)setCellOnClick:(NSIndexPath *)indexPath item:(Item *)item view:(UIViewController *) viewController; //设置cell点击事件
-(void)getDate:(NSInteger)pageNum searchText:(NSString *)text tableView:(TableViewModelViewController *) selectTable ;//获取数据,pageNum:获取页数   text 搜索输入内容
@end