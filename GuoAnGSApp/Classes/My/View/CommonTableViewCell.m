//
//  CommonTableViewCell.m
//  CS_WeiTV
//
//  Created by wy on 15/10/13.
//  Copyright © 2015年 wy. All rights reserved.
//

#import "CommonTableViewCell.h"

#import "ParamFile.h"

@interface CommonTableViewCell ()

@end

@implementation CommonTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonCellMake];
    }
    return self;
}


-(void)commonCellMake
{
    self.image =[[UIImageView alloc]init];
    [self.contentView addSubview:self.image];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image.mas_right).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
   
    
}


@end
