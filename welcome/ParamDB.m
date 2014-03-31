//
//  ParamDB.m
//  IDCWelcome
//
//  Created by Mac on 13-11-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ParamDB.h"
#import "sqlite3.h"
#import "ParamMapping.h"
#import "AESCrypt.h"

#define DBNAME  @"cntomorrow.sqlite"
#define TBNAME  @"ParamMapping"

#define PARAM_TAG @"tag"
#define PARAM_VALUE @"value"

@interface ParamDB(){
    sqlite3 *db;
}
@end

@implementation ParamDB
-(void)insertParam:(ParamMapping *)param{
    [self createDB];
    if([self openDB]){
        NSString *tag = [AESCrypt cnEncrypt:param.tag];
        NSString *value = [AESCrypt cnEncrypt:param.value];
        NSMutableString *sql = [[NSMutableString alloc]initWithFormat:@"INSERT INTO '%@' (%@,%@) VALUES('%@','%@')",TBNAME,PARAM_TAG,PARAM_VALUE,tag,value];
        
        if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL) != SQLITE_OK){
            NSLog(@"ParamDB插入失败");
        }
        sqlite3_close(db);
    }
    
}
-(void)createDB{
    if([self openDB]){
        char *err;
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,%@ TEXT,%@ TEXT)",TBNAME,PARAM_TAG,PARAM_VALUE];
        if(sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK){
            sqlite3_close(db);
            NSLog(@"ParamDB建表失败");
        }
        sqlite3_close(db);
    }
}
//查询
-(ParamMapping *)searchServiceFromName:(NSString *)tag{
    if([self openDB]){
       // NSData *tagData = [tag ]
        ParamMapping *param = [[ParamMapping alloc]init];
        param.tag = tag;
        tag = [AESCrypt cnEncrypt:tag];
        NSString *sqlQuery = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ where tag=?",TBNAME];
        NSLog(@"%@",sqlQuery);
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(db,[sqlQuery UTF8String], -1, &statement, NULL) ==SQLITE_OK){
            //绑定参数
            sqlite3_bind_text(statement, 1, [tag UTF8String], -1, NULL);
            //执行
            if(sqlite3_step(statement) == SQLITE_ROW){
                char *value = (char *)sqlite3_column_text(statement, 2);
                NSString *valueStr = [[NSString alloc]initWithUTF8String:value];
                
                param.value = [AESCrypt cnDecrypt:valueStr];
            }
            sqlite3_close(db);
            return param;
        }else{
            sqlite3_close(db);
            return  nil;
        }
    }
}
//修改
-(void)editParam:(NSString *) tag value:(NSString *)value{
    if([self openDB]){
        tag = [AESCrypt cnEncrypt:tag];
        value = [AESCrypt cnEncrypt:value];
        NSString *sqlEdit = [[NSString alloc]initWithFormat:@"UPDATE %@ SET %@='%@' where %@='%@'",TBNAME,PARAM_VALUE,value,PARAM_TAG,tag];
        NSLog(@"%@",sqlEdit);
        if(sqlite3_exec(db, [sqlEdit UTF8String], NULL, NULL, NULL) != SQLITE_OK){
            NSLog(@"ParamDB修改失败");
        }
        sqlite3_close(db);
    }
}
-(BOOL)openDB{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    documents = [documents stringByAppendingString:@"/cntomorrow/"];
    NSString *databasePath = [documents stringByAppendingPathComponent:DBNAME];
    if(sqlite3_open([databasePath UTF8String], &db)!= SQLITE_OK){
        sqlite3_close(db);
        NSLog(@"ParamDB数据库打开失败");
        return NO;
    }else{
        return YES;
    }
}
@end
