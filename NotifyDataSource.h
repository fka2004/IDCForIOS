//
//  NotifyDataSource.h
//  IDCForIOS
//
//  Created by Mac on 14-3-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCGroupItem.h"
#import "NotifyTableViewViewController.h"
@interface NotifyDataSource : NSObject<NotifyTableViewModelDelegate>

@property (nonatomic,strong) IDCGroupItem *item;

-(void)showTableViewController:(NSMutableArray *)param;
@end
