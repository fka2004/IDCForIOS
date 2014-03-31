//
//  LikeItem.m
//  IDCForIOS
//
//  Created by Mac on 14-3-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "LikeItemDB.h"
#import "sqlite3.h"
#import "IDCGroupItem.h"
#define DBNAME  @"cntomorrow.sqlite"
#define TBNAME  @"LikeItem"
#define ITEMID  @"itemId"
@interface LikeItemDB(){
    sqlite3 *db;
}
@end
@implementation LikeItemDB
-(void)insertLikeItem:(NSString *)itemID{
    [self createDB];
    if([self openDB]){
        NSMutableString *sql = [[NSMutableString alloc]initWithFormat:@"INSERT INTO '%@' (%@) VALUES('%@')",TBNAME,ITEMID,itemID];
        
        if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL) != SQLITE_OK){
            NSLog(@"LikeItem插入失败");
        }
        sqlite3_close(db);
    }
    
}
-(void)deleteLikeItem:(NSString *)itemID{
    [self createDB];
    if([self openDB]){
        NSMutableString *sql = [[NSMutableString alloc]initWithFormat:@"DELETE FROM %@ WHERE %@='%@'",TBNAME,ITEMID,itemID];
        if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL) != SQLITE_OK){
            NSLog(@"LikeItme delete 失败");
        }
        sqlite3_close(db);
    }

}
//查询
-(NSMutableArray *)searchAllLikeItem{
    //创建数据库
    [self createDB];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if([self openDB]){
        NSString *sqlQuery = [[NSString alloc]initWithFormat:@"SELECT * FROM %@",TBNAME];
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(db,[sqlQuery UTF8String], -1, &statement, NULL) ==SQLITE_OK){
            //绑定参数
            //执行
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *couponIdChar = (char *)sqlite3_column_text(statement, 2);
                NSString *couponId = [[NSString alloc]initWithUTF8String:couponIdChar];
                [array addObject:couponId];
                
            }
            sqlite3_close(db);
            return array;
        }
    }else{
        sqlite3_close(db);
        return  nil;
    }
}

-(void)createDB{
    if([self openDB]){
        char *err;
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,%@ TEXT)",TBNAME,ITEMID];
        if(sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK){
            sqlite3_close(db);
            NSLog(@"LikeItem建表失败");
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
        NSLog(@"LikeItem数据库打开失败");
        return NO;
    }else{
        return YES;
    }
}
@end
