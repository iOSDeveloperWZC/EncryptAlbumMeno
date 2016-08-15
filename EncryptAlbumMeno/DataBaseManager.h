//
//  DataBaseManager.h
//  DataBaseDemo
//
//  Created by ataw on 16/8/5.
//  Copyright © 2016年 王宗成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DataBaseManager : NSObject
+(sqlite3 *)creatAndOpenDataBaseWithName;
+(BOOL)creatTableNameWithSqlite3:(sqlite3 *)sql3;
+(BOOL)creatMenoTableNameWithSqlite3:(sqlite3 *)sql3;
+(NSArray *)queryValueFormTable;
+(NSArray *)queryValueFormMenoTable;
+(void)insertValueByBindVar:(NSArray *)arr;
+(void)insertMenoValueByBindVar:(NSArray *)arr;
+(BOOL)deleteImage:(NSArray *)arr;
+(BOOL)deleteMeno:(MenoModel *)model;
+(BOOL)updataMenoAccordingTime:(NSString *)time modifyContent:(NSString *)content andTitle:(NSString *)title;
@end
