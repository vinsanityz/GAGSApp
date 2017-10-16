//
//  AlertStateView.h
//  CS_WeiTV
//
//  Created by Nina on 16/9/26.
//  Copyright © 2016年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RequestMoreDelegate <NSObject>

@optional
-(void)requestOnceMoreNetWorking;

@end

@interface AlertStateView : UIView

@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property(nonatomic,weak)id<RequestMoreDelegate>delegate;

@end
