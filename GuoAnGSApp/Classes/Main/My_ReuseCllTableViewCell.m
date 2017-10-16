//
//  My_ReuseCllTableViewCell.m
//  CS_WeiTV
//
//  Created by Nina on 17/5/6.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "My_ReuseCllTableViewCell.h"

#import "ParamFile.h"

@implementation My_ReuseCllTableViewCell{
    SingleColor *_single;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _single = [SingleColor sharedInstance];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    
    self.backgroundColor = [_single.colorDic objectForKey:BACK_CONTROL_COLOR];
    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.font =  [UIFont systemFontOfSize:[[_single.fontDic objectForKey:NAORMAL_SIZE] intValue]];
    self.leftLabel.textColor =  [_single.colorDic objectForKey:FONT_MAIN_COLOR];
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.leftLabel];
    
    self.rightLabel = [[UILabel alloc]init];
    self.rightLabel.font =  [UIFont systemFontOfSize:[[_single.fontDic objectForKey:SMALL_SIZE] intValue]];
    self.rightLabel.textColor = [_single.colorDic objectForKey:FONT_SEC_COLOR];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightLabel];
    
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-40);
        make.centerY.equalTo(self);
        
    }];
}


@end
