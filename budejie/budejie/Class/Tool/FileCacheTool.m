//
//  FileCacheTool.m
//  budejie
//
//  Created by mymac on 2017/9/22.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "FileCacheTool.h"
#import <UIKit/UIKit.h>
@implementation FileCacheTool

+ (void)getFileSize:(NSString *)cachePath completion:(void (^)(NSInteger))completion {
    
    // 1.创建文件管理者对象
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 异常处理
    BOOL isDirectory;
    [mgr fileExistsAtPath:cachePath isDirectory:&isDirectory];
    if (!isDirectory) {
        NSException *exp = [NSException exceptionWithName:@"invalid cache directory" reason:@"笨蛋，要传入一个文件路径" userInfo:nil];
        [exp raise];
    }
    
    // 2.获取缓存目录下的所有文件
    NSArray *pathArr = [mgr subpathsAtPath:cachePath];
    
    
    
    // 开启子线程处理耗时操作
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger totalSize = 0;// 统计文件总大小
        // 3.遍历文件目录下的所有文件
        for (NSString *path in pathArr) {
            
            // 4.拼接文件真实路径
            NSString *filePath = [cachePath stringByAppendingPathComponent:path];
            
            // 5.判断是否为文件夹
            BOOL isExist;
            BOOL isDirectory;
            isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isExist || isDirectory) continue;
            
            // 6.获取文件大小
            NSDictionary *attrs = [mgr attributesOfItemAtPath:filePath error:nil];
            totalSize += [attrs fileSize];

            
            // 将获取到的文件传递出去
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(totalSize);
                }
            });
            
        }
    });
}


+ (void)removeDirectory:(NSString *)filePath {
    
    // 1.创建文件管理者对象
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 异常处理
    BOOL isDirectory;
    BOOL isExist;
    isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!isDirectory || !isExist) {
        NSException *exp = [NSException exceptionWithName:@"invalid cache directory" reason:@"笨蛋，要传入一个文件路径,并且文件路径要存在！" userInfo:nil];
        [exp raise];
    }
    
    // 2.获取缓存目录下的所有文件夹
    NSArray *pathArr = [mgr contentsOfDirectoryAtPath:filePath error:nil];
    
    // 3.遍历文件目录下的所有文件
    for (NSString *path in pathArr) {
        
        // 4.拼接文件真实路径
        NSString *realPath = [filePath stringByAppendingPathComponent:path];
        
        // 5.删除文件
        [mgr removeItemAtPath:realPath error:nil];
        
    }
}

- (NSString *)showFileSize:(NSInteger *)fileSize {
    
    return @"";
}


@end
