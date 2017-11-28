//
//  STBButtonView.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/24.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol STBButtonViewDelegate <NSObject>
-(void)didClickSTBButtonViewBtn:(UIButton *)btn;
@end

@interface STBButtonView : UIView


@property(nonatomic,weak)id<STBButtonViewDelegate> delegate;
+(instancetype)show;
@end
