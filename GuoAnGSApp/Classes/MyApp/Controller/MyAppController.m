//
//  MyAppController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/9/27.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "MyAppController.h"

#import <GPUImage.h>
#import "ProcessImageController.h"

@interface MyAppController ()

@end

@implementation MyAppController
-(BOOL)shouldAutorotate
{
    return  NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController pushViewController:[[ProcessImageController alloc]init] animated:YES];
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
//    UIImageView * v = [[UIImageView alloc]initWithImage:currentFilteredVideoFrame];
    UIImage *inputImage = [UIImage imageNamed:@"loginpic"];
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImageBrightnessFilter *stillImageFilter = [[GPUImageBrightnessFilter alloc] init];
    
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    
    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];
    UIImageView * v = [[UIImageView alloc]initWithImage:currentFilteredVideoFrame];
    
    
//    GPUImageBrightnessFilter
    
    [self.view addSubview:v];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
