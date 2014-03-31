//
//  FlowChartViewController.h
//  FlowChart
//
//  Created by Mac on 13-11-13.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface FlowChartViewController : UIViewController<CPTBarPlotDataSource>
@property (nonatomic,strong) CPTGraphHostingView *hostView;
@property (nonatomic,strong) NSMutableArray *dataArray;  //流入
@property (nonatomic,strong)  NSMutableArray *outDataArray;   //流出
@property (nonatomic,strong) NSMutableArray *labelArray; //标签
@end
