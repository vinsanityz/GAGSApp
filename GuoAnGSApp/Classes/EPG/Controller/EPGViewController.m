//
//  EPGViewController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/9/27.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "EPGViewController.h"
#import "EPGRightTableViewCell.h"

@interface EPGViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray * leftViewArray;
@property(nonatomic,strong)UITableView * rightTableView;
@property(nonatomic,copy)NSString * str;
@property(nonatomic,weak)UIButton * selBtn;
@end

@implementation EPGViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftViewArray = @[@"1",@"2",@"3"];
    
    self.titleMessage = @"直播";
    [self setNavRightArr:@[@"屏幕快照 2017-10-17 下午2.15.37",@"屏幕快照 2017-10-17 下午2.15.50"]];
    [self setUpLeftView];
    [self setUpRightView];
    
    
}
-(void)setUpLeftView{
    UIView * leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:leftView];
    leftView.frame = CGRectMake(0, 64, 100, 600);
    
    for (int i = 0;i<self.leftViewArray.count;i++) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.leftViewArray[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setBackgroundColor:[UIColor blueColor]];
        
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        btn.frame = CGRectMake(0, i*100, leftView.frame.size.width, 80);
        [btn addTarget:self action:@selector(leftViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:btn];
    }
}
-(void)setUpRightView{
    UITableView * tableV = [[UITableView alloc]initWithFrame:CGRectMake(110, 64, 250, 500)];
    self.rightTableView = tableV;
    tableV.delegate =self;
    tableV.dataSource = self;
    [self.view addSubview:tableV];
    tableV.rowHeight = 79;
    [self.rightTableView registerNib:[UINib nibWithNibName:@"EPGRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"EPGRightTableViewCell"];
    
    
    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EPGRightTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EPGRightTableViewCell" forIndexPath:indexPath ];
    cell.titleLabel.text = self.str;
    return cell;
}

-(void)leftViewBtnClick:(UIButton *)btn
{
    self.selBtn.selected = !self.selBtn.selected;
    self.str = [btn currentTitle];
    [self.rightTableView reloadData];
    btn.selected = !btn.selected;
    self.selBtn = btn;
    
}
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==5000) {
        
    }
    
}
@end
