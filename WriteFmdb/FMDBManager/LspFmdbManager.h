//
//  LspFmdbManager.h
//  WriteFmdb
//
//  Created by 大麦 on 16/2/23.
//  Copyright (c) 2016年 lsp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface LspFmdbManager : NSObject


@property(nonatomic,strong)FMDatabase *db;

+(LspFmdbManager *)shareInstance;
//创建
-(void)fm_createTable;
//插入数据
-(void)fm_insert;
//删除数据
-(void)fm_delete;
//查询
- (void)fm_query;
//查询
- (NSMutableArray *)fm_queryGetArray;


@end
