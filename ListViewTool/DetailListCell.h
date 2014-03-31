//
//  DetailListCell.h
//  ListViewTool
//
//  Created by Mac on 13-11-4.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *detailContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailContent;
@property (strong, nonatomic) IBOutlet UIButton *linkButton;
@property (strong, nonatomic) IBOutlet UIView *labelView;
@property (strong, nonatomic) IBOutlet UIView *contentView;


@end
