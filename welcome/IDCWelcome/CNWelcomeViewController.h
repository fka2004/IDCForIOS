//
//  CNWelcomeViewController.h
//  IDCWelcome
//
//  Created by Mac on 13-11-25.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceDelegate.h"
#import "CNWelcomeViewController.h"
@class ASINetworkQueue;
@interface CNWelcomeViewController : UIViewController<WebServiceDelegate,UIAlertViewDelegate>{

}



@property (strong) ASINetworkQueue *networkQueue;
@end
