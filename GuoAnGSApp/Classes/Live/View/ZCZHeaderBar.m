//
//  ZCZHeaderBar.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/12/19.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ZCZHeaderBar.h"

@interface ZCZHeaderBar()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation ZCZHeaderBar
-(void)awakeFromNib
{
    [super awakeFromNib];
         self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.7];
}

- (IBAction)backButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ZCZHeaderBarBackButtonClick:)]&&self.delegate!=nil) {
        [self.delegate ZCZHeaderBarBackButtonClick:sender];
    }
}

@end
