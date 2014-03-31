//
//  NotifyTableCell.h
//  IDCForIOS
//
//  Created by Mac on 14-3-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifyTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet UILabel *cellContent;
@property (strong, nonatomic) IBOutlet UIButton *cellButton;
@property BOOL hitButton;
@end
