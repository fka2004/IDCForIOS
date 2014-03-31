//
//  ParamDB.h
//  IDCWelcome
//
//  Created by Mac on 13-11-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParamMapping.h"
@interface ParamDB : NSObject
-(void)insertParam:(ParamMapping *)param;
-(void)createDB;
-(ParamMapping *)searchServiceFromName:(NSString *)tag;
-(void)editParam:(NSString *) tag value:(NSString *)value;
@end
