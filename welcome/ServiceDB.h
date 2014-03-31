//
//  ServiceDB.h
//  IDCWelcome
//
//  Created by Mac on 13-11-28.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceUri.h"
@interface ServiceDB : NSObject
-(void)insertService:(ServiceUri *)serviceUri;
-(void)createDB;
-(ServiceUri *)searchServiceFromName:(NSString *)UriName;
@end
