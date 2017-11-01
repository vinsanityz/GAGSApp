//
//  ChatGroupController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/18.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ChatGroupController.h"

#import "FamilyMembersController.h"

@interface ChatGroupController ()
@property(nonatomic,strong)EMGroup *group;
@end

@implementation ChatGroupController




- (void)viewDidLoad {
    [super viewDidLoad];
    //获取成员数组
    __weak typeof(self) weakSelf = self;
    [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:@"30320499949569" completion:^(EMGroup *aGroup, EMError *aError) {
        weakSelf.group = aGroup;
        self.navigationItem.title = [NSString stringWithFormat:@"家庭成员(%ld)",1];
        if (aError) {
            NSLog(@"error-----%@",aError.errorDescription);
        }
    }];
        
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"成员" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 80, 80);
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}


-(void)btnClick:(UIButton *)btn
{
    FamilyMembersController * familyVC = [[FamilyMembersController alloc]init];
    familyVC.hidesBottomBarWhenPushed = YES;
    familyVC.dataArray = @[self.group.owner];
    [self.navigationController pushViewController:familyVC animated:YES];
}

@end
