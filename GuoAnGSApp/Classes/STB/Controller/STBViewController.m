//
//  STBViewController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/9/27.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "STBViewController.h"
#import "STBTopView.h"
#import "STBButtonView.h"

#define UIScreenWidth [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight [UIScreen mainScreen].bounds.size.height

@interface STBViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak)UIScrollView * scrolView;
@property(nonatomic,weak)UIView * totalView;
@property(nonatomic,strong)UICollectionView * collectionView;
@end

@implementation STBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self setUpScrollView];
    
    [self setUpTopView];
    [self setUpMiddleView];
    [self setUpButtonView];
    
}

-(void)setUpScrollView
{
    UIScrollView * scrolV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    scrolV.backgroundColor = [UIColor blueColor];
    scrolV.contentSize = CGSizeMake(UIScreenWidth, (UIScreenHeight-64)*2);
    [self.view addSubview:scrolV];
    self.scrolView = scrolV;
    self.scrolView.scrollEnabled = NO;
    [self setUpTotalView];
    [self setUpCollectionView];
    [self setUpPageButton];
}

-(void)setUpPageButton
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"V" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake((UIScreenWidth-40)/2, UIScreenHeight-64-40-46, 40, 40);
    [self.scrolView addSubview:btn];
    [btn addTarget:self action:@selector(zczbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"A" forState:UIControlStateNormal];
    
    [btn1 setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    btn1.frame = CGRectMake((UIScreenWidth-40)/2, UIScreenHeight-64, 40, 40);
    [self.scrolView addSubview:btn1];
    [btn1 addTarget:self action:@selector(zczbtnClick1:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setUpTotalView
{ UIView * Totalview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    Totalview.backgroundColor = [UIColor redColor];
    self.totalView = Totalview;
    [self.scrolView addSubview:Totalview];
    
}

-(void)setUpTopView
{
    UIView * topView =  [STBTopView show];
    [self.totalView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalView.mas_top).offset(0);
        make.left.equalTo(self.totalView.mas_left).offset(8);
        make.right.equalTo(self.totalView.mas_right).offset(-8);
        make.height.equalTo(@130);
    }];
    
}
-(void)setUpMiddleView
{
    UIView * middleView = [[UIView alloc]init];
    middleView.backgroundColor = [UIColor orangeColor];
    [self.totalView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalView.mas_top).offset(135);
        make.left.equalTo(self.totalView.mas_left);
        make.right.equalTo(self.totalView.mas_right);
        make.height.equalTo(@140);
    }];
    
    
}
-(void)setUpButtonView
{
    UIView * ButtonView =  [STBButtonView show];
    [self.totalView addSubview:ButtonView];
    [ButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalView.mas_top).offset(280);
        make.left.equalTo(self.totalView.mas_left);
        make.right.equalTo(self.totalView.mas_right);
        make.height.equalTo(@150);
    }];
    
}

-(void)zczbtnClick:(UIButton *)btn
{
    NSLog(@"%@",NSStringFromCGPoint(self.scrolView.contentOffset));
    [self.scrolView setContentOffset:CGPointMake(0, UIScreenHeight-64) animated:YES];
    
}
-(void)zczbtnClick1:(UIButton *)btn
{
     [self.scrolView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)setUpCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 定义大小
    layout.itemSize = CGSizeMake(110    , 110);
    // 设置最小行间距
    layout.minimumLineSpacing = 1;
    
    // 设置垂直间距
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    layout.minimumInteritemSpacing = 10;
    // 设置滚动方向（默认垂直滚动）
    //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, UIScreenHeight-64, UIScreenWidth, UIScreenHeight-64-46  ) collectionViewLayout:layout]; _collectionView.backgroundColor = [UIColor blueColor];
    _collectionView.dataSource = self; _collectionView.delegate = self;
    
    //    [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [ self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.scrolView addSubview:_collectionView];// 注册collectionView头部的view，需要注意的是这里的view需要继承自UICollectionReusableView [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"]; // 注册collectionview底部的view,需要注意的是这里的view需要继承自UICollectionReusableView [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionFooterReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"]; }
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath { UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath]; cell.backgroundColor = [UIColor yellowColor];
    
    return cell; }


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.bounds.size.width, 40); }
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"testBtn" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 200, 20);
    [view addSubview:btn];
    view.backgroundColor = [UIColor redColor];
    
    return view;}


@end
