//
//  HistoryCollectionReusableView.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/9.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol HistoryCollectionReusableViewDelegate <NSObject>

- (void)HistoryCollectionReusableViewCleanButtonClick;

@end

@interface HistoryCollectionReusableView : UICollectionReusableView
@property(nonatomic,weak) id<HistoryCollectionReusableViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cleanButton;

@end
