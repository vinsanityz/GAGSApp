//
//  HeaderCell.m
//  CS_WeiTV
//
//  Created by Nina on 15/8/18.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.images];
        [self.contentView addSubview:self.titleLabel];
//         [self.contentView addSubview:self.btn];
    }
    return self;
}

-(UIImageView *)images {
    if (!_images) {
        _images = [[UIImageView alloc] initWithFrame:CGRectMake(150, 5, 70, 70)];

        _images.contentMode = UIViewContentModeScaleAspectFill;
        //将头像设置为圆形的
        _images.layer.cornerRadius = 35;//设置圆角的半径
        _images.layer.masksToBounds = YES;//设置为YES,就可以使用圆角,layer才能生效
        _images.layer.borderWidth = 1;//视图的边框宽度
        _images.layer.borderColor = [UIColor whiteColor].CGColor;
            }
    return _images;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 85,[UIScreen mainScreen].bounds.size.width - 110,30)];
    
    }
    return _titleLabel;
}

-(UIButton *)btn{

UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
[btn setTitle:@"登陆/注册" forState:UIControlStateNormal];

[btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
[btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(200, 20, 100, 50);
    

    return btn;

}


@end
