//
//  FiltersController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/21.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "FiltersController.h"
#import "FilterCollectionViewCell.h"
#import <GPUImage.h>

@interface FiltersController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,weak)UIImageView * imageV;
@end

@implementation FiltersController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self processImage];
    [self setUpImageView];
    [self setUpCollectionView];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)processImage
{
    NSArray * FilterArr = @[@"GPUImageEmbossFilter",@"GPUImageVignetteFilter",@"GPUImagePerlinNoiseFilter",@"GPUImageSketchFilter",@"GPUImageHalftoneFilter"];
    UIImage *inputImage = [UIImage imageNamed:@"loginpic"];
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
//    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];
    for (NSInteger i=0; i<FilterArr.count; i++) {
        Class class =NSClassFromString(FilterArr[i]);
        if ([class isSubclassOfClass:[GPUImageFilter class]]) {
            id stillImageFilter = [[class alloc] init];
            
            [stillImageSource addTarget:stillImageFilter];
            [stillImageFilter useNextFrameForImageCapture];
            [stillImageSource processImage];
            UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];
            [self.dataArr addObject:currentFilteredVideoFrame];
        }
    }
}

-(NSMutableArray *)dataArr
{
    if (_dataArr==nil) {
        _dataArr =  [NSMutableArray array];
    }
    return _dataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //浮雕 GPUImageEmbossFilter
    //边缘淡出 GPUImageVignetteFilter
    //GPUImagePerlinNoiseFilter：生成一个充满Perlin噪声的图像
    //GPUImageSketchFilter：将视频转换为草图。这只是颜色倒置的Sobel边缘检测滤波器
    //GPUImageHalftoneFilter：为图像应用半色调效果，如新闻打印
}

-(void)setUpImageView
{
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100, 275 ,275 )];
    imageV.image = [UIImage imageNamed:@"loginpic"];
    [self.view addSubview:imageV];
    self.imageV = imageV;
    
    
}
-(void)setUpCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 定义大小
    layout.itemSize = CGSizeMake(100, 100);
    // 设置最小行间距
    layout.minimumLineSpacing = 1;
    // 设置垂直间距
    layout.minimumInteritemSpacing = 10;
//     设置滚动方向（默认垂直滚动）
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 500, [UIScreen mainScreen].bounds.size.width, 100)collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blueColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
//    _collectionView.scrollEnabled = NO;
    //    [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FilterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FilterCollectionViewCell"];
//    [ self.collectionView registerClass:[FilterCollectionViewCell class] forCellWithReuseIdentifier:@"FilterCollectionViewCell"];
    [self.view addSubview:_collectionView];
    self.collectionView.bounces = NO;
    // 注册collectionView头部的view，需要注意的是这里的view需要继承自UICollectionReusableView [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"]; // 注册collectionview底部的view,需要注意的是这里的view需要继承自UICollectionReusableView [self.collectionView registerNib:[UINib nibWithNibName:@"WWCollectionFooterReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"]; }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCollectionViewCell" forIndexPath:indexPath];
    
//    UIImage *inputImage = [UIImage imageNamed:@"loginpic"];
//
//    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
//    GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter alloc] init];
//
//    [stillImageSource addTarget:stillImageFilter];
//    [stillImageFilter useNextFrameForImageCapture];
//    [stillImageSource processImage];
//
//    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];
    cell.imageView.image =self.dataArr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.imageV.image = self.dataArr[indexPath.row];
}
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(self.view.bounds.size.width, 40);
//}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:@"header" forIndexPath:indexPath];
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"testBtn" forState:UIControlStateNormal];
//
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//    btn.frame = CGRectMake(0, 0, 200, 20);
//    [view addSubview:btn];
//    view.backgroundColor = [UIColor redColor];
//    return view;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
