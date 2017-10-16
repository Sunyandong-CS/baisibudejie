//
//  SYDSubCell.m
//  budejie
//
//  Created by mymac on 2017/9/13.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDSubCell.h"
#import "SYDSubItem.h"
#import <UIImageView+WebCache.h>

@interface SYDSubCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconCell;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation SYDSubCell

- (void)setItem:(SYDSubItem *)item {
    _item = item;
    
    // 设置内容
    self.nameLabel.text = item.theme_name;
    
    // 显示订阅人数 ,当超过10000时显示多少万人订阅
    NSString *numStr = [NSString stringWithFormat:@"%@人订阅",item.sub_number];
    NSInteger num = item.sub_number.integerValue;
    if (num >=10000 ) {
        CGFloat numFinal = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f 万人订阅",numFinal];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    
    self.numLabel.text = numStr;
    
    
    // 设置图片圆角方式: 1.使用系统自带属性 cornerRadius  2.使用图形上下文裁剪
    
    [self.iconCell sd_setImageWithURL:[NSURL URLWithString:item.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        self.iconCell.image = [self getRoundImageWithOriImage:image];
        
        
    }];

}



/*
 *生成一张裁剪的图片
 *@param image  传入一张图片
 *@return       返回一张圆形图片
 */

- (UIImage *)getRoundImageWithOriImage:(UIImage *)image {

    // 1.开启图形上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    // 2.描述要裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    // 3.设置裁剪区域
    [path addClip];
    
    // 4.画图片
    [image drawAtPoint:CGPointZero];
    
    // 5.取出图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

- (void)setFrame:(CGRect)frame {
    
    // UITableView在加载Cell时高度就已经算好了，也就是每个Cell的高度就固定了，这是只要设置Frame的高度，就可以将背景颜色显示出来
    
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // 设置圆角效果
//    self.iconCell.layer.cornerRadius = self.iconCell.bounds.size.width / 2.0;
//    self.iconCell.layer.masksToBounds = YES; // iOS9.0之后修复了多个圆角帧数不稳定的问题，可以放心使用
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
