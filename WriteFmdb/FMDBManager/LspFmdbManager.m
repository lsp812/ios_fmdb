//
//  LspFmdbManager.m
//  WriteFmdb
//
//  Created by 大麦 on 16/2/23.
//  Copyright (c) 2016年 lsp. All rights reserved.
//

#import "LspFmdbManager.h"

@implementation LspFmdbManager

+(LspFmdbManager *)shareInstance
{
    static dispatch_once_t one;
    static LspFmdbManager *instance = nil;
    dispatch_once(&one, ^{
        instance = [[LspFmdbManager alloc]init];
    });
    return instance;
}

#pragma mark -- 数据库操作
//创建
-(void)fm_createTable
{
    //1.获得数据库文件的路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"student.sqlite"];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    
    //3.打开数据库
    if ([db open]) {
        //4.创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        }else
        {
            NSLog(@"创表失败");
        }
    }
    self.db=db;
}
//插入数据
-(void)fm_insert
{
    for (int i = 0; i<1; i++) {
        NSString *name = [NSString stringWithFormat:@"jack-%d", arc4random_uniform(100)];
        // executeUpdate : 不确定的参数用?来占位
        [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);", name, @(arc4random_uniform(40))];
        //        [self.db executeUpdate:@"INSERT INTO t_student (name, age) VALUES (?, ?);" withArgumentsInArray:@[name, @(arc4random_uniform(40))]];
        
        // executeUpdateWithFormat : 不确定的参数用%@、%d等来占位
        //        [self.db executeUpdateWithFormat:@"INSERT INTO t_student (name, age) VALUES (%@, %d);", name, arc4random_uniform(40)];
    }
}
//删除数据
-(void)fm_delete
{
    //    [self.db executeUpdate:@"DELETE FROM t_student;"];
    [self.db executeUpdate:@"DROP TABLE IF EXISTS t_student;"];
    [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);"];
}

//查询
- (void)fm_query
{
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_student"];
    
    // 2.遍历结果
    while ([resultSet next]) {
        int ID = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        int age = [resultSet intForColumn:@"age"];
        NSLog(@"%d %@ %d", ID, name, age);
    }
}
//查询
- (NSMutableArray *)fm_queryGetArray
{
    NSMutableArray *arr = [NSMutableArray array];
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_student"];
    
    // 2.遍历结果
    while ([resultSet next]) {
        int ID = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet stringForColumn:@"name"];
        int age = [resultSet intForColumn:@"age"];
        
        NSString *idString = [NSString stringWithFormat:@"%d",ID];
        NSString *nameString = [NSString stringWithFormat:@"%@",name];
        NSString *ageString = [NSString stringWithFormat:@"%d",age];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:idString,@"id",nameString,@"name",ageString,@"age", nil];
        [arr addObject:dic];
    }
    return arr;
}

@end
