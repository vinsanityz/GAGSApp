//
//  ZCZMoviePlayerController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/29.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ZCZMoviePlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZCZProgressBar.h"

@interface ZCZMoviePlayerController ()<ZCZProgressBarDelegate>
@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,strong)ZCZProgressBar * progressBar;
@property(nonatomic,strong)AVPlayerItem *item;
@property(nonatomic,strong)NSTimer * timer;
@end

@implementation ZCZMoviePlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPlayer];
    [self setUpProgressBar];
    [self startPlayer];
}

-(void)setUpPlayer
{
    NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"WeChatSight2.mp4" ofType:nil]];
    self.item = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:self.item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.width/16*9);
    [self.view.layer addSublayer:layer];
}

-(void)setUpProgressBar
{
    ZCZProgressBar * bar = [[[NSBundle mainBundle]loadNibNamed:@"ZCZProgressBar" owner:nil options:nil] lastObject];
    //给progressBar添加点按手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapZczProgressBar:)];
    [bar addGestureRecognizer:tap];
    bar.center = self.view.center;
    bar.delegate = self;
    self.progressBar = bar;
    [self.view addSubview:bar];
}

-(void)startPlayer
{
    [self.player play];
    //添加定时器，使进度条移动
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getPlayerCurrentPlayTime) userInfo:nil repeats:YES];
    
//    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(getPlayerCurrentPlayTime) userInfo:nil repeats:YES];
//    NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
//    [currentRunLoop addTimer:self.timer  forMode:NSDefaultRunLoopMode];
    
    
    //监听AVPlayerItem的状态
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    
   
    
}
-(void)ZCZadjustProgressBarLayoutLast
{
    [self.player play];
      self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getPlayerCurrentPlayTime) userInfo:nil repeats:YES];
    
}

-(void)getPlayerCurrentPlayTime
{
     CGFloat curTime =  CMTimeGetSeconds(self.player.currentTime);
 
    [self.progressBar adjustProgressViewAndProgressBarButton:curTime/CMTimeGetSeconds(self.player.currentItem.duration)*240+66];

    
    
}

#pragma mark - <ProgressBar的点按手势响应方法>
-(void)tapZczProgressBar:(UITapGestureRecognizer *)tap
{
    CGPoint tapPoint = [tap locationInView:self.progressBar];
    [self.progressBar adjustProgressViewAndProgressBarButton:tapPoint.x];
    CGFloat time = self.progressBar.progressView.frame.size.width/240* self.progressBar.movieDurationTime;
    [self.player seekToTime:CMTimeMake(time, 1)];
}

-(void)ZCZadjustProgressBarLayout:(CGFloat)buttonX
{
    [self.progressBar adjustProgressViewAndProgressBarButton:buttonX];
    
    [self.player pause];
    
    
    [self.timer invalidate];
    self.timer = nil;
    
    
    CGFloat time = self.progressBar.progressView.frame.size.width/240* self.progressBar.movieDurationTime;
    [self.player seekToTime:CMTimeMake(time, 1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //    NSLog(@"%@",change[@"new"]);
    switch ([change[@"new"]integerValue]) {
        case 0:{
            NSLog(@"未知状态");
            break;
        }
        case 1:{
            NSLog(@"获得视频总时长  %f",CMTimeGetSeconds(self.player.currentItem.duration));//CMTime在下面会介绍
           self.progressBar.movieDurationTime = CMTimeGetSeconds(self.player.currentItem.duration);
            break;
        }
        case 2:{
            NSLog(@"加载失败");
            break;
        }
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"status"];
    
}

@end
