//
//  LoginController.m
//  IDC
//
//  Created by JackZhang on 13-11-12.
//  Copyright (c) 2013年 JackZhang. All rights reserved.
//

#import "LoginController.h"
#import "LoadingView.h"
#import "CustomColor.h"
#import "DropDown.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "MainViewController.h"
#import "HttpDownload.h"
#import "HttpDownloadDelegate.h"
#import "AppUtils.h"
#import "SBJson.h"
#import "GroupModel.h"
#import "TBXML.h"
#import "IDCGroupItem.h"
#import "SWRevealViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MainViewController.h"
#import "NewLeftViewController.h"
#import "HHNetwork.h"
#import "SBJson.h"
#import "LikeItemDB.h"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//判断系统版本
#define iOS7 ([[[UIDevice currentDevice]systemVersion]floatValue]>6.5?YES:NO)
@interface LoginController (){
    //登录访问网络接收的数据
    NSMutableString *result;
    NSString *name;
    //loginuser plist文件地址
    NSString *filePath;
    NSMutableData *resultData;
}


@end

@implementation LoginController
@synthesize nameField,pwdField,setting,revealPwdLabel,groups;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    groups=[[NSMutableArray alloc] init];
    fontSize=14.0;
    respdata=[[NSMutableData alloc] init];
    UIImage *background = [UIImage imageNamed:@"login.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:background];
    
    CGRect  rect=[[UIScreen mainScreen] bounds];
    
    width=rect.size.width;
    height=rect.size.height;
    NSLog(@"valueDevice: %f ...%f", width,height);
    
    
    
    //将userplist写入沙盒
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *doucumentsDirectiory = [paths objectAtIndex:0];
    
    
    //得到完整的文件名
    filePath = [doucumentsDirectiory stringByAppendingPathComponent:@"loginedUser.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]){
        //如果文件不存在则创建
        NSFileManager *fileMang = [NSFileManager defaultManager];
        [fileMang createFileAtPath:filePath contents:nil attributes:nil];
    }else{
        //输入写入
        //[userData writeToFile:filename atomically:YES];
        
        //读出沙盒中的数据
        NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        
        userData=data1;
        NSLog(@"data1--------%@", data1);
        
        NSLog(@"userData=======%@",userData);
        
    }
    
    
    defaultSettings=[NSUserDefaults standardUserDefaults];
    
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    
    if(iPhone5){
        loginFrameY=(170/480.00)*height+10;
    }else{
        loginFrameY=(170/480.00)*height;
    }
    
    UITableView *loginView = [[UITableView alloc] initWithFrame:CGRectMake(width/2-240/2, loginFrameY, 240, 120) style:UITableViewStylePlain];
    loginView.delegate = self;
    loginView.dataSource = self;
    loginView.scrollEnabled = NO;
    
    //[loginView makeInsetShadowWithRadius:3 Alpha:0.7];
    
    [self.view addSubview:loginView];
    
    
    UITapGestureRecognizer *tapRemPwd=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSetting)];
    
    tapRemPwd.numberOfTapsRequired=1;
    self.setting=[[UILabel alloc] initWithFrame:CGRectMake(width/2-240/2, loginFrameY+85, 120, 30)];
    [setting setText:@"设置"];
    [self.setting setTextColor:[UIColor grayColor]];
    self.revealPwdLabel.backgroundColor=[UIColor redColor];
    self.setting.font=[UIFont systemFontOfSize:fontSize];
    
    [self.setting addGestureRecognizer:tapRemPwd];
    
    [self.setting setTextAlignment:NSTextAlignmentCenter];
    self.setting.userInteractionEnabled = YES;
    
    [self.view addSubview:self.setting];
    
    UITapGestureRecognizer *tapRevealPwd=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doRevealPwd)];
    tapRevealPwd.numberOfTapsRequired=1;
    self.revealPwdLabel=[[UILabel alloc] initWithFrame:CGRectMake(width/2-240/2+120, loginFrameY+85, 120, 30)];
    BOOL revealFlag=[defaultSettings boolForKey:@"revealPwd"];
    
    if (revealFlag) {
        [self.revealPwdLabel setText:@"√ 显示密码"];
    }else{
        [self.revealPwdLabel setText:@"显示密码"];
    }
    self.revealPwdLabel.font=[UIFont systemFontOfSize:fontSize];
    [self.revealPwdLabel setTextColor:[UIColor grayColor]];
    [self.revealPwdLabel addGestureRecognizer:tapRevealPwd];
    [self.revealPwdLabel setTextAlignment:NSTextAlignmentCenter];
    self.revealPwdLabel.userInteractionEnabled = YES;
    
    [self.view addSubview:self.revealPwdLabel];
    
    //separate line
    UILabel *labelSeparate=[[UILabel alloc] initWithFrame:CGRectMake(width/2, loginFrameY+80, 1, 40)];
    [labelSeparate setBackgroundColor:[CustomColor GrayColor]];
    //[self.view addSubview:labelSeparate];
    
    //add login btn code
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
    loginBtn.frame=CGRectMake(width/2-240/2, loginFrameY+80+50, 240, 35);
    [loginBtn addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font=[UIFont systemFontOfSize:fontSize];
    
    [loginBtn setBackgroundImage:[[UIImage imageNamed:@"blue1.png"]stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
    
    
    [self.view addSubview:loginBtn];
    
    
}

#pragma mark 清除软键盘
- (void)dismissKeyboard{
    [nameField resignFirstResponder];
    [pwdField resignFirstResponder];
    
}

#pragma mark 显示密码
- (void)doRevealPwd{
    [nameField resignFirstResponder];
    [pwdField resignFirstResponder];
    
    BOOL keyValue=[defaultSettings boolForKey:@"revealPwd"];
    
    if(keyValue){
        [defaultSettings setBool:NO forKey:@"revealPwd"];
        [self.revealPwdLabel setText:@"显示密码"];
        self.pwdField.secureTextEntry=YES;
    }else{
        [defaultSettings setBool:YES forKey:@"revealPwd"];
        [self.revealPwdLabel setText:@"√ 显示密码"];
        self.pwdField.secureTextEntry=NO;
    }
    [defaultSettings synchronize];
    
    
}
#pragma mark 设置
- (void)doSetting{
    SettingViewController *settingView = [[SettingViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:settingView];
    [self presentViewController:nav animated:YES completion:nil];
    settingView.title = @"地址设置";
    
    
}

#pragma mark 登陆
- (void)doLogin
{
    [self.nameField setText:@"bdyz"];
    [self.pwdField setText:@"bdyz@123"];
    
    name = self.nameField.text;
    NSString *pwd = self.pwdField.text;
    NSString *message = [[NSString alloc] init];
    BOOL a = [AppUtils IsEnable3G];
//    if([AppUtils IsEnable3G]==NO && [AppUtils IsEnableWIFI]==NO ){
//        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用,请连接网络后再试." delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
//        [alertView show];
//    }else
    if (name == nil || name.length == 0 ) {
        message = @"用户名不能为空";
    } else if (pwd == nil || pwd.length == 0) {
        message = @"密 码不能为空";
        
    } else {
        
        //asynchronous request
        loadingView=[LoadingView shareLoadingView:@"登录中..."];
        [loadingView show];
        //访问webservice
        resultData = [[NSMutableData alloc]init];
        NSString *soapMessage;
        //获取imei
        NSString *imei = [AppUtils getImei];
        imei = @"12345";
        NSString *model = [AppUtils getDeviceModel];
        NSString *inRoomNum = @"1";
        NSString *accountType = @"1";
        //不加下面的ns1的话服务端接收不到参数
        soapMessage = [NSString stringWithFormat:
                       @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tns=\"http://services.lansoft.com/\">\n"
                       "<soap:Body>\n"
                       "<ns1:MobileLogin xmlns:ns1=\"http://192.168.203.129:8080/HuasunMobileInterface/Services/MobileServiceIDC/MobileLogin/\">\n"
                       "<UserName>%@</UserName>\n"
                       "<Password>%@</Password>\n"
                       "<IMEI>%@</IMEI>\n"
                       "<IMSI>%@</IMSI>\n"
                       "<Model>%@</Model>\n"
                       "<Uuid>%@</Uuid>\n"
                       "<inRoomNum>%@</inRoomNum>\n"
                       "<isAdmin>%@</isAdmin>\n"
                       "</ns1:MobileLogin>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>\n",name,pwd,imei,imei,model,imei,inRoomNum,@"1"];
        NSLog(@"调用webserivce的字符串是:%@",soapMessage);
        
        
        //请求发送到的路径
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        NSURL *url = [NSURL URLWithString:@"http://192.168.203.129:8080/HuasunMobileInterface/Services/MobileServiceIDC/MobileLogin/"];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        //以下对请求信息添加属性前四句是必有的，
        [urlRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [urlRequest addValue: @"http://192.168.203.129:8080/HuasunMobileInterface/Services/MobileServiceIDC/MobileLogin" forHTTPHeaderField:@"SOAPAction"];
        [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        //请求
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        theConnection = nil;
    }
    if ([message length]!=0) {
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 0) {
        //在密码框中点击键盘done
        [self doLogin];
    }
}
#pragma mark 下载协议
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //失败,提示错误信息
    NSLog(@"获取数据失败");
    NSString *errorMsg = @"获取数据失败";
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [loadingView close];
    [alertView show];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"获取数据中");
    [resultData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"获取数据结束");
    [loadingView close];
    resultData = [AppUtils replaceHtmlEntities:resultData];
    result = [[NSMutableString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    //去特殊符号
    //result = [AppUtils replaceStrForLogin:result];
    result=[[[[[result stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""] stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"] stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"] stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"] stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    
    
    
    resultData= nil;
    if(result && result.length>0){
        NSRange rangeStart =[result rangeOfString:@"<isok>"];
        NSString *isok = [result substringFromIndex:rangeStart.location+rangeStart.length];
        isok = [isok substringToIndex:1];
        NSString *errorMessage;
        rangeStart = [result rangeOfString:@"<msg>"];
       
        errorMessage = [result substringFromIndex:rangeStart.location+rangeStart.length];
        NSRange rangeEnd =[errorMessage rangeOfString:@"</msg>"];
        errorMessage = [errorMessage substringToIndex:rangeEnd.location];
        if([isok isEqualToString:@"1"]){
            NSRange range=[result rangeOfString:@"<Result>"];
            result=[result substringFromIndex:range.location+range.length];
            NSRange rangeEnd=[result rangeOfString:@"</mnav>"];
            result=[result substringToIndex:rangeEnd.location+rangeEnd.length];
            result=[result stringByAppendingString:@"</returnInfo>"];
            [self parseXmlStr:result];
            //登录成功
            //检查图片
            for (int i=0; i<groups.count; i++) {
                GroupModel *group = [groups objectAtIndex:i];
                for (int j=0; j<group.items.count; j++) {
                    NSError *error;
                    NSFileManager *manager = [NSFileManager defaultManager];
                    NSString *home = [@"~" stringByExpandingTildeInPath];
                    NSString *fileDirName = @"cntomorrow";
                    NSString *path = [home stringByAppendingString:@"/Documents"];
                    path = [path stringByAppendingPathComponent:fileDirName];
                    //去除item的icon名称检查是否存在,不存在则去下载
                    IDCGroupItem *item = [group.items objectAtIndex:j];
                    NSMutableString *iconName = [[NSMutableString alloc]initWithString:item.icon];
                    NSRange rang = [iconName rangeOfString:@"download/com.cntomorrow.mobile.framework/image/"];
                    iconName = [iconName substringFromIndex:rang.location+rang.length];
                     path = [path stringByAppendingPathComponent:iconName];
                    //不存在则去下载
                    if(![manager fileExistsAtPath:path]){
                        HHNetwork *hhdown = [[HHNetwork alloc]init];
                        [hhdown downloadFromGetUrl:item.icon completionHandler:^(NSData *data,NSError *error){
                            if(error){
                                
                            }else{
                                NSLog(@"图片下载完成:%@",path);
                                
                                //将图片写入
                                [self writeToFile:data :path];
                            }
                        }];
                    }
                }
            }
            //将用户名存储在appdelegate中
            AppDelegate *appDlegate = [[UIApplication sharedApplication] delegate];
            appDlegate.userName = name;
            //将用户名存储在plist文件中
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *doucumentsDirectiory = [paths objectAtIndex:0];
            //得到完整的文件名
            filePath = [doucumentsDirectiory stringByAppendingPathComponent:@"loginedUser.plist"];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:name,@"name", nil];
            [array addObject:dic];
            [array writeToFile:filePath atomically:YES];
            //[dic writeToFile:filePath atomically:YES];
            //跳转到主界面
            LeftViewController *leftView = [[LeftViewController alloc]init];
//            NewLeftViewController *newLeftView = [[NewLeftViewController alloc]init];
            //添加滑动cell
          
            RightViewController *rigthView = [[RightViewController alloc]init];
            MainViewController *mainView = [[MainViewController alloc]init];
            
            UINavigationController *leftNc = [[UINavigationController alloc]initWithRootViewController:leftView];
            UINavigationController *maintNc = [[UINavigationController alloc]initWithRootViewController:mainView];
            SWRevealViewController *swView = [[SWRevealViewController alloc]initWithRearViewController:leftNc frontViewController:maintNc];
            swView.delegate = self;
            
            swView.rightViewController = rigthView;
            
            [self presentViewController:swView animated:YES completion:nil];

        }else{
            //失败,提示错误信息
//            NSString *errorMsg = [info objectForKey:@"errmsg"];
//            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
//            [alertView show];
        }
    }

}
#pragma mark -
#pragma mark Table Data Source Methods
#pragma mark 返回1栏table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark 第一栏返回3个cell
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark 设置tableview第二栏头文字内容
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
#pragma mark 隐藏或显示下拉框
- (void)showUserList{
    NSLog(@"dropdown.showList==========%d",dropdown._showList);
    if (dropdown._showList) {
        dropdown._showList=NO;
        [dropdown hidden];
        if (sublayer!=nil) {
            //[sublayer removeFromSuperlayer];
        }
        NSLog(@"dropdown.showList==111========%d",dropdown._showList);
    }else{
        
        dropdown._showList=YES;
        [dropdown show];
    }
    NSLog(@"show userList");
}

#pragma mark 设置登陆框
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"loginCell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        
    }
    if (indexPath.section == 0) {  // 设置第一组的登陆框内容
        switch ([indexPath row]) {
            case 0:{
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"用户名"; // 设置label的文字
                cell.textLabel.font=[UIFont systemFontOfSize:fontSize];
                
                UIButton *button;
                UIImage *image= [UIImage   imageNamed:@"arrow-down3.png"];
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
                button.frame = frame;
                [button setBackgroundImage:image forState:UIControlStateNormal];
                button.backgroundColor= [UIColor clearColor];
                
                
                
                cell.accessoryView= button;
                
                self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(60, 7, 230, 20)];
                [self.nameField setBorderStyle:UITextBorderStyleNone]; //外框类型
                self.nameField.placeholder = @"请输入用户名";
                
                
                self.nameField.font=[UIFont systemFontOfSize:fontSize];
                self.nameField.clearButtonMode = YES; // 设置清楚按钮
                self.nameField.returnKeyType = UIReturnKeyNext;
                
                [cell.contentView addSubview:self.nameField];
                
                dropdown = [[DropDown alloc] initWithFrame:CGRectMake(width/2-240/2, loginFrameY+40-1, 240, [userData count]*35+2) andField:self.nameField];
                dropdown.tableArray = userData;
                
                NSLog(@"dropdown  uitablecell count: %d",userData.count);
                
                
                [self.view addSubview:dropdown];
                
                
                [button addTarget:self action:@selector(showUserList)forControlEvents:UIControlEventTouchUpInside];
                
                break;
            }
            case 1:{
                
                cell.textLabel.text = @"密 码";
                cell.textLabel.font=[UIFont systemFontOfSize:fontSize];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.pwdField = [[UITextField alloc] initWithFrame:CGRectMake(60, 7, 230, 20)];
                pwdField.tag = 0;
                pwdField.delegate = self;
                [self.pwdField setBorderStyle:UITextBorderStyleNone]; //外框类型
                self.pwdField.placeholder = @"请输入密码";
                BOOL keyValue=[defaultSettings boolForKey:@"revealPwd"];
                if(!keyValue){
                    self.pwdField.secureTextEntry=YES;
                }
                self.pwdField.font=[UIFont systemFontOfSize:fontSize];
                self.pwdField.clearButtonMode = YES;
                self.pwdField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
                self.pwdField.returnKeyType = UIReturnKeyDone;
                
                [cell.contentView addSubview:self.pwdField];
                break;
            }
        }
    }
    return cell;
}

#pragma mark 设置cell背景为透明
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"=======viewName=====%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if([NSStringFromClass([touch.view class]) isEqualToString:@"DropDown"]){
        [self.pwdField becomeFirstResponder];
        return NO;
    }
    return  YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)drawPlaceholderInRect:(CGRect)rect{
    [[UIColor blueColor] setFill];
}
#pragma mark 解析登录返回的xml
- (void)parseXmlStr:(NSString *)xmlStr{
    //给分组信息全局变量赋值
    AppDelegate *appDelete = [[UIApplication sharedApplication] delegate];
    NSMutableArray *likeItemGroup = [[NSMutableArray alloc]init];
    
    TBXML *tbxml = [[TBXML alloc]initWithXMLString:xmlStr];
    TBXMLElement *root = tbxml.rootXMLElement;
    //存储账户名和用户名
    TBXMLElement *accountName = [TBXML childElementNamed:@"msg" parentElement:root];
    NSString *accountNameStr = [TBXML textForElement:accountName];
    [appDelete.appInfo setObject:accountNameStr forKey:@"accountName"];
    [appDelete.appInfo setObject:name forKey:@"userName"];
    
    TBXMLElement *mnav = [TBXML childElementNamed:@"mnav" parentElement:root];
    
    TBXMLElement *page = [TBXML childElementNamed:@"page" parentElement:mnav];
    int section = 0;
    int row = 0;
    while (page) {
        
        GroupModel *group=[[GroupModel alloc] init];
        
        NSString *indexText = [TBXML valueOfAttributeNamed:@"index" forElement:page];
        NSString *count = [TBXML valueOfAttributeNamed:@"count" forElement:page];
        NSString *expand = [TBXML valueOfAttributeNamed:@"expand" forElement:page];
        NSString *title = [TBXML valueOfAttributeNamed:@"title" forElement:page];
        
        NSLog(@"page title============%@",title);
        
        group.title=title;
        
        NSMutableArray *items=[[NSMutableArray alloc] init];
        TBXMLElement *item = [TBXML childElementNamed:@"item" parentElement:page];
        while (item) {
            TBXMLElement *Id = [TBXML childElementNamed:@"id" parentElement:item];
            TBXMLElement *text = [TBXML childElementNamed:@"text" parentElement:item];
            TBXMLElement *icon = [TBXML childElementNamed:@"icon" parentElement:item];
            TBXMLElement *type = [TBXML childElementNamed:@"type" parentElement:item];
            TBXMLElement *uri = [TBXML childElementNamed:@"uri" parentElement:item];
            TBXMLElement *params = [TBXML childElementNamed:@"params" parentElement:item];
            TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:item];
            TBXMLElement *smstag = [TBXML childElementNamed:@"smstag" parentElement:item];
            TBXMLElement *needupdate = [TBXML childElementNamed:@"needupdate" parentElement:item];
            
            NSString *idText=[TBXML textForElement:Id];
            NSString *itemText=[TBXML textForElement:text];
            NSString *iconText=[TBXML textForElement:icon];
            NSString *typeText=[TBXML textForElement:type];
            NSString *uriText=[TBXML textForElement:uri];
            
            uriText=[uriText stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
            NSString *paramsText=[TBXML textForElement:params];
            
            paramsText=[paramsText stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
            
            NSString *descriptionText=[TBXML textForElement:description];
            NSString *smstagText=[TBXML textForElement:smstag];
            NSString *needupdateText=[TBXML textForElement:needupdate];
            SBJsonParser *paeser = [[SBJsonParser alloc]init];
            
            NSMutableDictionary *paramDic = [[paeser objectWithString:paramsText] objectAtIndex:0];
            
            NSMutableString *paramStr = [paramDic objectForKey:@"params"];
//            NSMutableDictionary *urlDic = [[NSMutableDictionary alloc]init];
           
            paramStr = [paramStr stringByReplacingOccurrencesOfString:@"&amp" withString:@""];
            
            NSMutableArray *paramArray = [paramStr componentsSeparatedByString:@";"];
            for (int i=0; i<paramArray.count; i++) {
                NSMutableString *str = [paramArray objectAtIndex:i];
                NSMutableArray *keyAndValue = [str componentsSeparatedByString:@"="];
                [paramDic setObject:[keyAndValue objectAtIndex:1]forKey:[keyAndValue objectAtIndex:0]];
            }

            IDCGroupItem *itemModel=[[IDCGroupItem alloc] init];
            itemModel.text = itemText;
            itemModel.idIdentity = idText;
            itemModel.icon = iconText;
            itemModel.type = typeText;
            itemModel.uri = uriText;
            itemModel.indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            //查询是否为收藏item
            LikeItemDB *likeDB = [[LikeItemDB alloc]init];
            NSMutableArray *likeArray  = [likeDB searchAllLikeItem];
            for (int i=0; i<likeArray.count; i++) {
                NSString *itemID = [likeArray objectAtIndex:i];
                if([itemModel.idIdentity isEqualToString:itemID]){
                    itemModel.isLike = YES;
                }
            }
            if(itemModel.isLike){
                [likeItemGroup addObject:itemModel];
            }
            //遍历appdelegate.appIndo替换变量
            NSArray *keys;
            int count;
            id key,value;
            if(appDelete.appInfo){
                keys = [appDelete.appInfo allKeys];
                count = keys.count;
                for (int i=0; i<count; i++) {
                    key = [keys objectAtIndex:i];
                    value = [appDelete.appInfo objectForKey:key];
                    [paramDic setObject:value forKey:key];
                }
            }
            [paramDic setObject: itemModel.text forKey:@"FUNCNAME"];
            [paramDic setObject: itemModel.idIdentity forKey:@"FUNCID"];
            itemModel.dataSourceInfo = paramDic;
            [items addObject:itemModel];
            row++;
            NSLog(@"item text---------%@",itemText);
            
            
            item=[TBXML nextSiblingNamed:@"item" searchFromElement:item];
        }
        group.items=items;
        
        [groups addObject:group];
        section++;
        row = 0;
        page=[TBXML nextSiblingNamed:@"page" searchFromElement:page];
    }
    
    
    
    
    appDelete.groups = self.groups;
    appDelete.likeItemGroup = likeItemGroup;
   
}
//向文件中写入数据
-(void)writeToFile:(NSData *)data:(NSString *) fileName{
    NSString *filePath=[NSString stringWithFormat:@"%@",fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO){
        NSLog(@"file not exist,create it...");
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }else {
        NSLog(@"file exist!!!");
    }
    
    FILE *file = fopen([fileName UTF8String], [@"ab+" UTF8String]);
    
    if(file != NULL){
        fseek(file, 0, SEEK_END);
    }
    int readSize = [data length];
    fwrite((const void *)[data bytes], readSize, 1, file);
    fclose(file);
}

@end

