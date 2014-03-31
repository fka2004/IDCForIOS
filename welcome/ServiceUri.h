//
//  ServiceUri.h
//  IDCWelcome
//
//  Created by Mac on 13-11-28.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceUri : NSObject
//<ws name="login">
//<webservice>http://1.202.208.29:8899/HuasunMobileInterface/Services/MobileServiceIDC</webservice>
//<tagname>http://idc.webservice/</tagname>
//<method>MobileLogin</method>
//<param>[{'UserName':'MAPPING-USERNAME','Password':'MAPPING-PASSWORD','IMEI':'MAPPING-IMEI','IMSI':'MAPPING-IMSI','Model':'MAPPING-MODEL','Uuid':'MAPPING-UUID','inRoomNum':'MAPPING-INROOMNUM'}]</param>
//</ws>
@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *webservice;
@property (nonatomic, assign) NSString *tagname;
@property (nonatomic, assign) NSString *method;
@property (nonatomic, assign) NSMutableDictionary *param;
@property (nonatomic, assign) NSString *paramStr;
@end
