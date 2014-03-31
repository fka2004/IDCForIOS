//
//  ActionDoFactory.h
//  IDCForIOS
//
//  Created by Mac on 13-12-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDCGroupItem.h"
#import "Item.h"
@interface ActionDoFactory : NSObject
+(void)actionDo:(IDCGroupItem *)item viewController:(UIViewController *) viewController;
+(void)itemActionDo:(IDCGroupItem *)item viewController:(UIViewController *) viewController cellItem:(Item *) cellItem;
@end
