//
//  CommonCollectionReusableHeaderView.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/29.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import "CommonCollectionReusableHeaderView.h"

@implementation CommonCollectionReusableHeaderView
- (IBAction)moreBtnclick:(UIButton *)sender {
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(CommonCollectionReusableHeaderViewRightButtonClick:)]) {
        [self.delegate CommonCollectionReusableHeaderViewRightButtonClick:self];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
