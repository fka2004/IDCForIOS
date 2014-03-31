//
//  FlowChartViewController.m
//  FlowChart
//
//  Created by Mac on 13-11-13.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
#define NavBarHeight                    40
#define ViewHeight                      459
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#import "FlowChartViewController.h"
#import "CorePlot-CocoaTouch.h"

@interface FlowChartViewController (){
    //    NSMutableArray *dataArray;  //流入
    //    NSMutableArray *outDataArray;   //流出
    //    NSMutableArray *labelArray; //标签
    
    NSString *PLOT_IN;
    NSString *PLOT_OUT;
    
    
}

@end

@implementation FlowChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)shouldAutorotate
{
    return YES;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置横屏
    //5.0及以后，不整这个，界面错位整这个带动画的话，容易看到一个白头
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //声明线的标识
    PLOT_IN = @"FLOWIN";
    PLOT_OUT = @"FLOWOUT";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self initPlot];
    
}

//-(void)viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
//    //设置横屏
//    [UIView animateWithDuration:0.0f animations:^{
//        
//        [self.view setTransform: CGAffineTransformMakeRotation(M_PI / 2)];
//        
//        if(iPhone5) {
//            self.view.frame = CGRectMake(0, 0, 568, 320);
//            
//        }
//        
//        else{
//            
//            self.view.frame = CGRectMake(0, 0, 480, 320);
//            
//        }
//        
//    }];
//}
-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}
-(void)configureHost{
    //self.hostView = [[CPTGraphHostingView alloc]initWithFrame:self.view.bounds];
    if (iPhone5) {
         self.hostView = [[CPTGraphHostingView alloc]initWithFrame:CGRectMake(0, 0, 568, 320)];
    }else{
        self.hostView = [[CPTGraphHostingView alloc]initWithFrame:CGRectMake(0, 0, 480, 320)];
    }
    self.hostView.backgroundColor = [UIColor whiteColor];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}
-(void)configureGraph{
    CPTGraph *graph = [[CPTXYGraph alloc]initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    self.hostView.hostedGraph = graph;
    //设置流量图背景后面那一层的颜色
    CGColorRef color = [[UIColor whiteColor] CGColor];
    CPTColor *bgcolor = [CPTColor colorWithCGColor:color];
    //graph.fill = [CPTFill fillWithColor:bgcolor];
    graph.plotAreaFrame.plotArea.fill = [CPTFill fillWithColor:bgcolor];
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:bgcolor];
    
    graph.title=@"蓝色:流入    绿色:流出";
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [UIColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 10.0f;
    graph.titleTextStyle = titleStyle;
    //文字位置
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(150.0f, -15.0f);
    //设置边距
    [graph.plotAreaFrame setPaddingLeft: 40.0f];
    [graph.plotAreaFrame setPaddingBottom:55.0f];
    //[graph.plotAreaFrame setPaddingTop:-50.0f];
    //设置graph 边距
    graph.paddingLeft = graph.paddingRight = -4.0f;
    graph.paddingTop = -4.0f;
    
    CPTXYPlotSpace *plotSpace = graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([_dataArray count]-1)];
    
}
-(void)configurePlots{
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = graph.defaultPlotSpace;
    //创建流入折线
    CPTScatterPlot *applPlot = [[CPTScatterPlot alloc]init];
    applPlot.dataSource = self;
    applPlot.identifier = PLOT_IN;
    CPTColor *applColor = [CPTColor blueColor];
    //添加折线
    [graph addPlot:applPlot toPlotSpace:plotSpace];
    //创建流出折线
    CPTScatterPlot *googPlot = [[CPTScatterPlot alloc]init];
    googPlot.dataSource = self;
    googPlot.identifier = PLOT_OUT;
    CPTColor *googColor = [CPTColor greenColor];
    [graph addPlot:googPlot toPlotSpace:plotSpace];
    // 3 - Set up plot space
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:applPlot, googPlot,nil]];
    
    //mutableCopy 深拷贝
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    //设置 可伸缩 大于1为扩展
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;
    // 4 - Create styles and symbols 设置线的样式
    CPTMutableLineStyle *applLineStyle = [applPlot.dataLineStyle mutableCopy];
    //线宽
    applLineStyle.lineWidth = 1.0;
    //线颜色
    applLineStyle.lineColor = applColor;
    //设置样式
    applPlot.dataLineStyle = applLineStyle;
    
    //创建linestyle
    CPTMutableLineStyle *applSymbolineStyle = [CPTMutableLineStyle lineStyle];
    applSymbolineStyle.lineColor = applColor;
    //返回一个椭圆形的plot,就是折现上的点的样式
    CPTPlotSymbol *applSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    //设置点填充,不设置的话为空心的点
    applSymbol.fill = [CPTFill fillWithColor:applColor];
    applSymbol.lineStyle = applSymbolineStyle;
    //设置折现点的大小
    applSymbol.size = CGSizeMake(0.0f, 0.0f);
    applPlot.plotSymbol = applSymbol;
    
    CPTMutableLineStyle *googlineStyle = [CPTMutableLineStyle lineStyle];
    //线宽
    googlineStyle.lineWidth = 1.0;
    //设置样式
    googlineStyle.lineColor = googColor;
    googPlot.dataLineStyle = googlineStyle;
    //小星星
    CPTPlotSymbol *googSymbol = [CPTPlotSymbol starPlotSymbol];
    googSymbol.fill = [CPTFill fillWithColor:googColor];
    googSymbol.lineStyle = googlineStyle;
    googSymbol.size = CGSizeMake(0.0f, 0.0f);
    googPlot.plotSymbol = googSymbol;
    
}
//配置坐标轴
-(void)configureAxes{
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    //坐标轴文字颜色
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 10.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 1.0f;
    axisLineStyle.lineColor = [CPTColor blackColor];
    //坐标刻度字
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc]init];
    axisTextStyle.color = [CPTColor blackColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.hostView.hostedGraph.axisSet;
    //configure axis
    //获取x轴
    CPTXYAxis *x = axisSet.xAxis;
    x.title=@"时间";
    x.titleTextStyle = axisTitleStyle;
    //文字向下的偏移
    x.titleOffset = 15.0f;
    //x轴线风格
    x.axisLineStyle = axisLineStyle;
    //x轴刻度设置
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    //x刻度风格
    x.majorTickLineStyle = axisLineStyle;
    //刻度长度(是向下突出的小标)
    x.majorTickLength = 0.0f;
    //刻度方向  向下
    x.tickDirection  = CPTSignNegative;
    
    //    x.majorIntervalLength = CPTDecimalFromString(@"0.1");   // x轴主刻度：显示数字标签的量度间隔
    //    x.minorTicksPerInterval = 2;
    
    //    NSInteger i = 0;
    //    for (NSString *date in xLable) {
    //        CPTAxisLabel *label = [[CPTAxisLabel alloc]initWithText:date textStyle:x.labelTextStyle];
    //        [xLable addObject:label];
    //
    //    }
    NSMutableSet *xLable = [NSMutableSet setWithCapacity:20];
    
    for (int i=0;i<[_labelArray count]; i++) {
        //        CPTAxisLabel *label = [[CPTAxisLabel alloc]initWithText:[NSString stringWithFormat:@"%i",i] textStyle:x.labelTextStyle];
        //        CGFloat location = i++;
        //        label.tickLocation = CPTDecimalFromCGFloat(location);
        //        label.offset = x.majorTickLength;
        NSMutableString *s = [_labelArray objectAtIndex:i];
        NSMutableString *hour = [s substringWithRange:NSMakeRange(0, 2)];
        NSMutableString *min = [s substringWithRange:NSMakeRange(2, 2)];
        NSMutableString *time = [NSMutableString stringWithFormat:@"%@:%@",hour,min];
        CPTAxisLabel *label = [[CPTAxisLabel alloc]initWithText:[NSString stringWithFormat:@"%@",time] textStyle:x.labelTextStyle];
        
        CGFloat location = i*([_dataArray count]/5);
        
        label.tickLocation = CPTDecimalFromCGFloat(location);
        //x label距离x轴距离
        label.offset = x.majorTickLength;
        [xLable addObject:label];
    }
    x.axisLabels = xLable;
    //x.axisConstraints = xLable;
    //刻度数组
    NSMutableSet *locations = [NSMutableSet setWithCapacity:20];
    for (int i=0; i<20; i++) {
        [locations addObject:[NSNumber numberWithFloat:i]];
    }
    x.majorTickLocations = locations;
    
    // 4 - Configure y-axis
    CPTAxis *y = axisSet.yAxis;
    y.title = @"流量(M)";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -50.0f;
    y.axisLineStyle = axisLineStyle;
    //y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 26.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    //y.majorIntervalLength = CPTDecimalFromString(@"0.5");
    //y.minorTicksPerInterval = 2;
    //最大刻度单位
    NSInteger majorIncrement = 100;
    NSInteger minorIncrement = 50;
    
    //最大刻度
    CGFloat yMax = 2000.0f;  // should determine dynamically based on max price
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (int i=minorIncrement; i <= yMax; i+=minorIncrement) {
        NSUInteger mod = i % majorIncrement;
        //在mod==0的时候添加lable
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", i] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(i);
            label.tickLocation = location;
            //lable距离y周  也就是在x轴的偏移
            label.offset = -y.majorTickLength - y.labelOffset;
            if(label){
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        }else{
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(i)]];
        }
        
    }
    y.axisLabels = yLabels;
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
    
    
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    return [_dataArray count];
}
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx{
    NSInteger valueCount = [_dataArray count];
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (idx < valueCount) {
                return [NSNumber numberWithUnsignedInteger:idx];
            }
            break;
            
        case CPTScatterPlotFieldY:
            if ([plot.identifier isEqual:PLOT_IN] == YES) {
                return [_dataArray objectAtIndex:idx];
            } else if ([plot.identifier isEqual:PLOT_OUT] == YES) {
                return [_outDataArray objectAtIndex:idx];
            }
            break;
    }
    return [NSDecimalNumber zero];
    //    if(fieldEnum == CPTScatterPlotFieldY){
    //        return [dataArray objectAtIndex:idx];
    //    }else{
    //        return [[NSNumber alloc]initWithInt:idx];
    //    }
}
//强制横屏
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
