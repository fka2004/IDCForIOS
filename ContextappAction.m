//
//  ContextappAction.m
//  IDCForIOS
//
//  Created by Mac on 13-12-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ContextappAction.h"
#import "IDCGroupItem.h"
@implementation ContextappAction
-(void)doItem:(NSMutableArray *)param{
    IDCGroupItem *item = [param objectAtIndex:0];
    
    UIViewController *viewController = [param objectAtIndex:1];

    //启动相应的viewcontroller
    //获取要启动的dataSource的名字
    NSString *className = [item.dataSourceInfo objectForKey:@"class"];
    if(className){
        Class itemClass = NSClassFromString(className);
        id object = [[itemClass alloc]init];
        
        SEL selector = NSSelectorFromString(@"showTableViewController:");
        NSMutableArray *param = [[NSMutableArray alloc]init];
        [param addObject:item];
        [param addObject:viewController];
        [object performSelector:selector withObject:param];
    }
    
}

@end
