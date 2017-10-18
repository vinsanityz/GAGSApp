//
//  SetDetailsController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/16.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "SetDetailsController.h"
#import "MyTabbarViewController.h"

@interface SetDetailsController ()

@end

@implementation SetDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)jumpBtnclick:(UIButton *)btn {
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[MyTabbarViewController alloc]init];
}

@end
