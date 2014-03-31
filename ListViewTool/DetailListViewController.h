//
//  DetailListViewController.h
//  ListViewTool
//
//  Created by Mac on 13-11-4.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailItem.h"

@protocol DetaillListViewDelegate;
@interface DetailListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) id<DetaillListViewDelegate> delegate;
-(void)refreshTableView:(NSMutableArray *)data;
@end
@protocol DetaillListViewDelegate <NSObject>
@required
-(void)getDate;//获取数据
-(void)setDetailCellOnClick:(NSIndexPath *)indexPath; //设置cell点击事件
-(void)setLinkButtonOnClick:(NSInteger)section row:(NSInteger)row detailItem:(DetailItem *)detailItem;   //link按钮点击事件
@end