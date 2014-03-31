//
//  AppInfo.m
//  IDCWelcome
//
//  Created by Mac on 13-12-3.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "AppInfoDB.h"
#import "sqlite3.h"
#import "AppInfo.h"

#define DBNAME  @"cntomorrow.sqlite"
#define TBNAME  @"AppInfoDB"

#define VERSION @"version"
@interface AppInfoDB(){
    sqlite3 *db;
}
@end
@implementation AppInfoDB
-(void)insertAppInfo:(AppInfo *)appInfo{
    [self createDB];
    if([self openDB]){
        NSString *version = appInfo.version;
        
        NSMutableString *sql = [[NSMutableString alloc]initWithFormat:@"INSERT INTO '%@' (%@) VALUES('%@')",TBNAME,VERSION,version];
        
        if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL) != SQLITE_OK){
            NSLog(@"Appinfo插入失败");
        }
        sqlite3_close(db);
    }
    
}
//修改
-(void)editVersion:(NSString *)version{
    if([self openDB]){
        NSString *sqlEdit = [[NSString alloc]initWithFormat:@"UPDATE %@ SET %@='%@'",TBNAME,VERSION,version];
        NSLog(@"%@",sqlEdit);
        if(sqlite3_exec(db, [sqlEdit UTF8String], NULL, NULL, NULL) != SQLITE_OK){
            NSLog(@"Appinfo修改失败");
        }
        sqlite3_close(db);
    }
}
-(void)createDB{
    if([self openDB]){
        char *err;
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,%@ TEXT)",TBNAME,VERSION];
        if(sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK){
            sqlite3_close(db);
            NSLog(@"Appinfo建表失败");
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
        NSLog(@"Appinfo数据库打开失败");
        return NO;
    }else{
        return YES;
    }
}

//查询版本号
-(AppInfo *)searchAppInfo{
    if([self openDB]){
        AppInfo *appInfo = [[AppInfo alloc]init];
        NSString *sqlQuery = [[NSString alloc]initWithFormat:@"SELECT * FROM %@ ",TBNAME];
        NSLog(@"%@",sqlQuery);
        sqlite3_stmt *statement; 
        if(sqlite3_prepare_v2(db,[sqlQuery UTF8String], -1, &statement, NULL) ==SQLITE_OK){
            if(sqlite3_step(statement) == SQLITE_ROW){
                char *value = (char *)sqlite3_column_text(statement, 2);
                NSString *valueStr = [[NSString alloc]initWithUTF8String:value];
                appInfo.version = valueStr;
                sqlite3_close(db);
                return appInfo;
            }
        }
        sqlite3_close(db);
    }
}
@end
