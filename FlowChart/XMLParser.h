//
//  XMLParser.h
//  FlowChart
//
//  Created by Mac on 13-11-19.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate>
-(void)parserXML:(NSString *)xml;
-(NSMutableArray *)getData;
@property (nonatomic,strong)  NSMutableArray *dateArray;
@end
