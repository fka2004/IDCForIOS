//
//  PlugappAction.m
//  IDCForIOS
//
//  Created by Mac on 14-3-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "PlugappAction.h"
#import "IDCGroupItem.h"
#import "SBJson.h"
@implementation PlugappAction
-(void)doItem:(NSMutableArray *)param{
    IDCGroupItem *item = [param objectAtIndex:0];
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    NSMutableArray *array = [parser objectWithString:item.uri];
    NSLog(@"%@",[[array objectAtIndex:0] objectForKey:@"appUri"]);
    NSURL *url = [NSURL URLWithString:[[array objectAtIndex:0] objectForKey:@"appUri"]];
    [[UIApplication sharedApplication] openURL:url];
}
@end
