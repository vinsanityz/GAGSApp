//
//  SettingTableViewController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/10/20.
//  Copyright © 2017年 zcz. All rights reserved.
//
#define DataArray @[@"清除缓存",@"自动跳过片头片尾",@"非WiFi环境播放提醒",@"震动反馈",@"意见反馈",@"使用指南",@"版本更新",@"消息推送",@"关于"]

#import "SettingTableViewController.h"
#import "ParamFile.h"

@interface SettingTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return DataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view =  [[UIView alloc]init];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = DataArray[indexPath.section];
   
    if (indexPath.section==0||indexPath.section==4|| indexPath.section==5||indexPath.section==6||indexPath.section==8) {
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    UISwitch * swi = [[UISwitch alloc]init];
    NSString * keyStr = [NSString stringWithFormat:@"%@%ld",KGetSWitch,indexPath.section];
    if (!kPermanent_GET_BOOL(keyStr)) {
        [swi setOn:YES animated:YES];
    } else {
        [swi setOn:NO animated:YES];
    }
    cell.accessoryView = swi;
    [swi addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventValueChanged];
    swi.tag = indexPath.section;
    return cell;
}

-(void)switchBtnClick:(UISwitch *)swi
{
    NSString * keyStr = [NSString stringWithFormat:@"%@%ld",KGetSWitch,swi.tag];
    switch (swi.tag) {
        case 1:
            NSLog(@"跳过片头片尾");
            break;
        case 2:
            NSLog(@"非wifi环境");
            break;
        case 3:
            NSLog(@"震动反馈");
            break;
        case 7:
            NSLog(@"消息推送");
            break;
            
        default:
            break;
    }
    kPermanent_SET_BOOL(!swi.isOn,keyStr);
}

@end
