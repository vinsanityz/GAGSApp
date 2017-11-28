//
//  ZCZLabel.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/10.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ZCZLabel.h"

@implementation ZCZLabel

+(instancetype)showWithTitle:(NSString * )str
{
    ZCZLabel *label = [ZCZLabel new];
    
    label.font = [UIFont systemFontOfSize:13    ];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.text = str;
    
    
NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    
    // 2. 为文本设置属性
    text.yy_font = [UIFont boldSystemFontOfSize:13];
    text.yy_color = [UIColor blueColor];
    [text yy_setColor:[UIColor redColor] range:NSMakeRange(0, 4)];
    text.yy_lineSpacing = 10;
    
    // 3. 赋值到 YYLabel 或 YYTextView
 
//    label.attributedString = text;
    label.attributedText = text;
    return label;

    
    
    
}

@end
