//
//  MainViewController.m
//  IDCMainView
//
//  Created by Mac on 14-3-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "GroupModel.h"
#import "AppDelegate.h"
#import "IDCGroupItem.h"
#import "ItemFolderViewController.h"
#import "JWFolders.h"
#import "ActionDoFactory.h"
#import "GroupModel.h"
#define COLUMN 4
@interface MainViewController (){
    NSMutableArray *groups;
    IBOutlet UITableView *table;
    IBOutlet UIView *LikeView;
    AppDelegate *delegate;
}

@end

@implementation MainViewController

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
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    UIBarButtonItem *reveaButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = reveaButtonItem;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggleAnimated:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    delegate = [[UIApplication sharedApplication]delegate];
    groups = delegate.groups;
    table.delegate = self;
    table.dataSource = self;
    
    [self addLikeItemForView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"refresh" object:nil];
}

-(void)addLikeItemForView{
    int total = delegate.likeItemGroup.count;
    int rows = total / COLUMN+(total%COLUMN>0?1:0);
    int with = 80;
    int height = 80;
    for (int i=0; i<total; i++) {
        IDCGroupItem *item = [delegate.likeItemGroup objectAtIndex:i];
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
        [LikeView addSubview:view];
        
    }
    
}
-(void)itemButtonClick:(UIButton *)sender{
    NSLog(@"item 点击:%d",sender.tag);
    
    int section;
    int row = sender.tag%10;
    if(sender.tag<100){
        section = 0;
    }else{
        section = sender.tag/100;
    }
    
    [self itemClick:section row:row];
    
    
    
}
-(void)refreshView{
    
    // [LikeView removeFromSuperview];
    //    if (delegate.likeItemGroup.count>0) {
    //        <#statements#>
    //    }
    
    if ([LikeView subviews].count>0) {
        for (UIView *view in [LikeView subviews]) {
            [view removeFromSuperview];
        }
    }
    
    [self addLikeItemForView];
    [LikeView setNeedsLayout];
    
    [LikeView setNeedsDisplay];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return   groups.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *label = @"tableCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:label];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:label];
    }
    GroupModel *group = [groups objectAtIndex:indexPath.row];
    cell.textLabel.text = group.title;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.scrollEnabled = YES;
    self.itemFolder = [[ItemFolderViewController alloc]init];
    CGPoint openPoint = CGPointMake(0, 250+indexPath.row*40);
    GroupModel *group = [groups objectAtIndex:indexPath.row];
    self.itemFolder.items = group.items;
    self.itemFolder.delegate = self;
    JWFolders *folders = [JWFolders folder];
    folders.contentView = self.itemFolder.view;
    folders.containerView = self.view;
    folders.position = openPoint;
    folders.direction = JWFoldersOpenDirectionUp;
    folders.transparentPane = YES;
    [folders open];
    
}
-(void)itemClick:(NSInteger)section row:(NSInteger)row{
    GroupModel *group = [groups objectAtIndex:section];
    IDCGroupItem *item = [group.items objectAtIndex:row];
    [ActionDoFactory actionDo:item viewController:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
