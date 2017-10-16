//
//  SYDSquareCell.m
//  budejie
//
//  Created by mymac on 2017/9/19.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDSquareCell.h"
#import "SYDSquareItemModel.h"
#import <UIImageView+WebCache.h>

@interface SYDSquareCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameV;
@property (weak, nonatomic) IBOutlet UIImageView *iconV;

//@property (weak, nonatomic) IBOutlet UIImageView *iconV;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SYDSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(SYDSquareItemModel *)item{
    _item = item;
    [_iconV sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    _nameV.text = item.name;
}


@end
