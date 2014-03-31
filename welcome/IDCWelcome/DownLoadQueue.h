//
//  DownLoadQueue.h
//  IDCWelcome
//
//  Created by Mac on 13-12-2.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ASINetworkQueue;
@interface DownLoadQueue : NSObject{
    
   
}
@property (strong) ASINetworkQueue *networkQueue;
-(void)downloadFileFromQueue:(NSString *)strUrl FilePath:(NSString *)filePath;
@end
