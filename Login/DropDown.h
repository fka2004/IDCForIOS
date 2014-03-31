//
//  DropDown.h
//  DropDown
//
//  Created by JackZhang on 13-10-29.
//  Copyright (c) 2013年 JackZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDown : UIView <UITableViewDelegate,UITableViewDataSource> {
    UITableView *tv;//下拉列表
    NSMutableArray *tableArray;//下拉列表数据
    UITextField *textField;//文本输入框
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
    CGFloat dropDownHeight;
    CGFloat dropDownY;
    @public
    BOOL showList;//是否弹出下拉列表
}
@property BOOL _showList;
@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *tableArray;
@property (nonatomic,retain) UITextField *textField;
-(id)initWithFrame:(CGRect)frame andField:(UITextField *)field;
-(void)show;
-(void)hidden;
@end
