//
//  TBXmlParser.m
//  FlowChart
//
//  Created by Mac on 13-11-21.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "TBXmlParser.h"
#import "TBXML.h"
@interface TBXmlParser(){
    NSMutableArray *labelArray;
    NSMutableArray *flowInArray;
    NSMutableArray *flowOutArray;
    NSString *currentName;
    NSMutableString *contentStr;
}
@end
@implementation TBXmlParser

-(NSMutableArray *)start:(NSString *)xmlStr{
    labelArray = [[NSMutableArray alloc]init];
    flowInArray = [[NSMutableArray alloc]init];
    flowOutArray = [[NSMutableArray alloc]init];
    _dateArray = [[NSMutableArray alloc]init];
    
    NSMutableString *resultStr2 = [[NSMutableString alloc]initWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><MessageInfo><Device_Name name=\"设备名称\">70</Device_Name><Detail_info><Time_val name=\"时间数值\">0952</Time_val><in name=\"流入值\">929.39</in><out name=\"流出值\">686.99</out></Detail_info></MessageInfo>"];
    TBXML *tbxml = [[TBXML alloc]initWithXMLString:xmlStr];
    
    TBXMLElement *root = tbxml.rootXMLElement;
    if(root){
        TBXMLElement *info = [TBXML childElementNamed:@"Detail_info" parentElement:root];
        if(info){
            while(info){
                TBXMLElement *folwIn = [TBXML childElementNamed:@"in" parentElement:info];
                if(folwIn){
                    NSString *strIn = [TBXML textForElement:folwIn];
                    [flowInArray addObject:strIn];
                }
                TBXMLElement *folwOut = [TBXML childElementNamed:@"out" parentElement:info];
                if(folwIn){
                    NSString *strOut = [TBXML textForElement:folwOut];
                    [flowOutArray addObject:strOut];
                }
                TBXMLElement *label = [TBXML childElementNamed:@"Time_val" parentElement:info];
                if(folwIn){
                    NSString *strLabel = [TBXML textForElement:label];
                    [labelArray addObject:strLabel];
                    info = [TBXML nextSiblingNamed:@"Detail_info" searchFromElement:info];
                }
            }
            NSLog(@"解析完毕~~~~~");
            [_dateArray addObject:flowInArray];
            [_dateArray addObject:flowOutArray];
            [_dateArray addObject:labelArray];
        }
    }
    return _dateArray;
}
@end
