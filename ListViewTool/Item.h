//
//  Item.h
//  ListViewTool
//
//  Created by Mac on 13-10-28.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,copy) NSString *tag;
@property (nonatomic,copy) NSString* title; //标题
@property (nonatomic,copy) NSString* content;   //内容
@property (strong ,nonatomic) NSIndexPath *indexPath;   
@property BOOL hasLink;
@end
