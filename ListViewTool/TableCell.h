//
//  TableCell.h
//  ListViewTool
//
//  Created by Mac on 13-10-31.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) IBOutlet UILabel *cellContent;
@property (strong, nonatomic) IBOutlet UIButton *linkButton;

@end
