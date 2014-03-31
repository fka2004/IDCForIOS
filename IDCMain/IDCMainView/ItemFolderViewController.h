//
//  ItemFolderViewController.h
//  IDCForIOS
//
//  Created by Mac on 14-3-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ItemFolderDelegate;
@interface ItemFolderViewController : UIViewController
@property (strong ,nonatomic) id<ItemFolderDelegate> delegate;
@property (strong,nonatomic) NSMutableArray *items;
@end

@protocol ItemFolderDelegate <NSObject>

-(void)itemClick:(NSInteger)section row:(NSInteger)row;

@end