//
//  UITextField+placeholderColor.m
//  budejie
//
//  Created by mymac on 2017/9/19.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "UITextField+placeholderColor.h"
#import <objc/runtime.h>
@implementation UITextField (placeholderColor)

// 实现交换方法,交换自定义方法和系统方法的实现
+ (void)load {
    
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setSYD_PlaceholderMethod = class_getInstanceMethod(self, @selector(setSYD_Placeholder:));
    method_exchangeImplementations(setPlaceholderMethod, setSYD_PlaceholderMethod);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    // 在设置placeholderColor时候需要用runtime动态添加系统属性placeholderColor
    /*
     *(id object  需要添加属性的对象,
     *const void *key, 需要添加的属性名称
     *id value,添加成员属性的值
     *objc_AssociationPolicy policy) 添加方式
     */
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
}

// 取runtime添加的属性
- (UIColor *)placeholderColor {
    
    /**
     * Returns the value associated with a given object for a given key.
     *
     * @param object The source object for the association.
     * @param key The key for the association.
     *
     * @return The value associated with the key \e key for \e object.
     *
     * @see objc_setAssociatedObject
     */
    return objc_getAssociatedObject(self, @"placeholderColor");
}

//
- (void)setSYD_Placeholder:(NSString *)placeholder {
    
    [self setSYD_Placeholder:placeholder];
    self.placeholderColor = self.placeholderColor;
}

@end
