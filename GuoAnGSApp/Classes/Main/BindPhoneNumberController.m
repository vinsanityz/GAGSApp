//
//  BindPhoneNumberController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/16.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "BindPhoneNumberController.h"
#import "SetPasswordController.h"

@interface BindPhoneNumberController ()

@end

@implementation BindPhoneNumberController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Btnclick:(UIButton *)sender {
    SetPasswordController * vc = [[SetPasswordController alloc]initWithNibName:@"SetPasswordController" bundle:nil ];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
