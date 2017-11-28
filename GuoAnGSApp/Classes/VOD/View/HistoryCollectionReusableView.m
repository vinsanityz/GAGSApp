//
//  HistoryCollectionReusableView.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/9.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "HistoryCollectionReusableView.h"

@implementation HistoryCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    
}
- (IBAction)cleanButtonClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(HistoryCollectionReusableViewCleanButtonClick)]&&self.delegate!=nil) {
        [self.delegate HistoryCollectionReusableViewCleanButtonClick];
        
    }
}

@end
