//
//  ZCZNavigationController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/12/15.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ZCZNavigationController.h"

@interface ZCZNavigationController ()

@end

@implementation ZCZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate{
    // 返回当前显示的viewController是否支持旋转
    return [self.visibleViewController shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    // 返回当前显示的viewController支持旋转的方向
    return [self.visibleViewController preferredInterfaceOrientationForPresentation];
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    // 返回当前显示的viewController是优先旋转的方向
//    if (![self.visibleViewController isKindOfClass:[UIAlertController class]]) {//iOS9 UIWebRotatingAlertController
//        return [self.visibleViewController supportedInterfaceOrientations];
//    }else{
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
