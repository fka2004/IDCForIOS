//
//  RightViewController.m
//  IDCMainView
//
//  Created by Mac on 14-3-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RightViewController.h"
#import "EditPasswordViewController.h"
@interface RightViewController (){

    IBOutlet UITableView *table;
    NSMutableArray *dataArray;
}

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.view.backgroundColor = [UIColor greenColor];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    table.delegate = self;
    table.dataSource = self;
    dataArray = [[NSMutableArray alloc]init];
//    WithObjects:@"修改密码",@"帮助",@"注销帐号" nil
    NSString *str = [[NSString alloc]initWithString:@"            修改密码"];
    [dataArray addObject:str];
    str = @"            帮助";
    [dataArray addObject:str];
    str = @"            注销帐号";
    [dataArray addObject:str];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return   dataArray.count;
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
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [table deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        EditPasswordViewController *editPassword = [[EditPasswordViewController alloc]init];
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:editPassword];
        [self presentViewController:nv animated:YES completion:nil];
    }
    
}
@end
