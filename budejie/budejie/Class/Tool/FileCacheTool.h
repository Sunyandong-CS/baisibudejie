//
//  FileCacheTool.h
//  budejie
//
//  Created by mymac on 2017/9/22.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileCacheTool : NSObject
+ (NSInteger)getFileSize:(NSString *)cachePath completion:(void (^)(NSInteger))completion;


+ (void)removeDirectory:(NSString *)filePath;
@end
