//
//  DataBaseManager.m
//  DataBaseDemo
//
//  Created by ataw on 16/8/5.
//  Copyright © 2016年 王宗成. All rights reserved.
//

#import "DataBaseManager.h"
#import <sqlite3.h>
#import <objc/runtime.h>
#import <objc/objc.h>

/**
 *  数据库密码
 */
#define WZCDBPassword @"moxiwoij4923b823298hq9832hr2938"

@implementation DataBaseManager
{

}

#pragma mark - Table 行从0开始  列从1开始

#pragma mark - 私有接口

/**
 *  返回数据库路径
 *
 *  @param dbName 数据库名字
 *
 *  @return 返回路径
 */
+(NSString *)dataBasePath:(NSString *)dbName
{

    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",dbName];
    return filePath;
}


/**
 *  运行时得到所有的属性名字
 *
 *  @param class 需要存储的对象的类
 *
 *  @return 返回属性名字集合
 */
+ (NSArray *)getAllProperties:(Class)class
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList(class, &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

/**
 *  获取属性名称 和 对应的类型
 *
 *  @param klass 对象所属类
 *
 *  @return 属性名：属性类型  字典
 */
+ (NSDictionary *)classPropsFor:(Class)klass
{
    if (klass == NULL) {
        return nil;
    }
    
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];
            
            NSLog(@"propertyName %@ propertyType %@", propertyName, propertyType);
            
            [results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);
    
    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
}

#pragma mark - 获取属性类型名
//获取属性的方法 c语言写法T@"NSString",C,N,V_name  Tf,N,V__float
/**
 *  获取属性对应的类型
 *
 *  @param property <#property description#>
 *
 *  @return 字符串格式的类型  集合
 */
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];//多一个结束符号
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}


#pragma mark - 公开接口

#pragma mark - 删除指定名字的数据库

+(void)deleteDataBaseName:(NSString *)dataBaseName
{
    NSString *DBName = [dataBaseName stringByAppendingString:@".db"];
    NSString *DBPath = [self dataBasePath:DBName];
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    [fileManager removeItemAtPath:DBPath error:nil];
}

#pragma mark - 数据库名字后缀不加.db 创建数据库并打开 如果打开失败返回nil 否则打开成功返回数据库句柄
/**
 *  创建并打开数据库 成则返回数据库句柄 失败返回nil 改函数不会重复创建同名数据库
 *
 *  @param dataBaseName 数据库名字 不需要加后缀
 *
 *  @return 数据库句柄 或者 nil
 */
+(sqlite3 *)creatAndOpenDataBaseWithName
{
    
    NSString *DBName = [WZCDBName stringByAppendingString:@".db"];
//    CREATE DATABASE database-name
    NSString *DBPath = [self dataBasePath:DBName];
    NSLog(@"DBPath:%@",DBPath);
    sqlite3 *sql3 = NULL;//数据库句柄 和 文件句柄FILE差不多
    
    //1打开数据库 如果路径下面没有 则创建数据库
    int Result = sqlite3_open([DBPath UTF8String],&sql3);
    NSLog(@"result:%d",Result);
    if (Result == SQLITE_OK) {
        /*
         const char* key = [@"StrongPassword" UTF8String];
         sqlite3_key(db, key, (int)strlen(key));
         */
        sqlite3_key(sql3, [WZCDBPassword UTF8String], (int)WZCDBPassword.length);
        NSLog(@"打开成功");
        return sql3;
    }
    else
    {
        NSLog(@"打开失败");
        return nil;
    }
    
}

#pragma mark - 在数据库中创建表格 tableName 表名  sql3 数据库句柄
/**
 *  创建表 图片名字  图片大小 图片二进制数据
 *
 *  @param tableName 表明
 *  @param sql3      数据库文件指针
 *
 *  @return 是否创建成功
 */
+(BOOL)creatTableNameWithSqlite3:(sqlite3 *)sql3
{
  
    if (sql3 == nil) {
        
        return NO;
    }

    NSString *sqlSentence = [NSString stringWithFormat:@"create table if not exists %@(ImageName text,ImageSize text,ImageData BLOB)",WZCTableName];
    
    char *error = NULL;

    int Result;
    Result = sqlite3_exec(sql3,[sqlSentence UTF8String],NULL,NULL,&error);
    
    if (Result != SQLITE_OK) {
        
        NSLog(@"错误码%d 创建失败",Result);
        sqlite3_close(sql3);
        return NO;
    }
    else
    {
        NSLog(@"创建成功");
    }
//    sqlite3_close(sql3);
    
    return YES;
}


+(BOOL)creatMenoTableNameWithSqlite3:(sqlite3 *)sql3
{
    
    if (sql3 == nil) {
        
        return NO;
    }
    
    NSString *sqlSentence = [NSString stringWithFormat:@"create table if not exists %@(title text,time text,content text)",WZCMenoTableName];
    
    char *error = NULL;
    
    int Result;
    Result = sqlite3_exec(sql3,[sqlSentence UTF8String],NULL,NULL,&error);
    
    if (Result != SQLITE_OK) {
        
        NSLog(@"错误码%d 创建失败",Result);
        sqlite3_close(sql3);
        return NO;
    }
    else
    {
        NSLog(@"创建成功");
    }
    //    sqlite3_close(sql3);
    
    return YES;
}

#pragma mark - 查询
+(NSArray *)queryValueFormMenoTable
{
    
    NSMutableArray *modelArr = [NSMutableArray array];
    sqlite3 *sql3 = [self creatAndOpenDataBaseWithName];
  
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",WZCMenoTableName];
    
    sqlite3_stmt *statement;
    int result = sqlite3_prepare_v2(sql3 ,[query UTF8String],-1,&statement,nil);
    //语句准备好了
    if (result == SQLITE_OK) {
        
        //开始遍历行(执行select语句)
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char *charValue =(char *)sqlite3_column_text(statement,0);
            NSString *title = [NSString stringWithUTF8String:charValue];
            
            char *charValue1 =(char *)sqlite3_column_text(statement,1);
            NSString *time = [NSString stringWithUTF8String:charValue1];
            
            char *charValue3 =(char *)sqlite3_column_text(statement, 2);
            NSString *content = [NSString stringWithUTF8String:charValue3];
            
            MenoModel *model = [[MenoModel alloc]init];
            model.title = title;
            model.time = time;
            model.content = content;
            [modelArr addObject:model];
        }
        //结束语句
        sqlite3_finalize(statement);
        
    }
    
    //关闭数据库
    sqlite3_close(sql3);
    return modelArr;
}



#pragma mark - 查询
+(NSArray *)queryValueFormTable
{
    
    NSMutableArray *modelArr = [NSMutableArray array];
    sqlite3 *sql3 = [self creatAndOpenDataBaseWithName];
//    if (![self creatTableNameWithSqlite3:sql3]) {
//        
//        NSLog(@"创建table失败");
//        return nil;
//    }
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@",WZCTableName];
    
    sqlite3_stmt *statement;
    int result = sqlite3_prepare_v2(sql3 ,[query UTF8String],-1,&statement,nil);
    //语句准备好了
    if (result == SQLITE_OK) {
        
        //开始遍历行(执行select语句)
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            int bytes = sqlite3_column_bytes(statement, 2);
            
            char *charValue =(char *)sqlite3_column_text(statement,0);
            NSString *ImageName = [NSString stringWithUTF8String:charValue];
            
            char *charValue1 =(char *)sqlite3_column_text(statement,1);
            NSString *ImageSize = [NSString stringWithUTF8String:charValue1];
            
            Byte *charValue3 =(Byte *)sqlite3_column_blob(statement, 2);
            NSData *imageData = [NSData dataWithBytes:charValue3 length:bytes];
            
            ImageModel *model = [[ImageModel alloc]init];
            model.imageName = ImageName;
            model.imageSize = ImageSize;
            model.imageData = imageData;
            
            [modelArr addObject:model];
        }
        //结束语句
        sqlite3_finalize(statement);
       
    }
    
    //关闭数据库
    sqlite3_close(sql3);
    return modelArr;
}


#pragma mark - 增加 相机和相册
+(void)insertValueByBindVar:(NSArray *)arr
{
    sqlite3 *sql3 = [self creatAndOpenDataBaseWithName];
    if (![self creatTableNameWithSqlite3:sql3]) {
        
        NSLog(@"创建table失败");
        return;
    }
    
    NSString *query = [NSString stringWithFormat:@"insert into %@(ImageName,ImageSize,ImageData) values(?,?,?)",WZCTableName];

    sqlite3_stmt *statement;
    int result = sqlite3_prepare_v2(sql3 ,[query UTF8String],-1,&statement,nil);
    //语句准备好了
    if (result == SQLITE_OK) {
        
        //绑定方法参数 sqlite3_stmt 表示sqlite3_prepare_v2中的那个 第二个表示对应问号，第三个都是表示问号对应的值，第四个表示第三个参数的长度，文本数据类型传－1 代表整个字符串，其他类型的需要指定所传数据长度，
        //开始遍历行(执行select语句)
        //1表示第一个问号 依次类推
        for (ImageModel *model in arr) {
            
            sqlite3_bind_text(statement,1,[model.imageName UTF8String],-1,NULL);
            sqlite3_bind_text(statement,2,[model.imageSize UTF8String],-1,NULL);
            sqlite3_bind_blob(statement,3, [model.imageData bytes], (int)[model.imageData length], NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                NSLog(@"插入完成");
                
                [XHToast showCenterWithText:@"保存成功,可去相册查看" duration:1.5];
            }
        }
    
    };
    
    //结束语句
    sqlite3_finalize(statement);
    sqlite3_close(sql3);

}


+(void)insertMenoValueByBindVar:(NSArray *)arr
{
    sqlite3 *sql3 = [self creatAndOpenDataBaseWithName];
    if (![self creatMenoTableNameWithSqlite3:sql3]) {
        
        NSLog(@"创建table失败");
        return;
    }
    
    NSString *query = [NSString stringWithFormat:@"insert into %@(title,time,content) values(?,?,?)",WZCMenoTableName];
    
    sqlite3_stmt *statement;
    int result = sqlite3_prepare_v2(sql3 ,[query UTF8String],-1,&statement,nil);
    //语句准备好了
    if (result == SQLITE_OK) {
        
        //绑定方法参数 sqlite3_stmt 表示sqlite3_prepare_v2中的那个 第二个表示对应问号，第三个都是表示问号对应的值，第四个表示第三个参数的长度，文本数据类型传－1 代表整个字符串，其他类型的需要指定所传数据长度，
        //开始遍历行(执行select语句)
        //1表示第一个问号 依次类推
        for (MenoModel *model in arr) {
            
            sqlite3_bind_text(statement,1,[model.title UTF8String],-1,NULL);
            sqlite3_bind_text(statement,2,[model.time UTF8String],-1,NULL);
            sqlite3_bind_text(statement,3, [model.content UTF8String], -1,NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                NSLog(@"插入完成");
                
                [XHToast showCenterWithText:@"保存成功" duration:1.5];
            }
        }
        
    };
    
    //结束语句
    sqlite3_finalize(statement);
    sqlite3_close(sql3);
    
}

#pragma mark - 删 根据id查询 需要转化为C语言类型字符串
+(BOOL)deleteImage:(NSArray *)arr
{
    sqlite3 *sql3 = [self creatAndOpenDataBaseWithName];
    if (![self creatTableNameWithSqlite3:sql3]) {
        
        NSLog(@"创建table失败");
        return NO;
    }
    for (ImageModel *model in arr) {
        
        
        NSString *sqlSentence = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ImageName='%@'",WZCTableName,model.imageName];
        
        char *error = NULL;
        
        int Result;
        Result = sqlite3_exec(sql3,[sqlSentence UTF8String],NULL,NULL,&error);
        
        if (Result != SQLITE_OK) {
            
            NSLog(@"错误码%d 删除失败",Result);
            sqlite3_close(sql3);
            return NO;
        }
        else
        {
            NSLog(@"删除成功");
            sqlite3_close(sql3);
            return YES;
        }
    }
    return NO;
}

+(BOOL)deleteMeno:(MenoModel *)model
{
    sqlite3 *sql3 = [self creatAndOpenDataBaseWithName];
    if (![self creatTableNameWithSqlite3:sql3]) {
        
        NSLog(@"创建table失败");
        return NO;
    }

        NSString *sqlSentence = [NSString stringWithFormat:@"DELETE FROM %@ WHERE time='%@'",WZCMenoTableName,model.time];
        
        char *error = NULL;
        
        int Result;
        Result = sqlite3_exec(sql3,[sqlSentence UTF8String],NULL,NULL,&error);
        
        if (Result != SQLITE_OK) {
            
            NSLog(@"错误码%d 删除失败",Result);
            sqlite3_close(sql3);
            return NO;
        }
        else
        {
            NSLog(@"删除成功");
            sqlite3_close(sql3);
            return YES;
        }

    return NO;
}

+(BOOL)updataMenoAccordingTime:(NSString *)time modifyContent:(NSString *)content andTitle:(NSString *)title
{
    sqlite3 *sql3 = [self creatAndOpenDataBaseWithName];
    if (![self creatTableNameWithSqlite3:sql3]) {
        
        NSLog(@"创建table失败");
        return NO;
    }
    //UPDATE familymember set Family_ID=32767 WHERE ID=179;
    NSString *sqlSentence = [NSString stringWithFormat:@"UPDATE %@ set content = '%@',title = '%@' WHERE time='%@'",WZCMenoTableName,content,title,time];
    
    char *error = NULL;
    
    int Result;
    Result = sqlite3_exec(sql3,[sqlSentence UTF8String],NULL,NULL,&error);
    
    if (Result != SQLITE_OK) {
        
        NSLog(@"错误码%d 更新失败",Result);
        sqlite3_close(sql3);
        return NO;
    }
    else
    {
        NSLog(@"更新成功");
        sqlite3_close(sql3);
        return YES;
    }
    
    return NO;

}
@end
