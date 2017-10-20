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
    UIView * view = [[UIView alloc]init];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor greenColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@30);
    }];
    
}
-(void)setUpMembersTableView
{
    UITableView * membersTableView = [[UITableView alloc]init];
    [self.view addSubview:membersTableView];
    [membersTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64+30);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@300);
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
@end
