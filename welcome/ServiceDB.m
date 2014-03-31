//
//  ServiceDB.m
//  IDCWelcome
//
//  Created by Mac on 13-11-28.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ServiceDB.h"
#import "sqlite3.h"
#import "AESCrypt.h"

#define DBNAME  @"cntomorrow.sqlite"
#define TBNAME  @"ServiceUri"

#define SERVICEURI_NAME @"name"
#define SERVICEURI_WEBSERVICE @"webservice"
#define SERVICEURI_TAGNAME @"tagname"
#define SERVICEURI_METHOD @"method"
#define SERVICEURI_PARAM @"param"

@interface ServiceDB(){
    sqlite3 *db;
}
@end

@implementation ServiceDB
//<ws name="login">
//<webservice>http://1.202.208.29:8899/HuasunMobileInterface/Services/MobileServiceIDC</webservice>
//<tagname>http://idc.webservice/</tagname>
//<method>MobileLogin</method>
//<param>[{'UserName':'MAPPING-USERNAME','Password':'MAPPING-PASSWORD','IMEI':'MAPPING-IMEI','IMSI':'MAPPING-IMSI','Model':'MAPPING-MODEL','Uuid':'MAPPING-UUID','inRoomNum':'MAPPING-INROOMNUM'}]</param>
//</ws>

-(void)insertService:(ServiceUri *)serviceUri{
    //创建数据库
    [self createDB];
    if([self openDB]){
      
        NSString *name = [[NSString alloc]initWithString:[AESCrypt cnEncrypt:serviceUri.name]];
        NSString *webservice = [[NSString alloc]initWithString:[AESCrypt cnEncrypt:serviceUri.webservice]];
        NSString *tagname = [[NSString alloc]initWithString:[AESCrypt cnEncrypt:serviceUri.tagname ]];
        NSString *method = [[NSString alloc]initWithString:[AESCrypt cnEncrypt:serviceUri.method ]];
        NSMutableString *param = serviceUri.paramStr;
        param = [param stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        param = [[NSString alloc]initWithString:[AESCrypt cnEncrypt:param]];
        NSMutableString *sql = [[NSMutableString alloc]initWithFormat:@"INSERT INTO '%@' (%@,%@,%@,%@,%@) VALUES('%@','%@','%@','%@','%@')",TBNAME,SERVICEURI_NAME,SERVICEURI_WEBSERVICE,SERVICEURI_TAGNAME,SERVICEURI_METHOD,SERVICEURI_PARAM,name,webservice,tagname,method,param];
        
        if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL) != SQLITE_OK){
            NSLog(@"serviceDB插入失败");
        }
    }
    sqlite3_close(db);
    
}
-(void)createDB{
    if([self openDB]){
        char *err;
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,webservice TEXT,tagname TEXT,method TEXT,param TEXT)",TBNAME];
        if(sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK){
            NSLog(@"serviceDB建表失败");
        }
        sqlite3_close(db);
        
    }
}
//查询
-(ServiceUri *)searchServiceFromName:(NSString *)UriName{
    if([self openDB]){
        ServiceUri *serviceUri = [[ServiceUri alloc]init];
        serviceUri.name = UriName;
        UriName = [AESCrypt cnEncrypt:UriName];
        NSString *sqlQuery = @"SELECT * FROM ServiceUri where name=?";
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(db,[sqlQuery UTF8String], -1, &statement, NULL) ==SQLITE_OK){
            //绑定参数
            sqlite3_bind_text(statement, 1, [UriName UTF8String], -1, NULL);
            //执行
            if(sqlite3_step(statement) == SQLITE_ROW){
                
                char *webservice = (char *)sqlite3_column_text(statement, 2);
                NSString *webserviceStr = [[NSString alloc]initWithUTF8String:webservice];
                serviceUri.webservice = [AESCrypt cnDecrypt:webserviceStr];
                
                char *tagname = (char *)sqlite3_column_text(statement, 3);
                NSString *tagnameStr = [[NSString alloc]initWithUTF8String:tagname];
                serviceUri.tagname = [AESCrypt cnDecrypt:tagnameStr];
                
                char *method = (char *)sqlite3_column_text(statement, 4);
                NSString *methodStr = [[NSString alloc]initWithUTF8String:method];
                serviceUri.method = [AESCrypt cnDecrypt:methodStr];
                
                char *param = (char *)sqlite3_column_text(statement, 5);
                NSMutableString *paramStr = [[NSString alloc]initWithUTF8String:param];
                paramStr = [AESCrypt cnDecrypt:paramStr];
                
                NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
                paramStr = [paramStr substringWithRange:NSMakeRange(2, paramStr.length-4)];
                NSArray *paramArray =  [paramStr componentsSeparatedByString:@","];
                for (NSString *s in paramArray ) {
                    //'UserName':'MAPPING-USERNAME'
                    NSMutableString *key = [[s componentsSeparatedByString:@":"]objectAtIndex:0];
                    key = [key substringWithRange:NSMakeRange(1, key.length-2)];
                    
                    NSMutableString *value = [[s componentsSeparatedByString:@":"]objectAtIndex:1];
                    value = [value substringWithRange:NSMakeRange(1, value.length-2)];
                    [paramDic setObject:value forKey:key];
                }
                serviceUri.param = paramDic;
                
                NSLog(@"1~~%@",serviceUri.name);
                NSLog(@"2~~%@",serviceUri.method);
                NSLog(@"3~~%@",serviceUri.tagname);
                NSLog(@"4~~%@",serviceUri.webservice);
                sqlite3_close(db);
                return serviceUri;
            }
        }else{
            sqlite3_close(db);
            return  nil;
        }
    }
}
-(BOOL)openDB{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    documents = [documents stringByAppendingString:@"/cntomorrow/"];
    NSString *databasePath = [documents stringByAppendingPathComponent:DBNAME];
    if(sqlite3_open([databasePath UTF8String], &db)!= SQLITE_OK){
        sqlite3_close(db);
        NSLog(@"serviceDB数据库打开失败");
        return NO;
    }else{
        return YES;
    }
}

@end
