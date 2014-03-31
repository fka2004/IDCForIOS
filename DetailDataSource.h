//
//  DetailDataSource.h
//  IDCForIOS
//
//  Created by Mac on 14-1-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailDataSource.h"
#import "DetailListViewController.h"
#import "IDCItem.h"
#import "NetHTTPRequest.h"
@interface DetailDataSource : NSObject<DetaillListViewDelegate,NetHTTPRequestDelegate>
@property (nonatomic,strong) IDCItem *item;

-(void)showTableViewController:(NSMutableArray *)param;
@end
