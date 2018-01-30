//
//  CommonCollectionReusableHeaderView.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/29.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommonCollectionReusableHeaderViewDelegate <NSObject>

- (void)CommonCollectionReusableHeaderViewRightButtonClick :(UICollectionReusableView *)view;

@end


@interface CommonCollectionReusableHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong,nonatomic) NSIndexPath * indexPath;
@property (nonatomic, weak) id<CommonCollectionReusableHeaderViewDelegate> delegate;

@end
