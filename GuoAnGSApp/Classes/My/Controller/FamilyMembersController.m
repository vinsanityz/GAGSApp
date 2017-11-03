//
//  FamilyMembersController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/20.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "FamilyMembersController.h"
#import <Masonry.h>
#import "MembersTableViewCell.h"

@interface FamilyMembersController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView * membersTableView;
@property(nonatomic,weak)UIView *tipsView ;
@end

@implementation FamilyMembersController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpTipsView];
    [self setUpMembersTableView];
}
-(void)setUpTipsView
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"X" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(280, 0, 80, 30);
    
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * view = [[UIView alloc]init];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor greenColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@30);
    }];
    [view addSubview:btn];
    self.tipsView = view;
}
-(void)setUpMembersTableView
{
    UITableView * membersTableView = [[UITableView alloc]init];
    [self.view addSubview:membersTableView];
    [membersTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64+30);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@600);
    }];
    membersTableView.delegate = self;
    membersTableView.dataSource = self;
    membersTableView.rowHeight = 88;
    [membersTableView registerNib:[UINib nibWithNibName:@"MembersTableViewCell" bundle:nil] forCellReuseIdentifier:@"memberSTableViewCell"];
    self.membersTableView = membersTableView;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MembersTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"memberSTableViewCell"];
    return cell;
}

-(void)rightBtnClick:(UIButton * )btn
{
    [self.tipsView removeFromSuperview];
    [self.membersTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
    }];
    
    //更新约束
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
@end
