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
@property(nonatomic,strong)AVPlayerItem *item;
//进度条
@property(nonatomic,strong)ZCZProgressBar * progressBar;
//定时器
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)CGFloat newTime;
@property(nonatomic,assign)CGFloat preTime;
@end

@implementation ZCZMoviePlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpPlayer];
    [self setUpProgressBar];
    [self startPlayer];
}

-(void)startPlayer
{
    [self.player play];
    //添加定时器，使进度条移动
    [self startMyTimer];
    
}

-(void)setUpPlayer
{
    NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"WeChatSight2.mp4" ofType:nil]];
    self.item = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:self.item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.width/16*9);
    [self.view.layer addSublayer:layer];
    //监听AVPlayerItem的状态
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
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









#pragma mark - <ProgressBar的点按手势响应方法>
-(void)tapZczProgressBar:(UITapGestureRecognizer *)tap
{
    
    
    
    CGPoint tapPoint = [tap locationInView:self.progressBar];
    CGFloat time = [self.progressBar adjustProgressViewAndProgressBarButton:tapPoint.x];
    NSLog(@"%f.........tap--time.",time);
    
    self.newTime = time;
    
    [self.player seekToTime:CMTimeMake(time, 1)toleranceBefore:CMTimeMake(1, 30) toleranceAfter:CMTimeMake(1, 30) ];
    
}




#pragma mark - <ZCZProgressBarDelegate>
//点击播放暂停按钮来到此代理方法
- (void)ZCZProgressBarPlayOrPauseBtnClick:(UIButton *)btn
{
    if (self.player.rate==0) {
        [self.player play];
        [btn setTitle:@"pause" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self startMyTimer];
    }else{
        [self.player pause];
        [btn setTitle:@"play" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self stopMyTimer];
    }
}

//当拖动滑块持续调用这个代理方法
-(void)ZCZadjustProgressBarLayout:(CGFloat)buttonX
{
    CGFloat time = [self.progressBar adjustProgressViewAndProgressBarButton:buttonX];
    
    [self.player pause];
    
    [self.timer invalidate];
    self.timer = nil;
    
    //     self.progressBar.progressView.frame.size.width/240* self.progressBar.movieDurationTime;
    [self.player seekToTime:CMTimeMake(time, 1)toleranceBefore:CMTimeMake(1, 30) toleranceAfter:CMTimeMake(1, 30) ];
    self.newTime = time;
}

//当拖动滑块持续调用这个代理方法
-(void)ZCZadjustProgressBarLayoutLast
{
    [self startMyTimer];
    [self.player play];
}



#pragma mark - <定时器相关代码>
-(void)startMyTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getPlayerCurrentPlayTime) userInfo:nil repeats:YES];
}

-(void)stopMyTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)getPlayerCurrentPlayTime
{
    CGFloat curTime =  CMTimeGetSeconds(self.player.currentTime);
    if (curTime<self.newTime) {
        return;
    }
    
    NSLog(@"%f.....。。。。。。curtime",curTime);
    //    [self.progressBar adjustProgressViewAndProgressBarButton:curTime/CMTimeGetSeconds(self.player.currentItem.duration)*240+66];
    [self.progressBar changeProgressViewWidthAndSliderCenterByTimer:curTime];
    
}
#pragma mark - <kvo监听方法>
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
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

-(void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"status"];
}

@end
