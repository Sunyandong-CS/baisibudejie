//
//  SYDVoiceCell.m
//  budejie
//
//  Created by mymac on 2017/10/11.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import "SYDVoiceCell.h"

@implementation SYDVoiceCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置中间视图的控件，并且设置约束
        self.backgroundColor = [UIColor greenColor];
        
        [self.contentView addSubview:[[UISwitch alloc] init]];
        self.textLabel.text = [NSString stringWithFormat:@"%@",self.class];
    }
    
    return self;
}

- (void)setTopic:(SYDTopicModel *)topic {
    [super setTopic:topic];
    
    // 设置中间控件的具体数据，如文字、图片数据等
}

@end
