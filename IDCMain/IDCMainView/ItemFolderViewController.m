//
//  ItemFolderViewController.m
//  IDCForIOS
//
//  Created by Mac on 14-3-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ItemFolderViewController.h"
#import "IDCGroupItem.h"
#import "ActionDoFactory.h"
#define COLUMN 4
@interface ItemFolderViewController ()

@end

@implementation ItemFolderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"folder_bg.png"]];
    int total = self.items.count;
    int rows = total / COLUMN+(total%COLUMN>0?1:0);
    int with = 80;
    int height = 80;
    for (int i=0; i<total; i++) {
        IDCGroupItem *item = [self.items objectAtIndex:i];
        int xIndex = i % COLUMN;
        int yIndex = i / COLUMN;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(xIndex * with, yIndex * height+12, with, height)];
        UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, with-20, height-30)];
        
        NSError *error;
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *home = [@"~" stringByExpandingTildeInPath];
        NSString *fileDirName = @"cntomorrow";
        NSString *path = [home stringByAppendingString:@"/Documents"];
        path = [path stringByAppendingPathComponent:fileDirName];
        NSMutableString *iconName = [[NSMutableString alloc]initWithString:item.icon];
        NSRange rang = [iconName rangeOfString:@"download/com.cntomorrow.mobile.framework/image/"];
        iconName = [iconName substringFromIndex:rang.location+rang.length];
        path = [path stringByAppendingPathComponent:iconName];
        //        [imageButton setBackgroundImage:[UIImage imageNamed:@"icon2.png"] forState:UIControlStateNormal];
        [imageButton setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        
        [imageButton addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.tag = item.indexPath.section*100 + item.indexPath.row;
        UILabel *itemText = [[UILabel alloc]initWithFrame:CGRectMake(0, height-30, with, 30)];
        
        [itemText setBackgroundColor:[UIColor clearColor]];
        [itemText setTextColor:[UIColor whiteColor]];
        
        itemText.text = item.text;
        itemText.font = [UIFont fontWithName:@"Helvetica" size:12];
        [itemText setTextAlignment:NSTextAlignmentCenter];
        
        [view addSubview:itemText];
        [view addSubview:imageButton];
        [self.view addSubview:view];
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = height * rows + 19;
    
    self.view.frame = viewFrame;
}
-(void)itemButtonClick:(UIButton *)sender{
    NSLog(@"item 点击:%d",sender.tag);
    if ([self.delegate respondsToSelector:@selector(itemClick:row:)]) {
        int section;
        int row = sender.tag%10;
        if(sender.tag<100){
            section = 0;
        }else{
            section = sender.tag/100;
        }
//        IDCGroupItem *item = [self.items objectAtIndex:row];
        [self.delegate itemClick:section row:row];
        [self dismissViewControllerAnimated:YES completion:nil];
//        [ActionDoFactory actionDo:item viewController:self];
    }
   

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
