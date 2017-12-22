//
//  ZCZHeaderBar.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/12/19.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCZHeaderBarDelegate <NSObject>

- (void)ZCZHeaderBarBackButtonClick:(UIButton *)btn;

@end

@interface ZCZHeaderBar : UIView

@property (nonatomic, weak) id<ZCZHeaderBarDelegate> delegate;

@end


