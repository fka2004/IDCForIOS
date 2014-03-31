//
//  MainViewController.h
//  IDCMainView
//
//  Created by Mac on 14-3-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemFolderViewController.h"
@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ItemFolderDelegate>
@property (strong,nonatomic) ItemFolderViewController *itemFolder;
-(void)refreshView;
@end
