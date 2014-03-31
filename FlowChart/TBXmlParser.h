//
//  TBXmlParser.h
//  FlowChart
//
//  Created by Mac on 13-11-21.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBXmlParser : NSObject
-(NSMutableArray *)start:(NSString *)xmlStr;
@property (nonatomic,strong)  NSMutableArray *dateArray;
@end
