//
//  EPGRightTableViewCell.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/17.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
#import "ZCZLabel.h"
@interface EPGRightTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet ZCZLabel *LabelView;

@end
