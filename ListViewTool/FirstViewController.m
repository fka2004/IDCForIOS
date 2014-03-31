//
//  FirstViewController.m
//  ListViewTool
//
//  Created by Mac on 13-10-27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "FirstViewController.h"
#import "TableViewModelViewController.h"
#import "Item.h"
#import "DetailListViewController.h"
#import "DetailItem.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

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
    // Do any additional setup after loading the view from its nib.
    
}
- (IBAction)btnTwo:(id)sender {

    DetailListViewController *table = [[DetailListViewController alloc] initWithNibName: @"DetailListViewController" bundle:nil];
    table.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:table];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
- (IBAction)btnClick:(id)sender {
    
    TableViewModelViewController *table = [[TableViewModelViewController alloc] initWithNibName: @"TableViewModelViewController" bundle:nil];
    
    table.delegate = self;  
    table.pageNum= @"2/10";
    table.hitSearchBar = NO;
    CGFloat cellHight = 100.0f;
    table.cellHight = cellHight;
    
    //    DetailListViewController *table = [[DetailListViewController alloc] initWithNibName: @"DetailListViewController" bundle:nil];
    //    table.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:table];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}
-(NSMutableArray *)refreshDate{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        
        NSMutableArray *subArray = [[NSMutableArray alloc] init];
        for (int j = 26; j < 50; j++) {
            Item *item = [[Item alloc] init];
            NSString *str = [NSString stringWithFormat:@"%i",j];
            item.title = str;
            item.content = str;
            [subArray addObject:item];
        }
        [array addObject:subArray];
    }
    return array;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCellOnClick:(NSIndexPath *)indexPath item:(Item *)item
{
    
    NSLog(@"frist %d",indexPath.row);
}
-(NSMutableArray *)onSearchBarClick:(NSString *)searchText
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        
        NSMutableArray *subArray = [[NSMutableArray alloc] init];
        for (int j = 26; j < 50; j++) {
            Item *item = [[Item alloc] init];
            NSString *str = [NSString stringWithFormat:@"%i",j];
            item.title = str;
            item.content = str;
            [subArray addObject:item];
        }
        [array addObject:subArray];
    }
    
    return array;
    
}
//详细信息获取数据
-(NSMutableArray *)getDate{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<5; i++) {
        NSMutableArray *subArray = [[NSMutableArray alloc] init];
        for (int j = 0; j < 5; j++) {
            DetailItem *item = [[DetailItem alloc] init];
            NSString *str = [NSString stringWithFormat:@"%i",j];
            item.detailLabel = str;
            item.detailContent = @"夜空中最亮的星 能否听清那仰望的人心底的孤独和叹息夜空中最亮的星 能否记起曾与我同行 消失在风里的身影我祈祷拥有一颗透明的心灵 和会流泪的眼睛给我再去相信的勇气 噢 越过谎言去拥抱你每当我找不到存在的意义 每当我迷失在黑夜里 噢";
            item.groupName = str;
            item.hasLink = YES;
            [subArray addObject:item];
        }
        
        [array addObject:subArray];
    }
    return array;
}

-(NSMutableArray *)getDate:(NSInteger)pageNum searchText:(NSString *)text{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSNumber *countPage = [NSNumber numberWithInt:10];
    [array addObject:countPage];
    NSMutableArray *subArray = [[NSMutableArray alloc] init];
    for (int j = 0; j < 5; j++) {
        Item *item = [[Item alloc] init];
        NSString *str = [NSString stringWithFormat:@"%i",j];
        item.title = @"你好的啊发生噶是的鬼斧神工风格";
        item.content = @"你好的啊发生噶是的的啊发生噶是的的啊发生噶是的鬼斧神的啊发生噶是的的啊发生噶是的的啊发生噶是的风格";
        [subArray addObject:item];
    }
    [array addObject:subArray];
    return array;
    
}
-(void)setDetailCellOnClick:(NSIndexPath *)indexPath{
    NSLog(@"deatil cell click");
}
-(void)setLinkButtonOnClick:(NSInteger)section row:(NSInteger)row detailItem:(DetailItem *)detailItem{
    NSLog(@"section:%d   row:%d",section,row);
}
@end
