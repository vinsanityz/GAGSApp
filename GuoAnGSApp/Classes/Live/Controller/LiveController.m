//
//  LiveController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/9/27.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "LiveController.h"
#import "EPGRightTableViewCell.h"
#import "ZCZMoviePlayerController.h"
#import "ParamFile.h"

@interface LiveController ()<UITableViewDelegate,UITableViewDataSource>
//@property(nonatomic,strong)NSArray * leftViewArray;
//@property(nonatomic,strong)UITableView * rightTableView;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,copy)NSString * str;
@property(nonatomic,weak)UIButton * selBtn;
@end

@implementation LiveController

-(BOOL)shouldAutorotate
{
    return  NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleMessage = @"直播";
    [self setNavRightArr:@[@"屏幕快照 2017-10-17 下午2.15.37",@"屏幕快照 2017-10-17 下午2.15.50"]];
    [self setupTableView];
}

-(void)setupTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"EPGRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"EPGRightTableViewCell"];
    //设置header
    self.tableView.tableHeaderView =[[[NSBundle mainBundle]loadNibNamed:@"tableViewHeaderView" owner:nil options:nil]lastObject];
}

-(void)headerViewbtnClick:(UIButton *)btn
{
    NSLog(@"clickbtntbtntbtntbtn");
    ZCZMoviePlayerController * vc = [[ZCZMoviePlayerController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//-(void)setUpLeftView{
//    UIView * leftView = [[UIView alloc]init];
//    leftView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:leftView];
//    leftView.frame = CGRectMake(0, 64, 100, 600);
//
//    for (int i = 0;i<self.leftViewArray.count;i++) {
//
//        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:self.leftViewArray[i] forState:UIControlStateNormal];
//        btn.tag = i;
//        [btn setBackgroundColor:[UIColor blueColor]];
//
//        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
//        btn.frame = CGRectMake(0, i*100, leftView.frame.size.width, 80);
//        [btn addTarget:self action:@selector(leftViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [leftView addSubview:btn];
//    }
//}
//-(void)setUpRightView{
//    UITableView * tableV = [[UITableView alloc]initWithFrame:CGRectMake(110, 64, 250, 500)];
//    self.rightTableView = tableV;
//    tableV.delegate =self;
//    tableV.dataSource = self;
//    [self.view addSubview:tableV];
//    tableV.rowHeight = 79;
//    [self.rightTableView registerNib:[UINib nibWithNibName:@"EPGRightTableViewCell" bundle:nil] forCellReuseIdentifier:@"EPGRightTableViewCell"];
//}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  100;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZCZMoviePlayerController * vc = [[ZCZMoviePlayerController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EPGRightTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EPGRightTableViewCell" forIndexPath:indexPath ];
//    cell.LabelView = [ZCZLabel showWithTitle:@"adsfhsjlfhdsjklfhldsflflhahl老实交代划分了的接口放到数据库绿肥红瘦类库的方式肯定放三德科技理发师勒紧裤带发货速度接口方式了接口后来看是点击返回了说地方"];

    cell.titleLabel.text = @"央视频道";
    
//    cell.LabelView.font = [UIFont systemFontOfSize:13    ];
//    cell.LabelView.textColor = [UIColor redColor];
//    cell.LabelView.textAlignment = 0;
//    cell.LabelView.lineBreakMode = NSLineBreakByWordWrapping;
//    cell.LabelView.numberOfLines = 0;
//    cell.LabelView.text = @"12hxccg？jxzh、gc时间。啊好的☺，123123煎、ace熬好多。奥术大师，多啥口，袋巴士，控件的123122hxccg？jxzh、gc时间。啊好的☺，123123煎、ace熬好多。奥术大师，多啥口，袋巴士，控件的123122hxccg？jxzh、gc时间。啊好的☺，123123煎、ace熬好多。奥术大师，多啥口，袋巴士，控件的123122hxccg？jxzh、gc时间。啊好的☺，123123煎、ace熬好多。奥术大师，多啥口，袋巴士，控件的123123";
//
//    NSAttributedString *text = [[NSAttributedString alloc]initWithString:cell.LabelView.text];
//    
//    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//    CGRect rect = [text boundingRectWithSize:CGSizeMake(240, CGFLOAT_MAX) options:options context:nil];
//    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
//    
//    CGSize size = CGSizeMake(240, CGFLOAT_MAX);
//    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:text];
//    layout.textBoundingRect; // get bounding rect
//    layout.textBoundingSize;
//    NSLog(@"size:%@", NSStringFromCGSize(layout.textBoundingSize));
//    cell.LabelView.frame =layout.textBoundingRect;
//    cell.titleLabel.text = self.str;
    return cell;
}
//    NSAttributedString *st =

//    CGSize maxSize = CGSizeMake(74, MAXFLOAT);
//    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:st];
//    cell.LabelView.textLayout = layout;
//    CGFloat introHeight = layout.textBoundingSize.height;
//
//    cell.LabelView.frame = CGRectMake(0, 0, maxSize.width, introHeight);

//    cell.LabelView.width = maxSize.width;
//    cell.LabelView.frame.size. = introHeight + 50;
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"skjhjkxccxvhzljkcxvh"];
//
//    // 2. 为文本设置属性
//    text.yy_font = [UIFont boldSystemFontOfSize:13];
//    text.yy_color = [UIColor blueColor];
//    [text yy_setColor:[UIColor redColor] range:NSMakeRange(0, 4)];
//    text.yy_lineSpacing = 10;
//
//    // 3. 赋值到 YYLabel 或 YYTextView
//
//    //    label.attributedString = text;
//    label.attributedText = text;



//-(void)leftViewBtnClick:(UIButton *)btn
//{
//    self.selBtn.selected = !self.selBtn.selected;
//    self.str = [btn currentTitle];
//    [self.rightTableView reloadData];
//    btn.selected = !btn.selected;
//    self.selBtn = btn;
//    ZCZMoviePlayerController * zcz = [[ZCZMoviePlayerController alloc]init];
////    [UIApplication sharedApplication].keyWindow.rootViewController = zcz;
//
//    zcz.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:zcz animated:YES];
//
//}

@end
