//
//  DefaultDataSource.h
//  IDCForIOS
//
//  Created by Mac on 14-1-8.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetHTTPRequest.h"
#import "HttpDownloadDelegate.h"
#import "TableViewModelViewController.h"
#import "IDCGroupItem.h"
@interface DefaultDataSource : NSObject<TableViewModelDelegate,NetHTTPRequestDelegate,HttpDownloadDelegate>

@property (nonatomic,strong) IDCGroupItem *item;

-(void)showTableViewController:(NSMutableArray *)param;
@end
