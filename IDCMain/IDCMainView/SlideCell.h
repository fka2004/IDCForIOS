//
//  SlideCell.h
//  IDCForIOS
//
//  Created by Mac on 14-3-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SlidCellDelegate;
@interface SlideCell : UITableViewCell
@property (strong,nonatomic) id<SlidCellDelegate> delegate;

@property (strong,nonatomic) IBOutlet UIButton *likeButton;
@property  NSInteger likeButtonState;
@property (strong,nonatomic) IBOutlet UILabel *actualLabel;
@end

@protocol SlidCellDelegate <NSObject>

-(void)likeButtonClick:(NSInteger)index;

@end

