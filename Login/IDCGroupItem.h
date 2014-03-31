//
//  Item.h
//  Button_Example
//
//  Created by Chakra on 08/04/11.
//  Copyright 2011 Chakra Interactive Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDCGroupItem : NSObject {
	
	NSString *idIdentity;
	NSString *text;
	NSString *icon;
}

@property (nonatomic, copy) NSString *idIdentity;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *uri;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *smstag;
@property (nonatomic, copy) NSString *notifyMessage;
@property (nonatomic, copy) NSString *needupdate;
@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic,retain) NSMutableDictionary * dataSourceInfo;//存储datasource名称,每页显示条数,是否显示搜索,baseUri,action
@property (nonatomic,retain) NSMutableDictionary * urlParams;//存放url的参数
@property (assign,nonatomic) BOOL isLike;   //是否是常用
-(void)doAction:(UIViewController *)viewController;
@end
