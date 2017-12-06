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
#import "ParamFile.h"
#import <Masonry.h>

@interface ZCZMoviePlayerController ()<ZCZProgressBarDelegate>
//AVPlayer
@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,strong)AVPlayerItem *item;
@property(nonatomic,weak)AVPlayerLayer *playerLayer;
//进度条View
@property(nonatomic,strong)ZCZProgressBar * progressBar;
//定时器
@property(nonatomic,weak)NSTimer * timer;
@property(nonatomic,assign)CGFloat lastScrollTime;
@property(nonatomic,assign)CATransform3D oriTransform;
@property(nonatomic,weak)UIView *fullScreenGestureView;
//基层view
@property(nonatomic,weak)UIView *baseView;
@property(nonatomic,strong)UIView *playerLayerView;
@end

@implementation ZCZMoviePlayerController

- (BOOL)prefersStatusBarHidden {
    return YES;
} 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpFullScreenGestureView];
    [self setUpPlayer];
    
    //监听屏幕方向改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RotatingScreen) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.oriTransform = self.playerLayer.transform;
}
-(void)setUpFullScreenGestureView
{
    UIView * view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor clearColor];
    [self.baseView addSubview:view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFullScreenGestureView:)];
    [view addGestureRecognizer:tap];
    _fullScreenGestureView = view;
    self.fullScreenGestureView.hidden = YES;
}

-(UIView *)baseView
{
    if (_baseView==nil) {
        UIView * view= [[UIView alloc]initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor greenColor];
        [self.view addSubview:view];
        _baseView = view;
    }
    return _baseView;
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
    layer.frame = CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_WIDTH/16*9 );
    self.playerLayer = layer;
    [self.baseView.layer addSublayer:layer];
//    self.playerLayerView = [[UIView alloc]init];
//    [self.baseView addSubview:self.playerLayerView];
//    [self.playerLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(0);
//        make.top.equalTo(self.view).offset(0);
//        make.right.equalTo(self.view).offset(0);
//        make.height.equalTo(@(SCREEN_WIDTH/16*9));
//    }];
    
    //监听AVPlayerItem的状态
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控缓冲加载情况属性
    [self.item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.item addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    //监控播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerIsFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.item];

    //设置视频播放比例为等比例拉伸
    //    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
}

//播放结束来到
-(void)playerIsFinished:(NSNotification *)noti
{
    NSLog(@"%@",noti);
    [self stopMyTimer];
}

-(ZCZProgressBar *)progressBar
{
    if (_progressBar==nil) {
        ZCZProgressBar * bar = [[[NSBundle mainBundle]loadNibNamed:@"ZCZProgressBar" owner:nil options:nil] lastObject];
        //给progressBar添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapZczProgressBar:)];
        [bar addGestureRecognizer:tap];
        
        bar.frame = CGRectMake(0, 300, SCREEN_WIDTH, 100);
        bar.delegate = self;
        [self.baseView addSubview:bar];
        _progressBar = bar;
    }
    return _progressBar;
}


#pragma mark - <ProgressBar的点按手势响应方法>
-(void)tapZczProgressBar:(UITapGestureRecognizer *)tap
{
    CGPoint tapPoint = [tap locationInView:self.progressBar];
    //调整滑块、左侧时间与进度条的UI
    
    UIDeviceOrientation duration = [[UIDevice currentDevice] orientation];
//    CGFloat tapValue =0;
    //    if (duration ==UIDeviceOrientationLandscapeLeft||duration ==UIDeviceOrientationLandscapeRight) {
    //        tapValue = tapPoint.y;
    //    }
//    if (self.progressBar.frame.size.height>SCREEN_HEIGHT/2) {
//        tapValue = tapPoint.y;
//    }else{
//        tapValue = tapPoint.x;
//    }
    
    
    CGFloat time = [self.progressBar adjustProgressViewAndProgressBarButton:tapPoint.x];
    //    NSLog(@"%f.........tap--time.",time);
    //    self.newTime = time;
    //    self.player.seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    //进行时间跳转
    [self.player seekToTime:CMTimeMake(time*1000, 1000)toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
    }];
    if (self.player.rate==0) {
        [self startPlayer];
        
    }
    
}
//
//-(UIView *)fullScreenGestureView
//{
//    if (_fullScreenGestureView==nil) {
//        UIView * view = [[UIView alloc]initWithFrame:self.view.bounds];
//        view.backgroundColor = [UIColor clearColor];
//        [_baseView addSubview:view];
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFullScreenGestureView:)];
//        [view addGestureRecognizer:tap];
//        _fullScreenGestureView = view;
//    }
//    return _fullScreenGestureView;
//}

//新建一个接收全屏时点击事件的View


//全屏时接收点击调用
-(void)tapFullScreenGestureView:(UITapGestureRecognizer * )tap
{
    if (self.progressBar.hidden==YES) {
        self.progressBar.hidden =NO;
        self.progressBar.alpha = 0;
//        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//            self.progressBar.alpha=1;
//        }  completion:^(BOOL finished) {
//            self.progressBar.alpha=1;
//            [UIView animateWithDuration:0.5 delay:5.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//                self.progressBar.alpha = 0;
//            } completion:^(BOOL finished) {
//        self.progressBar.hidden =YES;
//            }];
//        }];
        [UIView animateWithDuration:0.5  animations:^{
            self.progressBar.alpha=1;
        }];
        [self performSelector:@selector(hiddenTheProgressBarInFullScreenMode) withObject:nil afterDelay:5.0];
        
        //延迟
//
//        [NSObject cancelPreviousPerformRequestsWithTarget:self]; //这个是取消当前run loop 里面所有未执行的 延迟方法(Selector Sources)
//
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onClickOverlay:) object:nil];// @selector 和 object 都和 延迟一致 就是 指定取消 未执行的一条或者多条的延迟方法.
//
        
    
    }else if (self.progressBar.hidden==NO){
        [self cancelHiddenTheProgressBarInFullScreenMode];
        [UIView animateWithDuration:0.5  animations:^{
            self.progressBar.alpha=0;
        }completion:^(BOOL finished) {
            self.progressBar.alpha=1;
            self.progressBar.hidden = YES;
        }];
    }
    
}

-(void)hiddenTheProgressBarInFullScreenMode
{
    [UIView animateWithDuration:0.5 animations:^{
        self.progressBar.alpha = 0;
    } completion:^(BOOL finished) {
        self.progressBar.hidden = YES;
        self.progressBar.alpha = 1;
    }];
    
}

-(void)cancelHiddenTheProgressBarInFullScreenMode
{
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenTheProgressBarInFullScreenMode) object:nil];
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
    if (self.player.rate!=0) {
        [self.player pause];
    }
    
    if (self.timer!=nil) {
            [self stopMyTimer];
    }
    
    [self.player seekToTime:CMTimeMake(time*1000, 1000)toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    //     self.progressBar.progressView.frame.size.width/240* self.progressBar.movieDurationTime;
    
    //time*1000 为了减少滑块的回弹效果

//    self.newTime = time;
}

//当停止拖动滑块调用这个代理方法
-(void)ZCZadjustProgressBarLayoutLast
{
//    [self.player seekToTime:CMTimeMake(self.lastScrollTime*1000, 1000)toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
//
//    }];
    [self startPlayer];
}


-(void)resetHiddenProcessBarTime
{
    UIDeviceOrientation duration = [[UIDevice currentDevice] orientation];
    
    if (self.progressBar.frame.size.height>500) {
       
        [self cancelHiddenTheProgressBarInFullScreenMode];
        [self performSelector:@selector(hiddenTheProgressBarInFullScreenMode) withObject:nil afterDelay:5.0];
    }
    
}

#pragma mark - <定时器相关代码>
-(void)startMyTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getPlayerCurrentPlayTime) userInfo:nil repeats:YES];
}

-(void)stopMyTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)getPlayerCurrentPlayTime
{
    CGFloat curTime =  CMTimeGetSeconds(self.player.currentTime);
//    if (curTime<self.newTime) {
//        curTime = self.newTime;
//    }
//    NSLog(@"%f.....。。。。。。curtime",curTime);
    //    [self.progressBar adjustProgressViewAndProgressBarButton:curTime/CMTimeGetSeconds(self.player.currentItem.duration)*240+66];
    [self.progressBar changeProgressViewWidthAndSliderCenterByTimer:curTime];
    
}

#pragma mark - <监听屏幕旋转通知>
-(void)RotatingScreen
{
    
    UIDeviceOrientation duration = [[UIDevice currentDevice] orientation];
    
    if (duration ==UIDeviceOrientationLandscapeLeft) {
        self.fullScreenGestureView.hidden = NO;
//      self.playerLayer.transform =  CATransform3DIdentity;
//        [UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{
//
//        } completion:nil];
//
//
        [UIApplication sharedApplication].statusBarHidden = YES;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.playerLayer.transform =CATransform3DConcat(CATransform3DMakeRotation(M_PI/180*90, 0, 0, 1), self.oriTransform);

//            self.progressBar.transform = CGAffineTransformMakeRotation(M_PI/2);
//
//            self.progressBar.frame = CGRectMake(0, 0, 100, SCREEN_HEIGHT);
//            self.progressBar.hidden = YES;
                    self.navigationController.navigationBar.hidden = YES;
            NSLog(@"%@",NSStringFromCGRect(self.playerLayer.frame) );
            self.playerLayer.frame = self.view.bounds;
            NSLog(@"%@",NSStringFromCGRect(self.playerLayer.frame) );
        }];
        self.progressBar.transform = CGAffineTransformMakeRotation(M_PI/2);
        
        self.progressBar.frame = CGRectMake(0, 0, 100, SCREEN_HEIGHT);
        self.progressBar.hidden = YES;
        
//        [UIView animateWithDuration:1.0f animations:^{
//            self.playerLayer.transform = CATransform3DMakeScale(2, 2, 1);}];
//        self.progressBar.hidden = YES;
//        self.navigationController.navigationBar.hidden = YES;
//
//
    }else if (duration ==UIDeviceOrientationPortrait){
//        self.playerLayer.transform =  CATransform3DIdentity;
        [UIView animateWithDuration:1.0f animations:^{
            self.playerLayer.transform =self.oriTransform;
            self.progressBar.hidden = NO;
            self.playerLayer.frame = CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_WIDTH/16*9 );
            self.navigationController.navigationBar.hidden = NO;
            self.fullScreenGestureView.hidden = YES;
            [UIApplication sharedApplication].statusBarHidden = NO;
            self.progressBar.transform = CGAffineTransformIdentity;
            self.progressBar.frame = CGRectMake(0, 300, SCREEN_WIDTH, 100);
            self.navigationController.navigationBar.hidden = NO;
//            self.progressBar.hidden = YES;
//            self.navigationController.navigationBar.hidden = YES;
//            NSLog(@"%@",NSStringFromCGRect(self.playerLayer.frame) );
//            self.playerLayer.frame = self.view.bounds;
//            NSLog(@"%@",NSStringFromCGRect(self.playerLayer.frame) );
//        }];

        }];
    
    
//    if ([UIScreen mainScreen].bounds.size.height>[UIScreen mainScreen].bounds.size.width) {
//        self.progressBar.frame = CGRectMake(0, 300, 400, 200);
//    }else {
//        self.progressBar.frame = CGRectMake(0 , 200, 600, 100);
//    }
    [self cancelHiddenTheProgressBarInFullScreenMode];

    }else if (duration ==UIDeviceOrientationLandscapeRight) {
        //      self.playerLayer.transform =  CATransform3DIdentity;
        self.navigationController.navigationBar.hidden = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
        
        self.fullScreenGestureView.hidden = NO;
        [UIView animateWithDuration:1.0f animations:^{
            self.playerLayer.transform =CATransform3DConcat(CATransform3DMakeRotation(M_PI/180*90, 0, 0, -1), CATransform3DMakeScale(2, 2, 1));
            
            self.progressBar.transform = CGAffineTransformMakeRotation(-M_PI/2);
            
            self.progressBar.frame = CGRectMake(SCREEN_WIDTH-100, 0, 100, SCREEN_HEIGHT);
            
            self.progressBar.hidden = YES;
            self.navigationController.navigationBar.hidden = YES;
            NSLog(@"%@",NSStringFromCGRect(self.playerLayer.frame) );
            self.playerLayer.frame = self.view.bounds;
            NSLog(@"%@",NSStringFromCGRect(self.playerLayer.frame) );
        }];
        //        [UIView animateWithDuration:1.0f animations:^{
        //            self.playerLayer.transform = CATransform3DMakeScale(2, 2, 1);}];
        //        self.progressBar.hidden = YES;
        //        self.navigationController.navigationBar.hidden = YES;
        //
        //
    }
}

#pragma mark - <kvo监听方法>
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
    switch ([change[@"new"] integerValue])
        {
        case AVPlayerItemStatusUnknown:{
            NSLog(@"未知状态");
            break;
        }
        case AVPlayerItemStatusReadyToPlay:{
            NSLog(@"获得视频总时长  %f",CMTimeGetSeconds(self.player.currentItem.duration));//CMTime在下面会介绍
            self.progressBar.movieDurationTime = CMTimeGetSeconds(self.player.currentItem.duration);
            [self startPlayer];
            break;
        }
        case AVPlayerItemStatusFailed:{
            NSLog(@"加载失败");
            break;
        }
        default:
            break;
                                                }
    }
    else if([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        AVPlayerItem *playerItem = object;
        NSArray *array=playerItem.loadedTimeRanges;
        //本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        CGFloat bufferValue = totalBuffer/CMTimeGetSeconds(self.player.currentItem.duration);
        
        [self.progressBar updateBufferViewWidth:bufferValue];
        NSLog(@"共缓冲：%.2f",totalBuffer);
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
        NSLog(@"缓冲不足暂停了");
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        NSLog(@"缓冲达到可播放程度了");
        //由于 AVPlayer 缓存不足就会自动暂停，所以缓存充足了需要手动播放，才能继续播放
        [_player play];
    }
}

-(void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"status"];
}

@end
