//
//  SYDSubItem.h
//  budejie
//
//  Created by mymac on 2017/9/13.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYDSubItem : NSObject

//image_list，sub_number，theme_name，is_sub
/*图片*/
@property (nonatomic, strong) NSString *image_list;
/*订阅数量*/
@property (nonatomic, assign) NSString *sub_number;
/*名称*/
@property (nonatomic, strong) NSString *theme_name;
/*是否订阅*/
@property (nonatomic, assign) Boolean is_sub;
@end
