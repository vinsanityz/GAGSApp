//
//  CommonCollectionController.h
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2018/1/24.
//  Copyright © 2018年 zcz. All rights reserved.
//

#import "CommonCtr.h"
@class FirstMovieIdModel;
@interface CommonCollectionController : CommonCtr
@property(nonatomic,strong)FirstMovieIdModel * model;

-(void)requestDataByFirstVideoId;
@end
