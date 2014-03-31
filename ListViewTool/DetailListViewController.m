//
//  DetailListViewController.m
//  ListViewTool
//
//  Created by Mac on 13-11-4.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "DetailListViewController.h"
#import "DetailItem.h"
#import "DetailListCell.h"

@interface DetailListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DetailListViewController
{
    NSMutableArray *_data;
    NSInteger sectionNum;
    UIButton *butt; //section 的 button
    NSMutableArray *stateArray;
}

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
    if ([self.delegate respondsToSelector:@selector(getDate)]) {
        [self.delegate getDate];

    }
    //隐藏多余线
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];
    



    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItem = backButton;
}
-(void)backButtonClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)refreshTableView:(NSMutableArray *)data{
    NSMutableArray *array = data;
    if(array != nil && array.count != 0){
        _data = data;
        [_tableView reloadData];
        
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        stateArray = [[NSMutableArray alloc]init];
        for (int i=0; i<_data.count; i++) {
            if(i==0){
                [stateArray addObject: [[NSNumber alloc]initWithInt:1]];
            }else{
                [stateArray addObject: [[NSNumber alloc]initWithInt:0]];
            }
            
        }

    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
//每一行具体显示
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *lab = @"TableCell";
    DetailListCell *cell = (DetailListCell *)[tableView dequeueReusableCellWithIdentifier:lab];
    if (cell == nil) {

        //自定义cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailListCell" owner:self options:nil] lastObject];
    }
    DetailItem *item = [_data objectAtIndex:indexPath.row];
    cell.detailContentLabel.text = item.detailLabel;
    cell.detailContent.text = item.detailContent;
    
    //宽度不变，根据字的多少计算label的高度
    
    //cell.contentView.backgroundColor = [UIColor greenColor];
    cell.detailContentLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.detailContentLabel.font = [UIFont systemFontOfSize:12.0f];
    CGSize size = [item.detailContent sizeWithFont:cell.detailContent.font constrainedToSize:CGSizeMake(cell.detailContent.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    CGSize labelsize = [item.detailLabel sizeWithFont:cell.detailContentLabel.font constrainedToSize:CGSizeMake(cell.detailContentLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //根据计算结果重新设置UILabel的尺寸
//    if(size.height>labelsize.height){
//        [cell.detailContentLabel setFrame:CGRectMake(5, 0, 100,size.height)];
//        [cell.detailContent setFrame:CGRectMake(110, 0, 180,size.height)];
//    }else{
//        [cell.detailContentLabel setFrame:CGRectMake(5, 0, 100,labelsize.height)];
//        [cell.detailContent setFrame:CGRectMake(110, 0, 180,labelsize.height)];
//    }
    if(size.height>labelsize.height){
        if(size.height<45.0){
            [cell.detailContentLabel setFrame:CGRectMake(0, 0, 100,45)];
            [cell.detailContent setFrame:CGRectMake(110, 0, 180,45)];
            [cell setFrame:CGRectMake(0, 0, 320,45)];
        }else{
            [cell.detailContentLabel setFrame:CGRectMake(0, 0, 100,size.height)];
            [cell.detailContent setFrame:CGRectMake(110, 0, 180,size.height)];
            [cell setFrame:CGRectMake(0, 0, 320,size.height)];
        }
        
        
    }else{
        
        if(labelsize.height<45.0){
            [cell setFrame:CGRectMake(0, 0, 320,45)];
            [cell.detailContentLabel setFrame:CGRectMake(0, 0, 100,45)];
            [cell.detailContent setFrame:CGRectMake(110, 0, 180,45)];
        }else{
            [cell.detailContentLabel setFrame:CGRectMake(0, 0, 100,labelsize.height)];
            [cell.detailContent setFrame:CGRectMake(110, 0, 180,labelsize.height)];
            [cell setFrame:CGRectMake(0, 0, 320,labelsize.height)];
        }
    }
    //设置fram自动缩小以适应文字
    //[cell.detailContentLabel sizeToFit];
    //改变cell北京颜色
   // [cell.detailContentLabel setBackgroundColor:[UIColor grayColor]];
    if(!item.hasLink){
        cell.linkButton.hidden = YES;
    }
    cell.linkButton.tag = (indexPath.section+1)*100+indexPath.row;
    [cell.linkButton addTarget:self action:@selector(linkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
//linkbutton点击
-(void)linkButtonClick:(UIButton *)sender{
    NSLog(@"link~~~~~~~~");
    NSInteger tag = sender.tag;
    NSInteger section = tag/100 -1;
    NSInteger row = tag%100;
    DetailItem *item = [[_data objectAtIndex:section]objectAtIndex:row];
    [self.delegate setLinkButtonOnClick:section row:row detailItem:item];
}
//点击cell高亮
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//点击row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    if([self.delegate respondsToSelector:@selector(setDetailCellOnClick:)]){
        [self.delegate setDetailCellOnClick:indexPath];
    }
        
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailListCell *cell=[self tableView: tableView cellForRowAtIndexPath: indexPath];
    
    //CGFloat height=cell.textLabel.frame.size.height+cell.detailTextLabel.frame.size.height;
    CGFloat height=cell.detailContent.frame.size.height;
    if(height>45.0f){
        return height;
    }
    return 45.0f;
}
//设置标头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
