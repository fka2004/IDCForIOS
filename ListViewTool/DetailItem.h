//
//  DetailItem.h
//  ListViewTool
//
//  Created by Mac on 13-11-4.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailItem : NSObject
@property (nonatomic,copy) NSString *detailId;
@property (nonatomic,copy) NSString *tag;
@property (nonatomic,copy) NSString *detailLabel;
@property (nonatomic,copy) NSString *detailContent;
@property BOOL *hasLink;
@property (nonatomic,copy) NSString* groupName; //section的Text
@end
