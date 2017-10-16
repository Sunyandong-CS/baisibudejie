//
//  SYDSubCell.h
//  budejie
//
//  Created by mymac on 2017/9/13.
//  Copyright © 2017年 com.xididan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYDSubItem;
@interface SYDSubCell : UITableViewCell
/*自定义cell的数据模型*/
@property (nonatomic, strong) SYDSubItem *item;
@end
