//
//  DatePickViewController.h
//  FlowChart
//
//  Created by Mac on 13-11-15.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCGroupItem.h"
#import "Item.h"
@interface DatePickViewController : UIViewController<NSURLConnectionDataDelegate>
@property (strong, nonatomic) Item *item;
@property (strong, nonatomic) IDCGroupItem *IDCItem;
@property (strong, nonatomic) IBOutlet UISwitch *todaySwith;
@property (strong, nonatomic) IBOutlet UISwitch *selectSwitch;

- (IBAction)todaySwitch:(id)sender;
- (IBAction)selectSwitch:(id)sender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@end
