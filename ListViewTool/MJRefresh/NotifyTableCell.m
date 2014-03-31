//
//  NotifyTableCell.m
//  IDCForIOS
//
//  Created by Mac on 14-3-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "NotifyTableCell.h"

@implementation NotifyTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    if (self.hitButton) {
        self.cellButton.hidden = self.hitButton;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
