//
//  TableViewModelViewController.m
//  ListViewTool
//
//  Created by Mac on 13-10-27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "TableViewModelViewController.h"
#import "Item.h"
#import "TableCell.h"
#import "MJRefresh.h"
@interface TableViewModelViewController ()

@end

@implementation TableViewModelViewController{
    
    IBOutlet UITableView *_tableView;
    IBOutlet UISearchBar *_searchBar;
    NSMutableArray *_data;
    NSInteger sectionNum;
    UILabel *pagelabel;
    NSInteger currentPageNum;  //当前页数
    NSInteger countPage;   //总页数
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    _cellHight = 80.0f;
    _hitSearchBar = YES;
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPageNum = 1;
    
    [self.delegate getDate:1 searchText:nil tableView:self];
//    NSNumber *num = [self.data objectAtIndex:0];
//    countPage = [num intValue];
    //_data = [self.data objectAtIndex:1];
    
    _searchBar.hidden = _hitSearchBar;
    if(_hitSearchBar == YES){
        _searchBar.frame = CGRectMake(0, 0, 0, 0);
    }
    //去掉listview下面多余的线
    // [self setExtraCellLineHidden:_tableView];
    
    //保存当前页数
    currentPageNum = 1;
    
    // 下拉刷新
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = self;
    _header.scrollView = _tableView;
    
    // 上拉加载更多
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = self;
    _footer.scrollView = _tableView;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItem = backButton;

    
}
-(IBAction)backButtonClick:(id)sender{
    [_header free];
    [_footer free];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 代理方法-进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH : mm : ss.SSS";
    //调用代理方法获取新的数据
    if (_header == refreshView) {
        if(currentPageNum != 1){
            [self.delegate getDate:currentPageNum-1 searchText:nil tableView:self];
        }
    } else {
        if(currentPageNum != countPage){
            
            [self.delegate getDate:currentPageNum + 1 searchText:nil tableView:self];
            
        }
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:_tableView selector:@selector(reloadData) userInfo:nil repeats:NO];
}

//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // 让刷新控件恢复默认的状态
    [_header endRefreshing];
    [_footer endRefreshing];
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    pagelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    pagelabel.text = [NSString stringWithFormat:@"%d/%d",currentPageNum,countPage];
    pagelabel.textAlignment = UITextAlignmentCenter;
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:pagelabel];
    return view;
}
//返回row在section中的numbere
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}
//每一行具体显示
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *lab = @"TableCell";
    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:lab];
    if (cell == nil) {
        //系统自带cell
        //        cell = [[TableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:lab];
        //自定义cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil] lastObject];
    }
    Item *item = [_data objectAtIndex:indexPath.row];
    cell.cellTitle.text = item.title;
    cell.cellContent.text = item.content;
    if (item.hasLink) {
        cell.linkButton.hidden = NO;
    }else{
        cell.linkButton.hidden = YES;
    }
    [cell.cellContent setFrame:CGRectMake(10, 25, 305, _cellHight-30)];
    
    CGSize size = [item.content sizeWithFont:cell.cellContent.font constrainedToSize:CGSizeMake(cell.cellContent.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    CGSize labelsize = [item.content sizeWithFont:cell.cellContent.font constrainedToSize:CGSizeMake(cell.cellContent.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    //根据计算结果重新设置UILabel的尺寸
    if(size.height>labelsize.height){
        [cell.cellContent setFrame:CGRectMake(10, 25, 305,size.height)];
    }else{
        [cell.cellContent setFrame:CGRectMake(10, 25, 305,labelsize.height)];
        
    }
    return cell;
    
}
-(void)refreshTableView:(NSMutableArray *)data{
    
    NSMutableArray *array = data;
    if(array != nil && array.count != 0){
        NSString *page = [array objectAtIndex:0];
        //设置label
        pagelabel.text = page;
        currentPageNum = [[[page componentsSeparatedByString:@"/"]objectAtIndex:0] integerValue];
        countPage = [[[page componentsSeparatedByString:@"/"]objectAtIndex:1] integerValue];
        if(countPage == 0){
            countPage = 1;
        }
        _data = [array objectAtIndex:1];
        [_tableView reloadData];

        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableCell *cell =[self tableView: tableView cellForRowAtIndexPath: indexPath];

    CGFloat height=cell.cellContent.frame.size.height+30;
    if(height>45.0f){
        return height;
    }
    return 45.0f;

    //return _cellHight;
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
    //返回选中的item
    if ([self.delegate respondsToSelector:@selector(setCellOnClick:item:view:)]) {
        Item *item = [_data objectAtIndex:indexPath.row];
        [self.delegate setCellOnClick:indexPath item:item view:self];
    }
    
    
}
//设置cell修改类型
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 ){
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleInsert;
    }
}
//划动cell是否出现del按钮
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//当最下面的cell要显示的时候出现toolbar
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSArray *array = [_data objectAtIndex:sectionNum];
    //    if(indexPath.row > array.count-6){
    //        self.toolBar.hidden = NO;
    //        pageCount.hidden = NO;
    //    }else{
    //         self.toolBar.hidden = YES;
    //        pageCount.hidden = YES;
    //    }
}
//隐藏tableview下面多余的线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}

/*点击取消按钮*/
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}

/*键盘搜索按钮*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSString *searchText = searchBar.text;
    if(![searchText isEqualToString:@""]){
        [self.delegate getDate:0 searchText:nil tableView:self];
//        if(array != nil && array.count != 0){
//            NSNumber *num = [array objectAtIndex:0];
//            countPage = [num intValue];
//            currentPageNum = 1;
//            //设置label
//            pagelabel.text = [NSString stringWithFormat:@"%d/%d",currentPageNum,countPage];
//            _data = [array objectAtIndex:1];
//            [_tableView reloadData];
//            [searchBar resignFirstResponder];
//        }
    }
}

//显示加载状态图标
-(void)showDial:(UIWindow *)window
  indicatorView:(UIActivityIndicatorView *) activityIndicatorView;
{
    
    if ([[window subviews] indexOfObject:activityIndicatorView] != NSNotFound)
    {
        [window bringSubviewToFront:activityIndicatorView];
    }else
    {
        [window addSubview:activityIndicatorView];
        [window bringSubviewToFront:activityIndicatorView];
    }
    //不允许用户输入
    window.userInteractionEnabled = NO;
}




//隐藏加载状态图标

-(void) hideDial:(UIWindow *)window indicatorView:(UIActivityIndicatorView *)activityIndicatorView
{
    if ([[window subviews] indexOfObject:activityIndicatorView] != NSNotFound)
    {
        [activityIndicatorView removeFromSuperview];
    }
    //允许用户输入
    window.userInteractionEnabled = YES;
}
@end
