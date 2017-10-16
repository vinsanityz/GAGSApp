//
//  AlertStateView.m
//  CS_WeiTV
//
//  Created by Nina on 16/9/26.
//  Copyright © 2016年 wy. All rights reserved.
//

#import "AlertStateView.h"

#import "ParamFile.h"

@implementation AlertStateView



-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"initWithCoder");
    }
    return self;
}

#pragma mark - <点击刷新响应方法>
- (IBAction)refreshClickAction:(id)sender {
    NSLog(@"点击刷新");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(requestOnceMoreNetWorking)]) {
        [self.delegate requestOnceMoreNetWorking];
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
//    self.alertLabel.textColor = HEXCOLOR(0xcccccc);
    self.alertLabel.textColor = [[SingleColor sharedInstance].colorDic objectForKey:FONT_SEC_COLOR];
    self.refreshBtn.backgroundColor = HEXCOLOR(0x57c88d);
    [self.refreshBtn setTitleColor:WHTIE_NORMAL forState:UIControlStateNormal];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
