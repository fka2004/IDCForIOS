//
//  AppDelegate.h
//  IDCForIOS
//
//  Created by Mac on 13-12-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSMutableArray *groups;
@property (strong, nonatomic) NSMutableArray *likeItemGroup;
@property (strong, nonatomic) NSMutableDictionary *appInfo;
@end
