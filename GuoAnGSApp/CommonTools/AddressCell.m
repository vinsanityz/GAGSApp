//
//  AddressCell.m
//  CS_WeiTV
//
//  Created by Nina on 15/11/3.
//  Copyright © 2015年 wy. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.currentLabel];
//        UIView *separ = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenSizeWidth , 1)];
//        self.separator = separ;
//        [self addSubview:self.separator];

    }
    return self;
}

-(UILabel *)currentLabel {
    if (!_currentLabel) {
        self.currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 90, 40)];
    }
    return _currentLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
