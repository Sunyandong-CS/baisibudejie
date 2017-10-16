//
//  SYDTabBar.h
//  budejie
//
//  Created by mymac on 2017/9/5.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublishButtonDelegate <NSObject>

@optional
// 当按钮点击做的事情
- (void)btnClick:(id)sender;
@end

@interface SYDTabBar : UITabBar
@property (nonatomic, weak) UIButton *addbtn;

// 代理回调接口，即代理属性
@property (nonatomic, weak) id<PublishButtonDelegate> delegate;

@end
