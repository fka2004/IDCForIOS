//
//  CNXMLParser.h
//  IDCWelcome
//
//  Created by Mac on 13-11-28.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CNXMLParser : NSObject
-(NSMutableArray *)parserParamMapping:(NSString *)filePath;
-(NSMutableArray *)parserServiceUri:(NSString *)filePath;
@end
