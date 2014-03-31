//
//  GroupModel.m
//  loginDemo
//
//  Created by JackZhang on 13-11-5.
//  Copyright (c) 2013年 wu bei. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel
@synthesize items,index,count,expand;
-(id)initWithName:(NSString *)title{
    self = [super init];

    if(self){
        self.title=title;
    }
    return self;
}
@end
