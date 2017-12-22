//
//  ZCZMoviePlayerController.m
//  GuoAnGSApp
//
//  Created by zhaochengzhu on 2017/11/29.
//  Copyright © 2017年 zcz. All rights reserved.
//

#import "ZCZMoviePlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZCZProgressBar.h"
#import "ParamFile.h"
#import <Masonry.h>
#import "AppDelegate.h"
#import "ZCZHeaderBar.h"
@interface ZCZMoviePlayerController ()<ZCZProgressBarDelegate,ZCZHeaderBarDelegate>
//AVPlayer
@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,strong)AVPlayerItem *item;
@property(nonatomic,weak)AVPlayerLayer *playerLayer;
//进度条View
@property(nonatomic,strong)ZCZProgressBar * progressBar;
@property(nonatomic,strong)ZCZHeaderBar * headerBar;
//定时器
@property(nonatomic,weak)NSTimer * timer;
@property(nonatomic,assign)CGFloat lastScrollTime;
@property(nonatomic,assign)CATransform3D oriTransform;
@property(nonatomic,weak)UIView *fullScreenGestureView;
//基层view
@property(nonatomic,weak)UIView *baseView;
@property(nonatomic,strong)UIView *playerLayerView;
@property(nonatomic,strong)UISlider * volumeSlider;
//@property(nonatomic,strong)MPVolumeView * myVolumeView;
@property(nonatomic,assign)CGPoint previousTranPoint;
@property(nonatomic,assign)CGPoint beginPoint;;
@property(nonatomic,assign)BOOL isVerticalPaning;
@property(nonatomic,assign)BOOL isHorizontalPaning;
@property(nonatomic,strong)NSString * movieURL;
@property(nonatomic,strong)UILabel * timeLabel;
//@property(nonatomic,strong)UITapGestureRecognizer * progressBarTap;
@end

@implementation ZCZMoviePlayerController

-(BOOL)shouldAutorotate
{
    return  YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(instancetype)initWithURL:(NSString *)url
{
    if (self=[super init]) {
        self.movieURL = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   //设置音频为扬声器模式，并且能与其他音源混合
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory: AVAudioSessionCategoryPlayback
    withOptions:AVAudioSessionCategoryOptionMixWithOthers
    error:nil];
    //返回按钮
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"back" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self setUpPlayerLayerView];
    [self setUpFullScreenGestureView];
    [self setUpPlayer];
    
    //监听屏幕方向改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RotatingScreen) name:UIDeviceOrientationDidChangeNotification object:nil];
}

//放置AVPlayerLayer
-(void)setUpPlayerLayerView
{
    self.playerLayerView = [[UIView alloc]init];
    [self.baseView addSubview:self.playerLayerView];
    [self.playerLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView);
        make.top.equalTo(self.baseView).offset(64);
        make.right.equalTo(self.baseView);
        make.height.equalTo(@(SCREEN_WIDTH/16*9));
    }];
    [self.view layoutIfNeeded];
    UILabel * timeLabel =   [[UILabel alloc]init];
    self.timeLabel = timeLabel;
    [self.baseView addSubview:timeLabel];
//    timeLabel.backgroundColor = [UIColor redColor];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.playerLayerView);
        make.centerY.equalTo(self.playerLayerView);
        make.height.equalTo(@(100));
        make.width.equalTo(@(300));
    }];
    self.timeLabel.hidden = YES;
    [self.timeLabel setFont:[UIFont systemFontOfSize:50]];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.timeLabel setTextColor:[UIColor whiteColor]];
}

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
//  AppDelegate * appdele =  (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [UIApplication sharedApplication].keyWindow.rootViewController = (UIViewController *)appdele.basicViewController;
}
//调节亮度声音与进度的手势的View，目前小屏全屏都适用。
-(void)setUpFullScreenGestureView
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.baseView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView).offset(64);
        make.left.equalTo(self.baseView);
        make.right.equalTo(self.baseView);
        make.height.equalTo(@(SCREEN_WIDTH/16*9));
    }];
    _fullScreenGestureView = view;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFullScreenGestureView:)];
    [view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panFullScreenGestureView:)];
    [pan setMaximumNumberOfTouches:1];
    [view addGestureRecognizer:pan];
   
    
    
    MPVolumeView * volumeView = [[MPVolumeView alloc]initWithFrame:CGRectMake(100, 100, 300, 300)];
    volumeView.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    volumeView.showsRouteButton = NO;
    //默认YES，这里为了突出，故意设置一遍
    volumeView.showsVolumeSlider = NO;

//    [self.myVolumeView sizeToFit];
//    [self.myVolumeView setFrame:CGRectMake(-1000, -1000, 10, 10)];

    [self.fullScreenGestureView addSubview:volumeView];
    [volumeView userActivity];

    for (UIView *view in [volumeView subviews]){
        if ([[view.class description] isEqualToString:@"MPVolumeSlider"]){
            _volumeSlider = (UISlider*)view;
            break;
        }
    }
}

//baseView上面有多个View，由底层到顶层依次为，playerLayerView->fullScreenGestureView->procressBar and headerBar
-(UIView *)baseView
{
    if (_baseView==nil) {
        UIView * baseView= [[UIView alloc]init];
        baseView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:baseView];
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@(SCREEN_HEIGHT));
        }];
        _baseView = baseView;
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
    NSURL * url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"123123.mp4" ofType:nil]];
    self.item = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:self.item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    //layer不能添加约束，所以只能用frame形式
//    layer.frame = CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_WIDTH/16*9 );
//    self.playerLayer = layer;
//    self.oriTransform = self.playerLayer.transform;
//    [self.baseView.layer addSublayer:layer];
    
    //layer不能添加约束，所以只能用frame形式
    NSLog(@"%@",NSStringFromCGRect(self.playerLayerView.bounds));
    
    layer.frame = self.playerLayerView.bounds;
    self.playerLayer = layer;
//    self.oriTransform = self.playerLayer.transform;
    [self.playerLayerView.layer addSublayer:layer];
    
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
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapZczProgressBar:)];
//        [bar addGestureRecognizer:tap];
//        self.progressBarTap = tap;
//        bar.frame = CGRectMake(0, 300, SCREEN_WIDTH, 100);
        bar.delegate = self;
        [self.baseView addSubview:bar];
        [bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.playerLayerView);
            make.left.equalTo(self.playerLayerView);
            make.right.equalTo(self.playerLayerView);
            make.height.equalTo(@100);
        }];
        _progressBar = bar;
        
        //progressbar顶部的View
        self.headerBar = [[[NSBundle mainBundle]loadNibNamed:@"ZCZHeaderBar" owner:nil options:nil] lastObject];
        self.headerBar.delegate = self;
   
        
        [self.baseView addSubview:self.headerBar];
//        WithFrame:CGRectMake(300, 0, SCREEN_WIDTH-300, SCREEN_HEIGHT)
        [self.headerBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playerLayerView);
            make.left.equalTo(self.playerLayerView);
            make.right.equalTo(self.playerLayerView);
            make.height.equalTo(@(40));
            
        }];
        self.headerBar.hidden = YES;
    }
    return _progressBar;
}




//-(void)tapZczProgressBar:(UITapGestureRecognizer *)tap
//{
//    [self stopMyTimer];
//    CGPoint tapPoint = [tap locationInView:self.progressBar];
//    //调整滑块、左侧时间与进度条的UI
////    CGFloat tapValue =0;
//    //    if (duration ==UIDeviceOrientationLandscapeLeft||duration ==UIDeviceOrientationLandscapeRight) {
//    //        tapValue = tapPoint.y;
//    //    }
////    if (self.progressBar.frame.size.height>SCREEN_HEIGHT/2) {
////        tapValue = tapPoint.y;
////    }else{
////        tapValue = tapPoint.x;
////    }
//    CGFloat time = [self.progressBar adjustProgressViewAndprogressBarSlider:tapPoint.x];
//    //    NSLog(@"%f.........tap--time.",time);
//    //    self.newTime = time;
//    //    self.player.seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
//    //进行时间跳转
//    [self.player seekToTime:CMTimeMake(time*1000, 1000)toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
//    }];
//    if (self.player.rate==0) {
//        [self startPlayer];
//
//    }else{
//        [self startMyTimer];
//    }
//
//}

#pragma mark - <FullScreenGestureView的手势>
//FullScreenGestureView的点按手势
-(void)tapFullScreenGestureView:(UITapGestureRecognizer * )tap
{
    if (self.progressBar.hidden==YES) {
        //显示progressBar与headerBar的动画
        self.progressBar.hidden =NO;
        self.progressBar.alpha = 0;
        if (SCREEN_WIDTH>SCREEN_HEIGHT)
        {
            self.headerBar.hidden =NO;
            self.headerBar.alpha = 0;
        }
       
        [UIView animateWithDuration:0.5  animations:^{
            self.progressBar.alpha=1;
            if (SCREEN_WIDTH>SCREEN_HEIGHT) {
                self.headerBar.alpha=1;
            }
        }];
        [self performSelector:@selector(hiddenTheProgressBarInFullScreenMode) withObject:nil afterDelay:5.0];
//延迟
//[NSObject cancelPreviousPerformRequestsWithTarget:self];
//这个是取消当前run loop 里面所有未执行的 延迟方法(Selector Sources)
//[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(onClickOverlay:) object:nil];
// @selector 和 object 都和 延迟一致 就是 指定取消 未执行的一条或者多条的延迟方法.
    }else if (self.progressBar.hidden==NO){
        [self cancelHiddenTheProgressBarInFullScreenMode];
        [UIView animateWithDuration:0.5  animations:^{
            self.progressBar.alpha=0;
            if (SCREEN_WIDTH>SCREEN_HEIGHT){
                self.headerBar.alpha=0;
            }
        }completion:^(BOOL finished) {
            self.progressBar.alpha=1;
            self.progressBar.hidden = YES;
            if (SCREEN_WIDTH>SCREEN_HEIGHT){
            self.headerBar.alpha=1;
            self.headerBar.hidden = YES;
            }
        }];
    }
}
//FullScreenGestureView的拖拽手势
-(void)panFullScreenGestureView:(UIPanGestureRecognizer * )pan
{
    
    if (pan.state==UIGestureRecognizerStateBegan) {
        self.previousTranPoint = CGPointZero;
         self.beginPoint = [pan locationInView:self.fullScreenGestureView];
    NSLog(@"beginPoint%@",NSStringFromCGPoint(self.beginPoint));
    }
    
//    CGFloat curVal = self.volumeSlider.value;
    CGPoint panPoint = [pan locationInView:self.fullScreenGestureView];
    
    NSLog(@"panX--%f+++++++panY--%f",panPoint.x,panPoint.y);
    
   CGPoint tranP = [pan translationInView:self.fullScreenGestureView];
    NSLog(@"tranX--%f+++++++tranY--%f",tranP.x,tranP.y);
    
    
    if (pan.state==UIGestureRecognizerStateChanged) {
    //垂直移动
    if (fabs(tranP.y)>fabs(3*tranP.x)&&self.isHorizontalPaning==NO) {
        if(fabs(tranP.y)>30){
                    self.isVerticalPaning = YES;
            
        }
        
        if (self.beginPoint.x>SCREEN_WIDTH/2) {
            //右侧上下移动
//            if (tranP.x>0) {
                //向上移动
            if (fabs(tranP.y-self.previousTranPoint.y)<25) {
                return;
            }
            
                CGFloat val = self.volumeSlider.value + (self.previousTranPoint.y-tranP.y)/500;
                
                [self.volumeSlider setValue:val];
                
                //设置默认打开视频时声音为0.3，如果不设置的话，获取的当前声音始终是0
//                [_volumeSlider setValue:0.2];
//
//                //获取最是刚打开时的音量值
//                _volumeValue = _volumeSlider.value;
//
//                //设置展示音量条的值
//                _showVolueSlider.value = _volumeValue;
                
  
//            }else{
//                //向下移动
//
//            }
        }else if(self.beginPoint.x<SCREEN_HEIGHT/2){
            
            CGFloat value =  [UIScreen mainScreen].brightness;
            
             CGFloat lastValue = value + (self.previousTranPoint.y-tranP.y)/500;
            [[UIScreen mainScreen]setBrightness:lastValue];
            
            self.timeLabel.text = [NSString stringWithFormat:@"亮度：%02.0f",lastValue*100];
            self.timeLabel.hidden = NO;
            if (lastValue>1) {
                self.timeLabel.text = @"亮度：100";
            }
            if (lastValue<0) {
                self.timeLabel.text = @"亮度：0";
            }
            //左侧上下移动
        }
    }
        //水平移动
    else if(fabs(tranP.x)>fabs(3*tranP.y)&&self.isVerticalPaning==NO)
    {//防止误操作，判断之前保证一定的移动距离
        if (fabs(tranP.x)>30) {
        self.isHorizontalPaning=YES;
        }
        
        [self stopMyTimer];
        [self.player pause];
        //水平移动
        CGFloat value = CMTimeGetSeconds(self.player.currentTime);
        
        CGFloat lastValue = value + (tranP.x-self.previousTranPoint.x)/10;
        
        self.timeLabel.text = [self adjustTimeFormat:value];
        self.timeLabel.hidden = NO;
        [self.player seekToTime:CMTimeMake(lastValue*1000, 1000) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
    }
    
    self.previousTranPoint = tranP;
    if (pan.state==UIGestureRecognizerStateEnded) {
        self.previousTranPoint = CGPointMake(0, 0);
        self.isHorizontalPaning = NO;
        self.isVerticalPaning = NO;
        self.timeLabel.hidden = YES;
        
        self.beginPoint = CGPointMake(0, 0);
        if (self.player.rate==0) {
            [self.player play];
            [self startMyTimer];
        }
    }
}


#pragma mark - <把时间从CGFloat格式转换成00：00：00格式>
-(NSString *)adjustTimeFormat:(CGFloat)timeValue
{
    NSInteger hour =timeValue/3600;
    NSInteger minute = (timeValue-3600*hour)/60;
    NSInteger second = timeValue-3600*hour-60*minute;
    NSString * timeStr  = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour,minute,second];
    return timeStr;
}
//隐藏progressBar与headerBar的动画
-(void)hiddenTheProgressBarInFullScreenMode
{
    [UIView animateWithDuration:0.5 animations:^{
        self.progressBar.alpha = 0;
        if (SCREEN_WIDTH>SCREEN_HEIGHT)
        {
        self.headerBar.alpha = 0;
        }
    } completion:^(BOOL finished) {
        self.progressBar.hidden = YES;
        self.progressBar.alpha = 1;
        if (SCREEN_WIDTH>SCREEN_HEIGHT)
        {
        self.headerBar.hidden = YES;
        self.headerBar.alpha = 1;
        }
    }];
}

//取消progressBar与headerBar的隐藏
-(void)cancelHiddenTheProgressBarInFullScreenMode
{
    //取消hiddenTheProgressBarInFullScreenMode方法的延时执行
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
-(void)ZCZProgressBarSliderContinuousSliding:(CGFloat)buttonX
{
    if (self.timer!=nil) {
        [self stopMyTimer];
    }
    if (self.player.rate!=0) {
        [self.player pause];
    }
   CGFloat time = [self.progressBar adjustProgressViewAndprogressBarSlider:buttonX];
    //为了边滑动边变换图像
    [self.player seekToTime:CMTimeMake(time*1000, 1000)toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    //在滑动进度条时取消进度条的隐藏倒计时,应该在slider的开始滑动方法对应的代理方法中实现，先放在这。
         [self cancelHiddenTheProgressBarInFullScreenMode];
}

//当停止拖动滑块调用这个代理方法
-(void)ZCZProgressBarSliderEndSliding:(CGFloat)pointX
{
    CGFloat time = [self.progressBar adjustProgressViewAndprogressBarSlider:pointX];

      [self.player seekToTime:CMTimeMake(time, 1)toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self startPlayer];
   
    [self performSelector:@selector(hiddenTheProgressBarInFullScreenMode) withObject:nil afterDelay:5.0];
}

//ProgressBar的点按手势响应方法
-(void)ZCZProgressBarTriggerTapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    if (self.timer!=nil)
    {
        [self stopMyTimer];
    }
    CGPoint tapPoint = [tap locationInView:self.progressBar];
    
    //返回tap所对应的播放时间
    CGFloat time = [self.progressBar adjustProgressViewAndprogressBarSlider:tapPoint.x];
    
    //进行AVPlayer的时间跳转
    [self.player seekToTime:CMTimeMake(time*1000, 1000)toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if (self.player.rate==0)
        {
            [self.player play];
        }
        [self startMyTimer];
    }
}

//重置隐藏进度条的时间
-(void)resetProcessBarHiddenTime
{
    //取消HiddenTheProgressBarInFullScreenMode的延迟执行
        [self cancelHiddenTheProgressBarInFullScreenMode];
    //开始HiddenTheProgressBarInFullScreenMode的延迟执行
    [self performSelector:@selector(hiddenTheProgressBarInFullScreenMode) withObject:nil afterDelay:5.0];
}

#pragma mark - <定时器相关代码>
-(void)startMyTimer
{
    if (self.timer==nil)
    {
           self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getPlayerCurrentPlayTime) userInfo:nil repeats:YES];
    }
}

-(void)stopMyTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)getPlayerCurrentPlayTime
{
    CGFloat curTime =  CMTimeGetSeconds(self.player.currentTime);
    [self.progressBar changeProgressViewWidthAndSliderCenterByTimer:curTime];
}


#pragma mark - <监听屏幕旋转通知>
-(void)RotatingScreen
{
    UIDeviceOrientation duration = [[UIDevice currentDevice] orientation];
    //向左转
    if (duration ==UIDeviceOrientationLandscapeLeft||duration ==UIDeviceOrientationLandscapeRight)
    {
        self.navigationController.navigationBar.hidden = YES;
        self.headerBar.hidden = NO;
        self.progressBar.hidden = NO;
        self.headerBar.alpha = 1;
        self.progressBar.alpha = 1;
        
        [self cancelHiddenTheProgressBarInFullScreenMode];
         [self performSelector:@selector(hiddenTheProgressBarInFullScreenMode) withObject:nil afterDelay:5.0];
        
        //更新约束
        [self.playerLayerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baseView);
            make.height.equalTo(@(SCREEN_HEIGHT));
        }];
        [self.fullScreenGestureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baseView);
            make.height.equalTo(@(SCREEN_HEIGHT));
        }];
        //得到更新约束后的frame
            [self.view layoutIfNeeded];
            self.playerLayer.frame = self.playerLayerView.bounds;
        [self.progressBar useBackgroundViewWidthFixOtherViewFrame];
//正常方向
    }else if (duration ==UIDeviceOrientationPortrait)
    {
        self.progressBar.hidden = NO;
        self.progressBar.alpha =1;
        self.headerBar.hidden = YES;
        self.navigationController.navigationBar.hidden = NO;
        [self cancelHiddenTheProgressBarInFullScreenMode];
        [self performSelector:@selector(hiddenTheProgressBarInFullScreenMode) withObject:nil afterDelay:5.0];
        
//        self.fullScreenGestureView.hidden = YES;
//        [UIApplication sharedApplication].statusBarHidden = NO;
//        self.progressBar.transform = CGAffineTransformIdentity;
//        self.progressBar.frame = CGRectMake(0, 300, SCREEN_WIDTH, 100);
//        [self.progressBar setBackgroundViewWidth:240];
       //更新约束
        [self.playerLayerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.baseView).offset(0);
            make.top.equalTo(self.baseView).offset(64);
            make.right.equalTo(self.baseView).offset(0);
            make.height.equalTo(@(SCREEN_WIDTH/16*9));
        }];
        [self.fullScreenGestureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.baseView).offset(0);
            make.top.equalTo(self.baseView).offset(64);
            make.right.equalTo(self.baseView).offset(0);
            make.height.equalTo(@(SCREEN_WIDTH/16*9));
        }];
        [self.view layoutIfNeeded];
        self.playerLayer.frame = self.playerLayerView.bounds;
 [self.progressBar useBackgroundViewWidthFixOtherViewFrame];
//    [self cancelHiddenTheProgressBarInFullScreenMode];
    }
}


#pragma mark - <ZCZHeaderBarDelegate>
//返回按钮的点击
-(void)ZCZHeaderBarBackButtonClick:(UIButton *)btn
{
    //切换成正常方向
    NSNumber * value = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
    [[UIDevice currentDevice]setValue:value forKey:@"orientation"];
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
            [self performSelector:@selector(hiddenTheProgressBarInFullScreenMode) withObject:nil afterDelay:5.0];
            
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopMyTimer];
}

-(void)dealloc
{
    NSLog(@"dealloc11111111");
    self.navigationController.navigationBar.hidden = NO;
    [self.item removeObserver:self forKeyPath:@"status"];
    [self.item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.item removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end
