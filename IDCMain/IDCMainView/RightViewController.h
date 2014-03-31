//
//  RightViewController.h
//  IDCMainView
//
//  Created by Mac on 14-3-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupModel.h"
@interface RightViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) GroupModel *group;
@end
