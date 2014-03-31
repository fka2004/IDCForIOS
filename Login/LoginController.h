//
//  LoginController.h
//  IDC
//
//  Created by JackZhang on 13-11-12.
//  Copyright (c) 2013年 JackZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "DropDown.h"
#import <sqlite3.h>
#import "HttpDownloadDelegate.h"

@class SWRevealViewController;

@interface LoginController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NSURLConnectionDataDelegate,UIGestureRecognizerDelegate,HttpDownloadDelegate,NSURLConnectionDataDelegate>{
    float fontSize;
    NSMutableData *respdata;
    LoadingView *loadingView;//custom loading view
    NSUserDefaults *defaultSettings;//save setting info
    float width;
    float height;
    NSMutableArray *userData;
    float loginFrameY;
    CALayer *sublayer;
    DropDown *dropdown;
    sqlite3 *db;
}

@property (retain, nonatomic) UITextField *nameField;
@property (retain, nonatomic) UITextField *pwdField;
@property (retain, nonatomic) UILabel *setting;
@property (retain, nonatomic) UILabel *revealPwdLabel;
@property (nonatomic, retain) NSMutableArray *groups;

@end

