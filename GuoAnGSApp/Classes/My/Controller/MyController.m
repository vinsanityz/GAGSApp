//
//  MyController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/9/27.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "MyController.h"

#import "FamilyMembersController.h"
#import "SettingTableViewController.h"
#import <MJRefresh.h>


#import "CommonTableViewCell.h"
#import "HeaderCell.h"
@interface MyController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@end

@implementation MyController
-(BOOL)shouldAutorotate
{
    return  NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.showLeft = NO;
    //设置主TableVIew
    [self.view addSubview:self.tableView];
    //监听颜色与字体的改变
    [self addObserverForFontAndColor];
}

-(void)addObserverForFontAndColor
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(colorPersonChange) name:ColorNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeTextColorActionTwo:) name:FontNoti object:nil];
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
        [self.tableView registerClass:[HeaderCell class] forCellReuseIdentifier:@"cellHeader"];
        [self.tableView registerClass:[CommonTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}


- (void)handleChangeTextColorActionTwo:(NSNotificationCenter *)notification {
    [self.tableView reloadData];
}

-(void)colorPersonChange{
    [self.tableView reloadData];
    self.tableView.separatorColor = [single.colorDic objectForKey:LINECOLOR];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = PersonalCenterTableViewSectionArray[section];
    return arr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [PersonalCenterTableViewSectionArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        HeaderCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:@"cellHeader" forIndexPath:indexPath];
        cellHeader.selectionStyle = UITableViewCellSelectionStyleNone;
//        cellHeader.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (kPermanent_GET_OBJECT(kGetName)== nil) {
            cellHeader.titleLabel.text = @"vinceTest";
        }else{
            cellHeader.titleLabel.text = kPermanent_GET_OBJECT(kGetName);
        }
        cellHeader.titleLabel.textColor = [UIColor blackColor];
        cellHeader.titleLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE] intValue]];
//        NSString *mergeStr =  [NSString stringWithFormat:PreHttpImage,kPermanent_GET_OBJECT(KGetIP),kPermanent_GET_OBJECT(KGetPort),kPermanent_GET_OBJECT(KGetHeadImageUrl)];
//        NSLog(@"mergeStr:%@",mergeStr);
//        [cellHeader.images sd_setImageWithURL:[NSURL URLWithString:mergeStr] placeholderImage:[UIImage imageNamed:MAX_IMAGE]];
        cellHeader.images.backgroundColor = [UIColor redColor];
//        cellHeader.backgroundColor = BACK_CONTROL_BLACK;
        return cellHeader;
    }
    else {
        CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section==1) {
            cell.subtitleLabel.text = @"关联微信账号";
        }else{
            cell.subtitleLabel.text = nil;
        }
        
        cell.backgroundColor = [single.colorDic objectForKey:BACK_CONTROL_COLOR];
        cell.titleLabel.textColor = [single.colorDic objectForKey:FONT_MAIN_COLOR];
        cell.titleLabel.font = [UIFont systemFontOfSize:[[single.fontDic objectForKey:NAORMAL_SIZE]intValue]];
        NSArray * arr = PersonalCenterTableViewSectionArray[indexPath.section];
        cell.titleLabel.text = arr[indexPath.row];
//        cell.titleLabel.text = MY_SectionArraySecond[indexPath.section-1];
//        [cell.image setImage:[UIImage imageNamed:MY_PictureNameSecond[indexPath.row]]];//添加图标
        return cell;
    }
}

#pragma mark - UITableViewDelegate -
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }else {
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    return view;
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
     
        FamilyMembersController * familyVC = [[FamilyMembersController alloc]init];
        familyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:familyVC animated:YES];
    }
    if (indexPath.section==7) {
        SettingTableViewController * settingVC = [[SettingTableViewController alloc]init];
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

@end
