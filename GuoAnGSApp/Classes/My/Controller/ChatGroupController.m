//
//  ChatGroupController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/18.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ChatGroupController.h"

@interface ChatGroupController ()

@end

@implementation ChatGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"testBtn" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 80, 80);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)btnClick:(UIButton *)btn
{
    ChatGroupController *chat = [[ChatGroupController alloc] initWithConversationChatter:@"30320499949569" conversationType:EMConversationTypeGroupChat];
//   self.hidesBottomBarWhenPushed = YES;
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
  
    
    
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
