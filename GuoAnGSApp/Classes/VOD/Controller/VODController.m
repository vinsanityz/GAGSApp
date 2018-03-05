//
//  VODController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/9/27.
//  Copyright © 2017年 zcz. All rights reserved.
//
#define HeaderArray @[@"精选",@"免费",@"电影",@"电视剧",@"纪录片",@"综艺"]

#import "VODController.h"
#import <SDCycleScrollView.h>           //轮播图
#import "FirstMovieIdModel.h"           //模型
#import "SearchController.h"            //搜索界面
#import "CommonCollectionController.h"  //collectionView

@interface VODController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
//轮播图
@property(nonatomic,strong)SDCycleScrollView * cycleScrollView;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UIScrollView * backScrollView;
//存放头部按钮的数组
@property(nonatomic,strong)NSMutableArray * headerBtnArray;
//上一个选中的按钮
@property(nonatomic,strong)UIButton * previousSelectedBtn;
//按钮下部的线条
@property(nonatomic,weak)UIView * headerLineView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation VODController

-(BOOL)shouldAutorotate
{
    return  NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpHeaderView];
    [self setUpBackGroundScrollVIew];

    [self setTitle:@"movie"];
    [self setNavRightWithStr:@"search"];
//    CommonCollectionController * vc = [[CommonCollectionController alloc]init];
//    [self addChildViewController:vc];
//    vc.view.frame = self.backScrollView.bounds;
//    [self.backScrollView addSubview:vc.view];
    //添加子控制器
    [self AddCommonCollectionController];
    [self scrollViewDidEndScrollingAnimation:_backScrollView];
    [self requestFirstViedoTypeNetWorking];
}

//滚动栏创建
-(void)setUpBackGroundScrollVIew
{
    UIScrollView * bgScroll  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+50,  SCREEN_WIDTH, SCREEN_HEIGHT-64-50-49)];
    [self.view addSubview:bgScroll];
    bgScroll.contentSize = CGSizeMake(SCREEN_WIDTH * HeaderArray.count, 0);
    _backScrollView = bgScroll;
    _backScrollView.delegate = self;
    _backScrollView.pagingEnabled = YES;
}


#pragma mark - <按钮栏相关代码>
//创建按钮栏
-(void)setUpHeaderView
{
    UIView * headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 50)];
    headerV.backgroundColor = [UIColor grayColor];
    NSArray * arr =  HeaderArray;
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 47,[UIScreen mainScreen].bounds.size.width/arr.count , 3)];
    lineView.backgroundColor = [UIColor blackColor];
    [headerV addSubview:lineView];
    self.headerLineView = lineView;
    
    for (int i =0; i<arr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width/arr.count;
        btn.frame = CGRectMake(i*btnWidth,0, btnWidth, 50);
        [headerV addSubview:btn];
        [btn addTarget:self action:@selector(headerViewbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerBtnArray addObject:btn];
    }
    [self.view addSubview:headerV];
}

//按钮栏按钮被点击调用
-(void)headerViewbtnClick:(UIButton *)btn
{
    //找到点击按钮在按钮数组中的位置
    NSUInteger i =  [self.headerBtnArray indexOfObject:btn];
    //根据位置确定scrollView的offset
    [self.backScrollView setContentOffset:CGPointMake(i*self.backScrollView.zcz_width, self.backScrollView.contentOffset.y) animated:YES];
    //更改选中的按钮
    [self exchangeSelectedButton:btn];
}

//更换被选中的按钮
-(void)exchangeSelectedButton:(UIButton * )btn
{
    self.previousSelectedBtn.selected = NO;
    btn.selected = YES;
    self.previousSelectedBtn = btn;
}


#pragma mark - <懒加载>
-(NSMutableArray *)dataSource
{
    if (_dataSource==nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)headerBtnArray
{
    if (_headerBtnArray==nil) {
        _headerBtnArray = [NSMutableArray array];
    }
    return _headerBtnArray;
}

//每个按钮对应一个controller 并使其成为self的子控制器
-(void)AddCommonCollectionController
{
    for (int i =0; i<HeaderArray.count; i++) {
        CommonCollectionController * vc = [[CommonCollectionController alloc]init];
        [self addChildViewController:vc];
    }
}


-(void)btnClick:(UIButton *)btn
{
    SearchController * vc = [[SearchController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.hidesBottomBarWhenPushed =YES;
    
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


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger i = self.backScrollView.contentOffset.x/self.view.zcz_width;
    CommonCollectionController * vc = self.childViewControllers[i];
    if ([vc.view superview]==nil) {
        vc.view.frame = self.backScrollView.bounds;
        [self.backScrollView addSubview:vc.view];
        if (i>0&&i<self.dataSource.count) {
            vc.model = self.dataSource[i];
        }
        
    }
    
    
    
    UIButton * selBtn =self.headerBtnArray[i];
    [self exchangeSelectedButton:selBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.headerLineView.center =CGPointMake( selBtn.center.x,self.headerLineView.center.y);
    }];
    
    
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate==NO) {
            [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}
/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

-(void)requestFirstViedoTypeNetWorking
{
    [self showMBProgressHud];
    [LYNetworkManager GET:GetFirstVideoAction parameters:nil successBlock:^(NSURLSessionDataTask *task, id responseObject){
        if (self.dataSource.count > 0) {
            [self.dataSource removeAllObjects];
        }
        NSArray *listArray = responseObject;
        for (NSDictionary *dict in listArray) {
            FirstMovieIdModel * model = [FirstMovieIdModel mj_objectWithKeyValues:dict];
            [self.dataSource addObject:model];
//            self.model = [firstIdModel firstIdWithtDictionary:dict];
//            [self.dataSource addObject:_model];
        }
        NSLog(@"firstVideoID:%@,%ld",self.dataSource,(unsigned long)self.dataSource.count);

        
        if (self.dataSource.count > 0) {
            [self removeAlertStateView];
                    // 缓存写入文件：

                    if(![NSKeyedArchiver archiveRootObject:self.dataSource toFile:[self returnDocumentPath:FKGetVideoFirst]])
                    {
                        NSLog(@"first id缓存写入失败！");
                    }else{
                        NSLog(@"--%@",self.dataSource);
                        NSLog(@"first id缓存写入成功！");
                    }

        }else{
            [self createAlertStateViewHeight:0 msg:@"暂无数据"];
        }
        
        
        CommonCollectionController * vc = self.childViewControllers[0];
            vc.model = self.dataSource[0];
        
        
        
//        self.cacheArray = [[NSMutableArray alloc]initWithArray:self.dataSource];
//        // 缓存写入文件：
//        self.cachePath = [self returnDocumentPath:FKGetVideoFirst];
//        if(![NSKeyedArchiver archiveRootObject:self.cacheArray toFile:self.cachePath])
//        {
//            NSLog(@"first id缓存写入失败！");
//        }else{
//            NSLog(@"--%@",self.dataSource);
//            NSLog(@"first id缓存写入成功！");
//        }
        [self hideMBProgressHud];
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        //网络连接失败，加载警示框
        if (self.dataSource.count == 0) {
            [self createAlertStateViewHeight:0 msg:error.localizedDescription];
        }
        [self hideMBProgressHud];
    }];
}
@end
