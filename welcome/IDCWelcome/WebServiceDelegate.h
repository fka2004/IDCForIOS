//
//  WebServiceDelegate.h
//  IDCWelcome
//
//  Created by Mac on 13-12-3.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebServiceDelegate <NSObject>
@required
-(void)getWebServiceDate:(NSString *)xmlStr;
@end
