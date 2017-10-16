//
//  FinishSectionHeaderFooter.m
//  CS_WeiTV
//
//  Created by Nina on 17/5/6.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "FinishSectionHeaderFooter.h"

#import "ParamFile.h"

@implementation FinishSectionHeaderFooter {
    UILabel *_titleLabel;
    SingleColor *_single;
}


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _single = [SingleColor sharedInstance];
        [self createFinishSectionView];
    }
    return self;
}

-(void)createFinishSectionView {
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = 55;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.userInteractionEnabled = YES;
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"上传头像";
    _titleLabel.textColor = [_single.colorDic objectForKey:FONT_MAIN_COLOR];
    _titleLabel.font = [UIFont systemFontOfSize:[[_single.fontDic objectForKey:NAORMAL_SIZE] integerValue]];
    //注：这里不要添加到self.cotentView上,因为响应方法失效
    [self addSubview:self.imgView];
    [self addSubview:_titleLabel];
    
    
    UITapGestureRecognizer *uploadTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadAction)];
    [self.imgView addGestureRecognizer:uploadTap];
}


-(void)uploadAction {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectImgAction)]) {
        [self.delegate selectImgAction];
    }
}

- (void)layoutSubviews {
    self.imgView.frame = CGRectMake((ScreenSizeWidth - 110) / 2, 20, 110, 110);
    _titleLabel.frame = CGRectMake((ScreenSizeWidth - 100) / 2, 130, 100, 30);
    
}


@end
