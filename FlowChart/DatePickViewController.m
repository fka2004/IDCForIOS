//
//  DatePickViewController.m
//  FlowChart
//
//  Created by Mac on 13-11-15.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "DatePickViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "XMLParser.h";
#import "TBXmlParser.h"
#import "FlowChartViewController.h"
#import "AppUtils.h"
#import "HHNetwork.h"
#import "SBJson.h"
#import "LoadingView.h"
@interface DatePickViewController (){
    BOOL todayState;
    BOOL selectState;
    UIView *expendView;
    UIActionSheet *actionSheet;
    BOOL isBegin;   //判断是起始时间还是结束时间
    UITextField *beginText;
    UITextField *endText;
    NSMutableString *resultStr;
    NSMutableData *resultData;
    UIActivityIndicatorView *indicator;
    LoadingView *loadView;

}

@end

@implementation DatePickViewController

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

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    todayState = YES;
    selectState = NO;
    isBegin = YES;
    
    
    
    expendView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, 320, 150)];
    UILabel *beginTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
    beginTime.text = @"起始时间";
    beginText = [[UITextField alloc]initWithFrame:CGRectMake(100, 7, 200, 30)];
    beginText.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    beginText.borderStyle = UITextBorderStyleRoundedRect;
    beginText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel *endTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 80, 30)];
    endText = [[UITextField alloc]initWithFrame:CGRectMake(100, 53, 200, 30)];
    endText.borderStyle = UITextBorderStyleRoundedRect;
    endText.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    
    endText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    endTime.text = @"结束时间";
    
    [beginText addTarget:self action:@selector(beginSelect:) forControlEvents:UIControlEventTouchDown];
    [endText addTarget:self action:@selector(endSelect:) forControlEvents:UIControlEventTouchDown];
    
    
    //expendView.backgroundColor = [UIColor grayColor];
    indicator  = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator setCenter:CGPointMake(160, 0)]; // I do this because I'm in landscape mode
    
    expendView.hidden = YES;
    [expendView addSubview:beginTime];
    [expendView addSubview:beginText];
    [expendView addSubview:endTime];
    [expendView addSubview:endText];
    [expendView addSubview:indicator];
    
    [self.view addSubview:expendView];
}
-(IBAction)backButtonClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)submit:(id)sender {
    
    if(_selectSwitch.on == YES){
        if(beginText.text == nil || beginText.text == @""){
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择起始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
            return;
        }else if(endText.text == nil || endText.text == @""){
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择结束时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
            return;
        }else{
            NSDateFormatter *dateFormmatter = [[NSDateFormatter alloc]init];
            [dateFormmatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *current = [NSDate date];
            NSDate *begin = [dateFormmatter dateFromString:beginText.text];
            NSDate *end = [dateFormmatter dateFromString:endText.text];
            NSDate *lastMonth = [end dateByAddingTimeInterval:-60*60*60*24];
            //起始日期必须小于终止日期
            NSComparisonResult *result = [begin compare:end];
            if(result == NSOrderedDescending){
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"起始时间必须早于终止时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter show];
                return;
            }
            result = [end compare:current];
            //结束日期必须早于当前日期"
            if(result == NSOrderedDescending){
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"结束时间必须早于当前时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter show];
                return;
            }
            result = [begin compare:lastMonth];
            if(result == NSOrderedAscending){
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"起始时间距结束时间需在一个月内" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alter show];
                return;
            }
        }
       
    }
    //提交数据
    [self getFlowDataNew];
}
-(void)getFlowDataNew{
    loadView = [LoadingView shareLoadingView:@"加载中.."];
    [loadView show];
    HHNetwork *hh = [[HHNetwork alloc]init];
    NSString *MonitorID = [[NSString alloc]initWithString:self.item.itemId];
    //现在没有id,做个假的
    MonitorID = @"11111";
    [self.IDCItem.dataSourceInfo setObject:MonitorID forKey:@"MonitorID"];
    //账户类型,这里随便写个
    [self.IDCItem.dataSourceInfo setObject:@"1" forKey:@"accountType"];
    NSString *url = [self.IDCItem.dataSourceInfo objectForKey:@"baseUri"];
    if(_selectSwitch.on == YES){
        url = [url stringByAppendingFormat:@"/mobile.do?dispatch=reportLineMonth"];
        [self.IDCItem.dataSourceInfo setObject:beginText.text forKey:@"BeginTime"];
        [self.IDCItem.dataSourceInfo setObject:endText.text forKey:@"EndTime"];
    }else{
        url = [url stringByAppendingFormat:@"/mobile.do?dispatch=reportLine"];
    }
    

    [hh downloadFromPostUrl:url dict:self.IDCItem.dataSourceInfo completionHandler:^(NSData *data,NSError *error){
        [loadView close];
        if(error){
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取数据失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [view show];
        }else{
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSMutableArray *inFlow;
            NSMutableArray *outFlow;
            NSMutableArray *label;
            NSMutableArray *data;
            //    XMLParser *parser = [[XMLParser alloc]init];
            //    [parser parserXML:resultStr];
            //    data = [parser getData];
            TBXmlParser *tbparser = [[TBXmlParser alloc]init];
            data = [tbparser start:result];
            inFlow = [data objectAtIndex:0];
            outFlow = [data objectAtIndex:1];
            label = [data objectAtIndex:2];
            //将值付给流量图类并打开流量图
            FlowChartViewController *flowChar = [[FlowChartViewController alloc]init];
            
            if([inFlow count]>30){
                NSMutableArray *newInFlow = [[NSMutableArray alloc]init];
                NSMutableArray *newOutFlow = [[NSMutableArray alloc]init];
                NSMutableArray *newLable = [[NSMutableArray alloc]init];
                
                int temp = [inFlow count]/30;
                for(int i=0;i<[inFlow count];i+=temp){
                    [newInFlow addObject:[inFlow objectAtIndex:i]];
                    [newOutFlow addObject:[outFlow objectAtIndex:i]];
                }
                temp = [inFlow count]/5;
                for(int i=0;i<[inFlow count];i+=temp){
                    [newLable addObject:[label objectAtIndex:i]];
                }
                flowChar.dataArray = newInFlow;
                flowChar.outDataArray = newOutFlow;
                flowChar.labelArray = newLable;
                
            }else{
                flowChar.dataArray = inFlow;
                flowChar.outDataArray = outFlow;
                if([label count]>5){
                    NSMutableArray *newLable = [[NSMutableArray alloc]init];
                    int temp = [inFlow count]/5;
                    for(int i=0;i<[inFlow count];i+=temp){
                        [newLable addObject:[label objectAtIndex:i]];
                    }
                    flowChar.labelArray = newLable;
                }else{
                    flowChar.labelArray = label;
                    
                }
            }
            
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:flowChar];
            [self presentViewController:nav animated:YES completion:nil];
            
            //[self.navigationController pushViewController:flowChar animated:true];
            //[self presentedViewController:flowChar animated:YES];

           
            
        }
    }];

}
-(void)getFlowData{
    
    resultData = [[NSMutableData alloc]init];
    NSString *soapMessage;
    NSString *accountName = [self.IDCItem.dataSourceInfo objectForKey:@"accountName"];
    NSString *MonitorID = [[NSString alloc]initWithString:self.item.itemId];
    NSString *uri = [self.IDCItem.dataSourceInfo objectForKey:@"baseUri"];
    //现在没有id,做个假的
    MonitorID = @"11111";
    if(_selectSwitch.on == YES){
        //不加下面的ns1的话服务端接收不到参数
        uri = [uri stringByAppendingFormat:@"/mobile.do?dispatch=reportLineMonth"];
        soapMessage = [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tns=\"http://services.lansoft.com/\">\n"
                                 "<soap:Body>\n"
//                                 "<ns1:Search_Month_Info xmlns:ns1=\"http://192.168.203.51:9090/MTMobile/Services/MobileService/Search_Month_Info/\">\n"
                       "<ns1:Search_Month_Info xmlns:ns1=\"%@/\">\n"
                                 "<accountName>%@</accountName>\n"
                                 "<MonitorID>%@</MonitorID>\n"
                                 "<beginTime>%@</beginTime>\n"
                                 "<endTime>%@</endTime>\n"
                                 "</ns1:Search_Month_Info>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n",uri,accountName,MonitorID,beginText.text,endText.text];
       
    }else{
        uri = [uri stringByAppendingFormat:@"/mobile.do?dispatch=reportLine"];

        soapMessage = [NSString stringWithFormat:
                       @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tns=\"http://services.lansoft.com/\">\n"
                       "<soap:Body>\n"
//                       "<ns1:Search_detail_info xmlns:ns1=\"http://192.168.203.51:9090/MTMobile/Services/MobileService/Search_Month_Info/\">\n"
                       "<ns1:Search_detail_info xmlns:ns1=\"%@/\">\n"
                       "<accountName>%@</accountName>\n"
                       "<MonitorID>%@</MonitorID>\n"
                       "</ns1:Search_detail_info>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>\n",uri,accountName,MonitorID];

    }
     NSLog(@"调用webserivce的字符串是:%@",soapMessage);
    //http://192.168.203.51:8080/IDCProcess/services/IDCProcess
    
    //请求发送到的路径
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    NSURL *url = [NSURL URLWithString:uri];
    //    NSURL *url = [NSURL URLWithString:@"http://192.168.203.51:8080/IDCProcess/services/IDCProcess/Search_Month_Info/"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //以下对请求信息添加属性前四句是必有的，
    [urlRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: uri forHTTPHeaderField:@"SOAPAction"];
    //    [urlRequest addValue: @"http://192.168.203.51:8080/IDCProcess/services/IDCProcess/Search_Month_Info" forHTTPHeaderField:@"SOAPAction"];
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //请求
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    theConnection = nil;
}
//分批返回数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [resultData appendData:data];
    
}
//返回数据完毕
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [indicator stopAnimating];
    resultData = [AppUtils replaceHtmlEntities:resultData];
    //resultStr = [[NSString alloc]initWithData:resultData encoding:NSUTF8StringEncoding];
    resultStr = [[NSMutableString alloc]initWithBytes:[resultData mutableBytes] length:[resultData length] encoding:NSUTF8StringEncoding];
    resultStr = [AppUtils replaceStr:resultStr];
    NSLog(@"接收完毕:%@",resultStr);
    //接收数据后解析
    NSMutableArray *inFlow;
    NSMutableArray *outFlow;
    NSMutableArray *label;
    NSMutableArray *data;
    //    XMLParser *parser = [[XMLParser alloc]init];
    //    [parser parserXML:resultStr];
    //    data = [parser getData];
    TBXmlParser *tbparser = [[TBXmlParser alloc]init];
    NSMutableString *resultStr2 = [[NSMutableString alloc]initWithString:@"<?xml version=\"1.0\" encoding=\"GBK\"?><MessageInfo><Device_Name name=\"设备名称\">网络设备端口:201326601</Device_Name><Detail_info><Time_val name=\"时间数值\">0830</Time_val><in name=\"流入值\">110.58</in><out name=\"流出值\">90.08</out></Detail_info><Detail_info><Time_val name=\"时间数值\">0836</Time_val><in name=\"流入值\">96.66</in><out name=\"流出值\">115.22</out></Detail_info><Detail_info><Time_val name=\"时间数值\">0841</Time_val><in name=\"流入值\">114.99</in><out name=\"流出值\">55.55</out></Detail_info><Detail_info><Time_val name=\"时间数值\">0841</Time_val><in name=\"流入值\">232.11</in><out name=\"流出值\">101.22</out></Detail_info><Detail_info><Time_val name=\"时间数值\">0841</Time_val><in name=\"流入值\">156.22</in><out name=\"流出值\">122.22</out></Detail_info><Detail_info><Time_val name=\"时间数值\">0841</Time_val><in name=\"流入值\">210.33</in><out name=\"流出值\">223.33</out></Detail_info><Detail_info><Time_val name=\"时间数值\">0841</Time_val><in name=\"流入值\">199.33</in><out name=\"流出值\">21.33</out></Detail_info></MessageInfo>"];
    data = [tbparser start:resultStr];
    inFlow = [data objectAtIndex:0];
    outFlow = [data objectAtIndex:1];
    label = [data objectAtIndex:2];
    //将值付给流量图类并打开流量图
    FlowChartViewController *flowChar = [[FlowChartViewController alloc]init];
    
    if([inFlow count]>30){
        NSMutableArray *newInFlow = [[NSMutableArray alloc]init];
        NSMutableArray *newOutFlow = [[NSMutableArray alloc]init];
        NSMutableArray *newLable = [[NSMutableArray alloc]init];
        
        int temp = [inFlow count]/100;
        for(int i=0;i<[inFlow count];i+=temp){
            [newInFlow addObject:[inFlow objectAtIndex:i]];
            [newOutFlow addObject:[outFlow objectAtIndex:i]];
        }
        temp = [inFlow count]/5;
        for(int i=0;i<[inFlow count];i+=temp){
            [newLable addObject:[label objectAtIndex:i]];
        }
        flowChar.dataArray = newInFlow;
        flowChar.outDataArray = newOutFlow;
        flowChar.labelArray = newLable;
        
    }else{
        flowChar.dataArray = inFlow;
        flowChar.outDataArray = outFlow;
        if([label count]>5){
            NSMutableArray *newLable = [[NSMutableArray alloc]init];
            int temp = [inFlow count]/5;
            for(int i=0;i<[inFlow count];i+=temp){
                [newLable addObject:[label objectAtIndex:i]];
            }
            flowChar.labelArray = newLable;
        }else{
            flowChar.labelArray = label;
            
        }
    }
    
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:flowChar];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
    [self.navigationController pushViewController:flowChar animated:true];
    //[self presentedViewController:flowChar animated:YES];
    
    
    
}
-(void)beginSelect:(id)sender{
    NSLog(@"begin");
    isBegin = YES;
    [self createDatePicker];
}
-(void)endSelect:(id)sender{
    NSLog(@"end");
    isBegin = NO;
    [self createDatePicker];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)todaySwitch:(UISwitch *)sender {
    [sender setTag:1];
    
    [self hidden:sender];
}

- (IBAction)selectSwitch:(UISwitch *)sender {
    NSLog(@"select click");
    [sender setTag:2];
    [self hidden:sender];
}
-(void)hidden:(UIButton*)sender{
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [expendView.layer addAnimation:animation forKey:nil];
    if(sender.tag == 1){
        if(_todaySwith.on==YES)
            _selectSwitch.on = NO;
        else
            _selectSwitch.on = YES;
    }else{
        if(_selectSwitch.on==YES)
            _todaySwith.on = NO;
        else
            _todaySwith.on = YES;
    }
    if(selectState == NO){
        selectState = YES;
        expendView.hidden = NO;
        
    }else{
        selectState = NO;
        expendView.hidden = YES;
        beginText.text = @"";
        endText.text = @"";
    }
    
    
}
-(void)createDatePicker{
    UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, 320, 480)];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    picker.locale = locale;
    [picker setDatePickerMode:UIDatePickerModeDate];
    actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    picker.tag = 101;
    [actionSheet addSubview:picker];
    UISegmentedControl *closeButton = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObject:@"完成"]];
    closeButton.momentary = YES;//点击后是否回复原来的样子
    closeButton.frame = CGRectMake(265, 5.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    [closeButton addTarget:self action:@selector(selectPicker:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 480)];
    
}
-(void)selectPicker:(id)sender{
    UIDatePicker *picker = (UIDatePicker *)[actionSheet viewWithTag:101];
    
    NSDateFormatter *dateFormmatter = [[NSDateFormatter alloc]init];
    [dateFormmatter setDateFormat:@"yyyy-MM-dd"];
    
    if(isBegin){
        beginText.text = [dateFormmatter stringFromDate:picker.date];
    }else{
        endText.text = [dateFormmatter stringFromDate:picker.date];
    }
	[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end
