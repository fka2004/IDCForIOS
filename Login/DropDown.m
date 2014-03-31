//
//  DropDown.m
//  DropDown
//
//  Created by JackZhang on 13-10-29.
//  Copyright (c) 2013年 JackZhang. All rights reserved.
//

#import "DropDown.h"
#import "CustomColor.h"
@interface DropDown ()

@end

@implementation DropDown
@synthesize tv,tableArray,textField,_showList=showList;


#pragma mark 初始化DropDown
-(id)initWithFrame:(CGRect)frame andField:(UITextField *)field
{
    NSLog(@"=====xxxxx=======%f========%f",frame.origin.x,frame.origin.y);
    dropDownY=frame.origin.y;
    textField=field;
    if (frame.size.height<200) {
        frameHeight = 200;
    }else{
        frameHeight = frame.size.height;
    }
    tabheight = frameHeight-30;
    
    frame.size.height = 30.0f;
    
    self=[super initWithFrame:frame];
    
    if(self){
        showList = NO; //默认不显示下拉框
        
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0) style:UITableViewStylePlain];

        tv.delegate = self;
        tv.dataSource = self;
        tv.backgroundColor = [CustomColor WhiteSmokeColor];
        tv.separatorColor = [UIColor grayColor];
        tv.separatorStyle=UITableViewStyleGrouped;
        tv.hidden = YES;
        [self addSubview:tv];
                
    }
    return self;
}
#pragma mark 显示DropDown
-(void)show{
    NSLog(@"已隐藏，显示");
    CGRect sf = self.frame;
    sf.size.height = frameHeight;
    
    //把dropdownList放到前面，防止下拉框被别的控件遮住
    [self.superview bringSubviewToFront:self];
    tv.hidden = NO;
    showList = YES;//显示下拉框
    
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
    frame.size.height = tabheight;
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.frame = sf;
    //[tv makeInsetShadowWithRadius:3.0 Alpha:0.1];
    
    frame.size.height=35*[tableArray count];
    tv.frame = frame;
  
    /*
    tv.layer.backgroundColor = [UIColor orangeColor].CGColor;
    //tv.layer.cornerRadius = 3.0;
    tv.layer.shadowOffset = CGSizeMake(0, 3);
    tv.layer.shadowRadius = 5.0;
    tv.layer.shadowColor = [UIColor blackColor].CGColor;
    tv.layer.shadowOpacity = 0.8;
    tv.layer.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);

    tv.layer.borderColor=[CustomColor LessBlack].CGColor;
    tv.layer.borderWidth=0.6;*/
    
    /*
    tv.clipsToBounds = YES;
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderColor = [CustomColor LessBlack].CGColor;
    rightBorder.borderWidth = 0.55;
    rightBorder.frame = CGRectMake(0, -1, CGRectGetWidth(tv.frame), CGRectGetHeight(tv.frame)+2);
    [tv.layer addSublayer:rightBorder];*/
    
    /*
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [CustomColor LessBlack].CGColor;
    bottomBorder.borderWidth = 0.55;
    bottomBorder.frame = CGRectMake(0, [tableArray count]*35-1, CGRectGetWidth(tv.frame), 1);
    [tv.layer addSublayer:bottomBorder];*/
    
    [UIView commitAnimations];
}
#pragma mark 隐藏DropDown
-(void)hidden{
    showList=NO;
    tv.hidden=true;
    CGRect sf = self.frame;
    sf.size.height = 30;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.textLabel.text = [[tableArray objectAtIndex:[indexPath row]] objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    
    NSLog(@"=========tablearray========%@====count:%i",tableArray,[tableArray count]);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image= [UIImage   imageNamed:@"delete4.png"];
    
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.backgroundColor= [UIColor clearColor];
    cell.accessoryView=button;

    [button addTarget:self action:@selector(doDeleteItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTag:[indexPath row]];
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSLog(@"=======row=====%i====%f",[indexPath row],dropDownY);


    
    return cell;
}
#pragma mark 删除用户记录
-(void)doDeleteItem:(id)sender{
    NSLog(@"-----tag---%d---",[sender tag]);

    NSLog(@"---------%@-----drop1====count:%i",tableArray,[tableArray count]);
    [tableArray removeObjectAtIndex:[sender tag]];
    
    NSLog(@"---------%@-----drop2====count:%i",tableArray,[tableArray count]);

    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    NSLog(@"========plistPath1=%@",plistPath1);
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"loginedUser.plist"];
    
    NSLog(@"=====filename===%@",filename);
    
    //输入写入
    //[tableArray writeToFile:filename atomically:YES];
    CGRect frame = tv.frame;
    
    frame.size.height=35*[tableArray count];
    
    tv.frame = frame;
    [tv reloadData];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndex");
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndex");
    textField.text = [[tableArray objectAtIndex:[indexPath row]] objectForKey:@"name"];
    NSLog(@"textField.text=%@ and text=%@",textField.text,[tableArray objectAtIndex:[indexPath row]]);
    showList = NO;
    tv.hidden = YES;
    
    CGRect sf = self.frame;
    sf.size.height = 30;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
