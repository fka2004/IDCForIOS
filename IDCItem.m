//
//  Item.m
//  IDCForIOS
//
//  Created by Mac on 13-12-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "IDCItem.h"
#import "ActionDoFactory.h"
@implementation IDCItem
-(void)doAction:(UIViewController *)viewController{
    [ActionDoFactory actionDo:self viewController:viewController];
}
@end
