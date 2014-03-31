//
//  LikeItem.h
//  IDCForIOS
//
//  Created by Mac on 14-3-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCGroupItem.h"
@interface LikeItemDB : NSObject
-(void)insertLikeItem:(NSString *)itemID;
-(void)deleteLikeItem:(NSString *)itemID;
-(NSMutableArray *)searchAllLikeItem;
@end
