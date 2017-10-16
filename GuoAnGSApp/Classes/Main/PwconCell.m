//
//  PwconCell.m
//  CS_WeiTV
//
//  Created by Nina on 15/8/31.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "PwconCell.h"

@implementation PwconCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _colorData = [SingleColor sharedInstance];
        self.contentView.backgroundColor= [_colorData.colorDic objectForKey:BACK_CONTROL_COLOR];
        [self.contentView addSubview:self.button];
    }
    return self;
}


-(UIButton *)button {
    if (!_button) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0,ScreenSizeWidth, commonCellHigh);
        [_button setTitleColor:WHTIE_NORMAL forState:UIControlStateNormal];
        //设置按钮的背景色
        _button.backgroundColor = HIGHLIGHTED_COLOR;
        _button.titleLabel.font =  [UIFont systemFontOfSize:[[_colorData.fontDic objectForKey:NAORMAL_SIZE] integerValue]];
    }
    return _button;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
