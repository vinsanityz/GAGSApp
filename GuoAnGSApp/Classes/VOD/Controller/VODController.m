//
//  VODController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/9/27.
//  Copyright © 2017年 zcz. All rights reserved.
//
#define HeaderArray @[@"精选",@"免费",@"电影",@"电视剧",@"纪录片",@"综艺",@"动漫"]

#import "VODController.h"
#import "SDCycleScrollView.h"

#import "SearchController.h"

@interface VODController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)SDCycleScrollView * cycleScrollView;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UIScrollView * backScrollView;
@end

@implementation VODController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpHeaderView];
    [self setUpBackGroundScrollVIew];

    [self setTitle:@"movie"];
    [self setNavRightWithStr:@"search"];
    
 
}
-(void)btnClick:(UIButton *)btn
{
    SearchController * vc = [[SearchController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.hidesBottomBarWhenPushed =YES;
    
}

-(void)setUpBackGroundScrollVIew
{
    UIScrollView * bgScroll  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+50,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-114-46)];
    [self.view addSubview:bgScroll];
    bgScroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1200);
    _backScrollView = bgScroll;
    [self setUpCycleScrollView];
    [self setUpCollectionView];
    
}

-(void)setUpHeaderView
{
    UIView * headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 50)];
    headerV.backgroundColor = [UIColor grayColor];
    NSArray * arr =  HeaderArray;
    for (int i =0; i<arr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width/arr.count,0, [UIScreen mainScreen].bounds.size.width/arr.count, 50);
        [headerV addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:headerV];
}

-(void)setUpCycleScrollView
{
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240) delegate:self placeholderImage:[UIImage imageNamed:@"loginpic"]];
    _cycleScrollView.delegate = self;
  
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.currentPageDotColor = [UIColor orangeColor];
    _cycleScrollView.pageDotColor = [UIColor whiteColor];
    _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    [self.backScrollView addSubview:self.cycleScrollView];
    self.cycleScrollView.autoScrollTimeInterval = 1.0;
    //注：标题数组元素个数必须和图片数组元素个数标识一致
    NSURL * url1 = @"123";
    self.cycleScrollView.imageURLStringsGroup = @[url1,url1,url1];
    self.cycleScrollView.titlesGroup = @[@"1",@"2",@"3"];
}

-(void)setUpCollectionView
{
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
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*2)collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blueColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = NO;
//    [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
   [ self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.backScrollView addSubview:_collectionView];// 注册collectionView头部的view，需要注意的是这里的view需要继承自UICollectionReusableView [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"]; // 注册collectionview底部的view,需要注意的是这里的view需要继承自UICollectionReusableView [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionFooterReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"]; }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width, 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"testBtn" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 200, 20);
    [view addSubview:btn];
    view.backgroundColor = [UIColor redColor];
    return view;
}
   
//点击图片回调
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index


    
    
@end
