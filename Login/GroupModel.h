//
//  GroupModel.h
//  loginDemo
//
//  Created by JackZhang on 13-11-5.
//  Copyright (c) 2013年 wu bei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject

@property (nonatomic, strong) NSString *title; //分组名称
@property (nonatomic, assign) int index;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) BOOL *expand;
@property(retain,nonatomic) NSMutableArray *items;


-(id)initWithName:(NSString *)title;

@end
