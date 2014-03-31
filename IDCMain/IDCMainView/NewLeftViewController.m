//
//  NewLeftViewController.m
//  IDCForIOS
//
//  Created by Mac on 14-3-20.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "NewLeftViewController.h"
#import "LeftViewController.h"
#import "AppDelegate.h"
#import "GroupModel.h"
#import "IDCGroupItem.h"
#import "SlideCell.h"
#import "YFJLeftSwipeDeleteTableView.h"
@interface NewLeftViewController (){
    NSMutableArray *groups;
    YFJLeftSwipeDeleteTableView *table;
    NSMutableArray *stateArray;
    UIButton *butt; //section 的 button
    NSInteger sectionNum;
}

@end

@implementation NewLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.view.backgroundColor = [UIColor redColor];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    table = [[YFJLeftSwipeDeleteTableView alloc]initWithFrame:CGRectMake(0, 0, 262,self.view.bounds.size.height )];
    //显示功能列表
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    groups = delegate.groups;
    table.delegate = self;
    table.dataSource = self;
    stateArray = [[NSMutableArray alloc]init];
    [self.view addSubview:table];
    
    for (int i=0; i<groups.count; i++) {
        [stateArray addObject: [[NSNumber alloc]initWithInt:1]];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GroupModel *group = [groups objectAtIndex:section];
    NSNumber *state = [stateArray objectAtIndex:section];
    NSNumber *oldstate = [[NSNumber alloc]initWithInt:0];
    
    if([state isEqualToNumber:oldstate]){
        return 0;
    }
    
    return group.items.count;
}
//标题上加控件
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView;
    UILabel *sectionLabel;
    
    sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    sectionView.backgroundColor = [UIColor whiteColor];
    sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 30)];
    sectionLabel.backgroundColor = [UIColor whiteColor];
    butt = [UIButton buttonWithType:UIButtonTypeCustom];
    butt.frame = CGRectMake(210, 0, 20, 20);
    
    sectionView.opaque = NO;
    GroupModel *group = [groups objectAtIndex:section];
    sectionLabel.text = group.title;
    
    
    butt.tag = section;
    
    [butt setImage:[UIImage imageNamed:@"gotoa.png"] forState:UIControlStateNormal];
    NSNumber *i = [stateArray objectAtIndex:section];
    
    if ( [i intValue] == 1) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI_2);
        [butt setTransform:rotation];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    sectionView.tag = section;
    [sectionView addGestureRecognizer:tap];
    
    [sectionView addSubview:butt];
    [sectionView addSubview:sectionLabel];
    
    return sectionView;
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//展开section按钮点击事件
-(void)btnClick:(UIGestureRecognizer *)sender
{
    sectionNum = sender.view.tag;
    if([[stateArray objectAtIndex:sectionNum]isEqualToNumber:[[NSNumber alloc]initWithInt:0]]){
        [stateArray replaceObjectAtIndex:sectionNum withObject:[[NSNumber alloc]initWithInt:1]];
    }else{
        [stateArray replaceObjectAtIndex:sectionNum withObject:[[NSNumber alloc]initWithInt:0]];
        
    }
    
    //刷新指定section
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:sectionNum];
    [table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    if([[stateArray objectAtIndex:sectionNum]isEqualToNumber:[[NSNumber alloc]initWithInt:1]]){
        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI_2);
        [butt setTransform:rotation];
    }
    //    [_tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return groups.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *label = @"tableCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:label];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:label];
    }
    
    GroupModel *group = [groups objectAtIndex:indexPath.section];
    IDCGroupItem *item = [group.items objectAtIndex:indexPath.row];
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"    "];
    [str appendFormat:item.text];
    cell.textLabel.text = str;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.scrollEnabled = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
