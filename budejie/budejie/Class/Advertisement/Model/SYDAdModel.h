//
//  SYDAdModel.h
//  budejie
//
//  Created by mymac on 2017/9/13.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SYDAdModel : NSObject
/* 广告真实地址 */
@property (nonatomic, strong) NSString *ori_curl;
/* 广告图片地址 */
@property (nonatomic, strong) NSString *w_picurl;
/* 广告图片宽度 */
@property (nonatomic, assign) CGFloat w;
/* 广告图片高度*/
@property (nonatomic, assign) CGFloat h;

@end
