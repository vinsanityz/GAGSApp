//
//  SetPasswordController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/16.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "SetPasswordController.h"
#import "SetDetailsController.h"

@interface SetPasswordController ()

@end

@implementation SetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClick:(id)sender {
    
    SetDetailsController * detailVC = [[SetDetailsController alloc]initWithNibName:@"SetDetailsController" bundle:nil ];
    [self.navigationController pushViewController:detailVC animated:YES];
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
