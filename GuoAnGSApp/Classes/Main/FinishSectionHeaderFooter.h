//
//  FinishSectionHeaderFooter.h
//  CS_WeiTV
//
//  Created by Nina on 17/5/6.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FinishLoadImgDelegate <NSObject>

-(void)selectImgAction;

@end

@interface FinishSectionHeaderFooter : UITableViewHeaderFooterView

@property (nonatomic,strong) UIImageView *imgView;

@property(nonatomic,weak) id<FinishLoadImgDelegate>delegate;
@end
