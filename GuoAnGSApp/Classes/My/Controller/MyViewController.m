//
//  MyViewController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/9/27.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "MyViewController.h"
#import "ChatGroupController.h"
#import "FamilyMembersController.h"

#import <Hyphenate/Hyphenate.h>
#import <EaseUI.h>

#import "CommonTableViewCell.h"
#import "HeaderCell.h"
@interface MyViewController ()<EMGroupManagerDelegate,UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) UITableView *tableView;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"talk" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(100, 100, 80, 80);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick1:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    self.showLeft = NO;
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HeaderCell class] forCellReuseIdentifier:@"cellHeader"];
    [self.tableView registerClass:[CommonTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(colorPersonChange) name:ColorNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeTextColorActionTwo:) name:FontNoti object:nil];
}
-(void)btnClick1:(UIButton *)btn
{
//    EMError *error = nil;
//    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
//    setting.maxUsersCount = 500;
//    setting.style = EMGroupStylePublicOpenJoin;// 创建不同类型的群组，这里需要才传入不同的类型
//    EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:@"群组名称" description:@"群组描述" invitees:nil message:@"邀请您加入群组" setting:setting error:&error];
//    if(!error){
//        //30320499949569
//        NSLog(@"创建成功 -- %@",group);
//    }
//    NSLog(@"%@",group.groupId);
    ChatGroupController *chat = [[ChatGroupController alloc] initWithConversationChatter:@"30320499949569" conversationType:EMConversationTypeGroupChat];
    [[EMClient sharedClient].groupManager applyJoinPublicGroup:@"30320499949569" message:@"iwantin" error:nil];
    
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:@"30320499949569" error:&error];
    NSLog(@"%@",group.owner);
    
    [self.navigationController pushViewController:chat animated:YES];
}








-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenSizeWidth,ScreenSizeHeigh -64 - 44) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [single.colorDic objectForKey:LINECOLOR];
        //隐藏竖直方向的滑动条
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}





-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)handleChangeTextColorActionTwo:(NSNotificationCenter *)notification {
    [self.tableView reloadData];
}


-(void)colorPersonChange{
    [self.tableView reloadData];
    self.tableView.separatorColor = [single.colorDic objectForKey:LINECOLOR];
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return 1;
   
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HeaderCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:@"cellHeader" forIndexPath:indexPath];
        cellHeader.selectionStyle = UITableViewCellSelectionStyleNone;
        cellHeader.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (kPermanent_GET_OBJECT(kGetName)== nil) {
            cellHeader.titleLabel.text = @"待完善";
        }else{
            cellHeader.titleLabel.text = kPermanent_GET_OBJECT(kGetName);
        }
        cellHeader.titleLabel.textColor = [UIColor whiteColor];
        cellHeader.titleLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] intValue]];
        NSString *mergeStr =  [NSString stringWithFormat:PreHttpImage,kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort),kPermanent_GET_OBJECT(KGetHeadImageUrl)];
        NSLog(@"mergeStr:%@",mergeStr);
        [cellHeader.images sd_setImageWithURL:[NSURL URLWithString:mergeStr] placeholderImage:[UIImage imageNamed:MAX_IMAGE]];
        
        
        cellHeader.backgroundColor = BACK_CONTROL_BLACK;
        return cellHeader;
    } else {
        CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [single.colorDic objectForKey:BACK_CONTROL_COLOR];
        cell.titleLabel.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
        cell.titleLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE]intValue]];
        
        cell.titleLabel.text = MY_SectionArraySecond[indexPath.section-1];
        [cell.image setImage:[UIImage imageNamed:MY_PictureNameSecond[indexPath.row]]];//添加图标
        return cell;
    }
}


#pragma mark - UITableViewDelegate -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [MY_SectionArraySecond count]+1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }else {
        return 44;
    }
}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        MessageVC *message = [[MessageVC alloc] init];
//        message.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:message animated:YES];
//    }else{
//        switch (indexPath.row) {
//            case 0:
//            {
//                AboutVC *about = [[AboutVC alloc] init];
//                about.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:about animated:YES];
//                break;
//            }
//            case 1:
//            {
//                SetVC *set = [[SetVC alloc] init];
//                set.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:set animated:YES];
//                break;
//            }
//            default:
//                break;
//        }
//    }
//}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * vi = [[UIView alloc]init];
    return vi;
}




-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
//        ChatGroupController *chat = [[ChatGroupController alloc] initWithConversationChatter:@"30320499949569" conversationType:EMConversationTypeGroupChat];
//        //   self.hidesBottomBarWhenPushed = YES;
//        chat.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:chat animated:YES];
        FamilyMembersController * familyVC = [[FamilyMembersController alloc]init];
        familyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:familyVC animated:YES];
    }
    if (indexPath.section==0) {
                ChatGroupController *chat = [[ChatGroupController alloc] initWithConversationChatter:@"30320499949569" conversationType:EMConversationTypeGroupChat];
                //   self.hidesBottomBarWhenPushed = YES;
                chat.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chat animated:YES];}
    
}
@end
