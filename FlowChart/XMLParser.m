//
//  XMLParser.m
//  FlowChart
//
//  Created by Mac on 13-11-19.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "XMLParser.h"
@interface XMLParser (){
   
    NSMutableArray *labelArray;
    NSMutableArray *flowInArray;
    NSMutableArray *flowOutArray;
    NSString *currentName;
    NSMutableString *contentStr;
}
@end
@implementation XMLParser
-(void)parserXML:(NSString *)xml{
    
    NSData *date = [NSData dataWithBytes:[xml UTF8String] length:[xml length]];
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:date];
//    [parser setShouldProcessNamespaces:NO];
//    [parser setShouldReportNamespacePrefixes:NO];
//    [parser setShouldResolveExternalEntities:NO];
    
    [parser setDelegate:self];
    _dateArray = [[NSMutableArray alloc]init];
    labelArray = [[NSMutableArray alloc]init];
    flowInArray = [[NSMutableArray alloc]init];
    flowOutArray = [[NSMutableArray alloc]init];
    [parser parse];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    currentName = elementName;
    NSLog(@" 123:  %@",elementName);
    contentStr = [[NSMutableString alloc]init];
    NSLog(@"456:%@",contentStr);
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if([currentName isEqualToString:@"in"] || [currentName isEqualToString:@"out"] || [currentName isEqualToString:@"Time_val"] || [currentName isEqualToString:@"name"]){
        [contentStr appendString:string];
    }
    

}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([currentName isEqualToString:@"in"]){
        [flowInArray addObject:contentStr];
    }else if ([currentName isEqualToString:@"out"]){
        [flowOutArray addObject:contentStr];
    }else if ([currentName isEqualToString:@"Time_val"]){
        [labelArray addObject:contentStr];
    }else if([currentName isEqualToString:@"name"]){
        NSLog(@"%@",contentStr);
    }else if([currentName isEqualToString:@"p"]){
        NSLog(@"~~~~:%@",currentName);
    }else if([elementName isEqualToString:@"MessageInfo"]){
        //返回数据
        [_dateArray addObject:flowInArray];
        [_dateArray addObject:flowOutArray];
        [_dateArray addObject:labelArray];
    }
    if(currentName){
        currentName = nil;
    }
    if(contentStr){
        contentStr = nil;
    }
   
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //返回数据
    [_dateArray addObject:flowInArray];
    [_dateArray addObject:flowOutArray];
    [_dateArray addObject:labelArray];
}
-(NSMutableArray *)getData{
    return _dateArray;
}
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@",parseError);
}
@end

