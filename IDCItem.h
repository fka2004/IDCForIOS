//
//  Item.h
//  IDCForIOS
//
//  Created by Mac on 13-12-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCItem : NSObject
@property (nonatomic,retain) NSString * showdes;//0-不显示 1-显示 描述(默认显示)
@property (nonatomic,retain) NSString * itemId;
@property (nonatomic,retain) NSString * text;
@property (nonatomic,retain) NSString * icon;
@property (nonatomic,retain) NSString * type;
@property (nonatomic,retain) NSString * url;
@property (nonatomic,retain) NSMutableDictionary * dataSourceInfo;//存储datasource名称,每页显示条数,是否显示搜索,baseUri,action
//@property (nonatomic,assign) NSMutableDictionary * params;
@property (nonatomic,retain) NSMutableDictionary * urlParams;//存放url的参数
@property (nonatomic,retain) NSString * description;
@property (nonatomic,retain) NSString * smstag;
@property (nonatomic,retain) NSString * notifyMessage;
@property (nonatomic,retain) NSString * needupdate;//1-需要检测版本 0-不需要检测版本
@property (nonatomic,retain) NSString * servicetype;//0服务类，1增值类
@property (nonatomic,retain) NSString * buy;//0未购买，1已购买
@property (nonatomic,retain) NSString * soapMessage;
-(void)doAction:(UIViewController *)viewController;
@end
