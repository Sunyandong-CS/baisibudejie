//
//  SYDTextField.m
//  budejie
//
//  Created by mymac on 2017/9/18.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDTextField.h"
#import "UITextField+placeholderColor.h"

@implementation SYDTextField

/*
 *思考：在哪里更改文字和光标的颜色：因为只要执行一次，那么需要在加载的时候执行
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置光标的颜色为白色
    self.tintColor = [UIColor whiteColor];
    
    // 开始编辑的时候更改placeholder的颜色
    [self addTarget:self action:@selector(textBegain) forControlEvents:UIControlEventEditingDidBegin];
    
    // 结束编辑的时候更改placeholder的颜色
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)textBegain {
    // 设置字体颜色
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
//
    // 由于placeHolder底层是一个label 我们只需要拿到这个label并设置label的文字颜色即可，这里也可以选择添加分类属性，快速实现
    
    /*
     *直接实现kvc
     */
    //    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    //    placeholderLabel.textColor = [UIColor redColor];
    //
    
    /*
     *使用分类实现
     */
    self.placeholderColor = [UIColor whiteColor];
    
}

- (void)textEnd {
    // 设置字体颜色
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];

    self.placeholderColor = [UIColor blackColor];
}

@end
