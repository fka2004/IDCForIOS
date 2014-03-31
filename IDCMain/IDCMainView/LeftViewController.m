//
//  LeftViewController.m
//  IDCMainView
//
//  Created by Mac on 14-3-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "GroupModel.h"
#import "IDCGroupItem.h"
#import "SlideCell.h"
#import "ActionDoFactory.h"
#import "LikeItemDB.h"
@interface LeftViewController (){
    NSMutableArray *groups;
    IBOutlet UITableView *table;
    NSMutableArray *stateArray;
    UIButton *butt; //section 的 button
    NSInteger sectionNum;
    AppDelegate *delegate;
}

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.view.backgroundColor = [UIColor redColor];
    self.title=@"快速查看";
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //显示功能列表
    delegate = [[UIApplication sharedApplication]delegate];
    groups = delegate.groups;
    table.delegate = self;
    table.dataSource = self;
    stateArray = [[NSMutableArray alloc]init];
    
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
    //[butt setBackgroundImage:[UIImage  imageNamed:<#(NSString *)#>]forState:UIControlStateNormal];
//    [butt addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
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
    SlideCell *cell = (SlideCell *)[tableView dequeueReusableCellWithIdentifier:label];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SlideCell" owner:self options:nil] lastObject];
    }

    GroupModel *group = [groups objectAtIndex:indexPath.section];
    IDCGroupItem *item = [group.items objectAtIndex:indexPath.row];
    NSMutableString *str = [[NSMutableString alloc]initWithString:@"    "];
    [str appendFormat:item.text];
    cell.actualLabel.text = str;
    if(item.isLike){
        cell.likeButtonState = 1;
    }else{
        cell.likeButtonState = 0;
    }
    cell.tag = indexPath.section *100 + indexPath.row;
    cell.delegate = self;
    return cell;
}
-(void)likeButtonClick:(NSInteger)index{
    GroupModel *group = [groups objectAtIndex:index/100];
    IDCGroupItem *item = [group.items objectAtIndex:index%100];
    LikeItemDB *db = [[LikeItemDB alloc]init];
    if(item.isLike){
        item.isLike = NO;
        [db deleteLikeItem:item.idIdentity];
        //删除delegat中收藏数据的数据
        for (int i=0; i<delegate.likeItemGroup.count; i++) {
            IDCGroupItem *likeItem = [delegate.likeItemGroup objectAtIndex:i];
            if([likeItem.idIdentity isEqualToString:item.idIdentity]){
                [delegate.likeItemGroup removeObject:likeItem];
            }
        }
    }else{
        item.isLike = YES;
        [db insertLikeItem:item.idIdentity];
        //添加likeItem
        [delegate.likeItemGroup addObject:item];
    }
    [group.items replaceObjectAtIndex:index%100 withObject:item];
    [delegate.groups replaceObjectAtIndex:index/100 withObject:group];
    groups = delegate.groups;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.scrollEnabled = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSMutableArray *groups = appDelegate.groups;
    GroupModel *group = [groups objectAtIndex:indexPath.section];
    IDCGroupItem *item = [group.items objectAtIndex:indexPath.row];
    [ActionDoFactory actionDo:item viewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
