//
//  ProcessImageController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/16.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ProcessImageController.h"
#import <GPUImage.h>
#import "FiltersController.h"

@interface ProcessImageController ()
{
    GPUImageFilterGroup * group;
    GPUImagePicture *staticPicture;
    GPUImageBrightnessFilter *LightImageFilter;
    GPUImageContrastFilter *ContrastFilter;
    GPUImageSaturationFilter*saturationFilter;
}
@property (weak, nonatomic) IBOutlet UISlider *ContSlider;
@property (weak, nonatomic) IBOutlet UISlider *LightSlider;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *saturationSlider;

@end

@implementation ProcessImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *inputImage = [UIImage imageNamed:@"loginpic"];
    staticPicture = [[GPUImagePicture alloc] initWithImage:inputImage ];
    //初始化过滤器
    LightImageFilter = [[GPUImageBrightnessFilter alloc] init];
    ContrastFilter=[[GPUImageContrastFilter alloc]init];
    saturationFilter = [[GPUImageSaturationFilter alloc]init];
 
    //初始化过滤器组
    group = [[GPUImageFilterGroup alloc]init];
    [group addFilter:LightImageFilter];
    [group addFilter:ContrastFilter];
    [group addFilter:saturationFilter];
    [staticPicture addTarget:group];
    //组装过滤器链
    [LightImageFilter addTarget: ContrastFilter];
    [ContrastFilter addTarget:saturationFilter];
    //绑定开始与结尾的过滤器
    [(GPUImageFilterGroup *) group setInitialFilters:[NSArray arrayWithObject: LightImageFilter]];
    [(GPUImageFilterGroup *) group setTerminalFilter:saturationFilter];
}

- (IBAction)two:(UISlider *)sender {
    
    LightImageFilter.brightness = self.LightSlider.value;
    ContrastFilter.contrast = self.ContSlider.value;
    saturationFilter.saturation = self.saturationSlider.value;
    [group useNextFrameForImageCapture];
    [staticPicture processImage];
    self.imageView.image =  [group imageFromCurrentFramebuffer];
}
- (IBAction)otherBtnClick:(UIButton *)sender {
    
    FiltersController * vc = [[FiltersController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.hidesBottomBarWhenPushed = YES;
}

@end
