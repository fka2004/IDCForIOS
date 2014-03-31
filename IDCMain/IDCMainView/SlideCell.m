//
//  SlideCell.m
//  IDCForIOS
//
//  Created by Mac on 14-3-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SlideCell.h"
#import "AppDelegate.h"
@interface SlideCell()<UIGestureRecognizerDelegate>{

    IBOutlet UIView *buttonView;
    UIView *buttonlView;
    IBOutlet UIView *actualView;
    CGFloat initialTouchPositionX;
    BOOL customEditingAnimationInProgress;
    BOOL contextMenuHidden;
    CGFloat bounceValue;
    CGFloat contextMenuWidth;
}

@end
@implementation SlideCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }


    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    if(self.likeButtonState == 0){
        [self.likeButton setImage:[UIImage imageNamed:@"likeBefore.png"] forState:UIControlStateNormal];
    }else{
        [self.likeButton setImage:[UIImage imageNamed:@"likeAfter.png"] forState:UIControlStateNormal];
    }
    
    contextMenuHidden = YES;
    bounceValue = 30;
    contextMenuWidth = 80;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
   
    panRecognizer.delegate = self;
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipeRecognizer];
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipeRecognizer];
//    [self addGestureRecognizer:panRecognizer];
}
- (IBAction)likeButtonClick:(id)sender {
    NSLog(@"like button click");
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    //改变图片
    if(self.likeButtonState == 0){
        if(delegate.likeItemGroup.count == 8){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"常用设置数量已到达上限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        self.likeButtonState = 1;
         [self.likeButton setImage:[UIImage imageNamed:@"likeAfter.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            actualView.frame = CGRectMake(0, 0, 320, 40);
        } completion:^(BOOL finished) {
            
        }];

    }else{
        self.likeButtonState = 0;
        [self.likeButton setImage:[UIImage imageNamed:@"likeBefore.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            actualView.frame = CGRectMake(0, 0, 320, 40);
        } completion:^(BOOL finished) {
            
        }];

    }
    
    if([self.delegate respondsToSelector:@selector(likeButtonClick:)]){
        [self.delegate likeButtonClick:self.tag];
    }
}
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
    if([recognizer isKindOfClass:[UISwipeGestureRecognizer class]]){
        [UIView animateWithDuration:0.2f animations:^{
           actualView.frame = CGRectMake(0, 0, 320, 40);
        } completion:^(BOOL finished) {
           
        }];

    }
    [self setNeedsLayout];
    
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    if([recognizer isKindOfClass:[UISwipeGestureRecognizer class]]){
        if([recognizer isKindOfClass:[UISwipeGestureRecognizer class]]){
            [UIView animateWithDuration:0.2f animations:^{
                actualView.frame = CGRectMake(-60, 0, 250, 40);
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }
        
}
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if([recognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
        
        CGPoint currentTouchPoint = [panRecognizer locationInView:self.contentView];
        CGFloat currentTouchPositionX = currentTouchPoint.x;
        CGPoint velocity = [recognizer velocityInView:self.contentView];
        if(recognizer.state == UIGestureRecognizerStateBegan){
            initialTouchPositionX = currentTouchPositionX;
            if(velocity.x>0){
                NSLog(@"开始向右滑动");
                customEditingAnimationInProgress = YES;
            }else{
                NSLog(@"开始向左滑动");
            }
        }else if(recognizer.state == UIGestureRecognizerStateChanged){
            CGPoint velocity = [recognizer velocityInView:self.contentView];
            if (contextMenuHidden || (velocity.x>0  )) {
                if (self.selected) {
                    [self setSelected:NO animated:NO];
                }
                //慢慢出现下面的view
                CGFloat panAmout = currentTouchPositionX - initialTouchPositionX;
                CGFloat minOriginX = -contextMenuWidth - bounceValue;
                CGFloat maxOriginX = 0;
                CGFloat originX = CGRectGetMinX(actualView.frame) + panAmout;
                originX = MIN(maxOriginX, originX);
                originX = MAX(minOriginX, originX);
                NSLog(@"x:%f",originX);
                actualView.frame = CGRectMake(originX, 0, 320, 40);
                
//                self.actualContentView.frame = CGRectMake(originX, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            }else{
                
            }
        }
        
    }
     [self setNeedsLayout];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
