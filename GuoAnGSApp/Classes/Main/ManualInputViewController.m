//
//  ManualInputViewController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/16.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ManualInputViewController.h"
#import "BindPhoneNumberController.h"

@interface ManualInputViewController ()

@end

@implementation ManualInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BtnClick:(UIButton *)sender {
    BindPhoneNumberController * bindVC = [[BindPhoneNumberController alloc]initWithNibName:@"BindPhoneNumberController" bundle:nil ];
    [self.navigationController pushViewController:bindVC animated:YES];
    
    
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
