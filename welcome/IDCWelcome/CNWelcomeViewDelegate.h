//
//  CNWelcomeViewDelegate.h
//  IDCWelcome
//
//  Created by Mac on 13-11-28.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CNWelcomeViewDelegate <NSObject>
-(void)parserXMLandCreateDB:(NSString *)filePath;
@end
