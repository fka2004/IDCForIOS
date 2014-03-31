//
//  ActionDoFactory.m
//  IDCForIOS
//
//  Created by Mac on 13-12-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ActionDoFactory.h"
#import "IDCGroupItem.h"
#import "Item.h"
@implementation ActionDoFactory
+(void)actionDo:(IDCGroupItem *)item viewController:(UIViewController *) viewController{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"actionfactory" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *type = item.type;
    NSString *className = [data objectForKey:type];
    if(className){
        
        Class itemClass = NSClassFromString(className);
        
        id object=[[itemClass alloc] init];
        
        SEL selector = NSSelectorFromString(@"doItem:");
        NSMutableArray *param = [[NSMutableArray alloc]init];
        [param addObject:item];
        [param addObject:viewController];
        [object performSelector:selector withObject:param];
    }
}
+(void)itemActionDo:(IDCGroupItem *)item viewController:(UIViewController *) viewController cellItem:(Item *) cellItem{
     NSString *className = [item.dataSourceInfo objectForKey:@"itemClickClass"];
    if (className) {
        Class itemClickClass = NSClassFromString(className);
        id object = [[itemClickClass alloc]init];
        SEL selector = NSSelectorFromString(@"showViewController:");
        NSMutableArray *param = [[NSMutableArray alloc]init];
        [param addObject:cellItem];
        [param addObject:viewController];
        [param addObject:item];
        [object performSelector:selector withObject:param];
    }
}
@end
