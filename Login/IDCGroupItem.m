//
//  Item.m
//  Button_Example
//
//  Created by Chakra on 08/04/11.
//  Copyright 2011 Chakra Interactive Pvt Ltd. All rights reserved.
//

#import "IDCGroupItem.h"
#import "ActionDoFactory.h"

@implementation IDCGroupItem

@synthesize idIdentity, text, icon;
-(void)doAction:(UIViewController *)viewController{
    [ActionDoFactory actionDo:self viewController:viewController];
}
@end
