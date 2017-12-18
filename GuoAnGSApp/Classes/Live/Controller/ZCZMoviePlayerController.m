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
@interface ZCZMoviePlayerController ()<ZCZProgressBarDelegate>
//AVPlayer
@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,strong)AVPlayerItem *item;
@property(nonatomic,weak)AVPlayerLayer *playerLayer;
//进度条View
@property(nonatomic,strong)ZCZProgressBar * progressBar;
@property(nonatomic,strong)UIView * headerBar;
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
@end

@implementation ZCZMoviePlayerController

//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

-(BOOL)shouldAutorotate
{
    return  YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
    //只支持这一个方向(正常的方向)
}

-(instancetype)initWithURL:(NSString *)url
{
    if (self=[super init]) {
        self.movieURL = url;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerLayerView = [[UIView alloc]init];
    [self.baseView addSubview:self.playerLayerView];
    [self.playerLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView);
        make.top.equalTo(self.baseView).offset(64);
        make.right.equalTo(self.baseView);
        make.height.equalTo(@(SCREEN_WIDTH/16*9));
    }];
    [self.playerLayerView layoutIfNeeded];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory: AVAudioSessionCategoryPlayAndRecord
    withOptions:AVAudioSessionCategoryOptionMixWithOthers
    error:nil];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"back" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self setUpFullScreenGestureView];
    [self setUpPlayer];
    
    //监听屏幕方向改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RotatingScreen) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
}

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
  AppDelegate * appdele =  (AppDelegate*)[UIApplication sharedApplication].delegate;
    [UIApplication sharedApplication].keyWindow.rootViewController = (UIViewController *)appdele.basicViewController;
}

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFullScreenGestureView:)];
    [view addGestureRecognizer:tap];
    _fullScreenGestureView = view;
//    self.fullScreenGestureView.hidden = YES;
    
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

-(UIView *)baseView
{
    if (_baseView==nil) {
        UIView * view= [[UIView alloc]init];
        view.backgroundColor = [UIColor greenColor];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@(SCREEN_HEIGHT));
        }];
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapZczProgressBar:)];
        [bar addGestureRecognizer:tap];
        
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
        
        self.headerBar = [[UIView alloc]init];
        self.headerBar.backgroundColor = [UIColor whiteColor];
        [self.baseView addSubview:self.headerBar];
//        WithFrame:CGRectMake(300, 0, SCREEN_WIDTH-300, SCREEN_HEIGHT)
        [self.headerBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.playerLayerView);
            make.left.equalTo(self.playerLayerView);
            make.right.equalTo(self.playerLayerView);
            make.height.equalTo(@(80));
            
        }];
        self.headerBar.hidden = YES;
        
    }
    return _progressBar;
}


#pragma mark - <ProgressBar的点按手势响应方法>
-(void)tapZczProgressBar:(UITapGestureRecognizer *)tap
{
    [self stopMyTimer];
    CGPoint tapPoint = [tap locationInView:self.progressBar];
    //调整滑块、左侧时间与进度条的UI
//    CGFloat tapValue =0;
    //    if (duration ==UIDeviceOrientationLandscapeLeft||duration ==UIDeviceOrientationLandscapeRight) {
    //        tapValue = tapPoint.y;
    //    }
//    if (self.progressBar.frame.size.height>SCREEN_HEIGHT/2) {
//        tapValue = tapPoint.y;
//    }else{
//        tapValue = tapPoint.x;
//    }
    CGFloat time = [self.progressBar adjustProgressViewAndprogressBarSlider:tapPoint.x];
    //    NSLog(@"%f.........tap--time.",time);
    //    self.newTime = time;
    //    self.player.seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    //进行时间跳转
    [self.player seekToTime:CMTimeMake(time*1000, 1000)toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
    }];
    if (self.player.rate==0) {
        [self startPlayer];
        
    }else{
        [self startMyTimer];
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


//全屏时点击调用
-(void)tapFullScreenGestureView:(UITapGestureRecognizer * )tap
{
    if (self.progressBar.hidden==YES) {
        self.progressBar.hidden =NO;
        self.progressBar.alpha = 0;
        
        self.headerBar.hidden =NO;
        self.headerBar.alpha = 0;
        [UIView animateWithDuration:0.5  animations:^{
            self.progressBar.alpha=1;
            
            self.headerBar.alpha=1;
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
            
            self.headerBar.alpha=0;
        }completion:^(BOOL finished) {
            self.progressBar.alpha=1;
            self.progressBar.hidden = YES;
            
            self.headerBar.alpha=1;
            self.headerBar.hidden = YES;
        }];
    }
}


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
                    self.isVerticalPaning = YES;}
        
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
        
        [self.player seekToTime:CMTimeMake(lastValue*1000, 1000) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        
        
    }
    }
    
    self.previousTranPoint = tranP;
    if (pan.state==UIGestureRecognizerStateEnded) {
        self.previousTranPoint = CGPointMake(0, 0);
        self.isHorizontalPaning = NO;
        self.isVerticalPaning = NO;
        self.beginPoint = CGPointMake(0, 0);
        if (self.player.rate==0) {
            [self.player play];
            [self startMyTimer];
        }
        
            
        
    }
    
    
}


-(void)hiddenTheProgressBarInFullScreenMode
{
    [UIView animateWithDuration:0.5 animations:^{
        self.progressBar.alpha = 0;
        self.headerBar.alpha = 0;
        
    } completion:^(BOOL finished) {
        self.progressBar.hidden = YES;
        self.progressBar.alpha = 1;
        
        self.headerBar.hidden = YES;
        self.headerBar.alpha = 1;
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
-(void)ZCZProgressBarSliderContinuousSliding:(CGFloat)buttonX
{
    if (self.timer!=nil) {
        [self stopMyTimer];
    }
    if (self.player.rate!=0) {
        [self.player pause];
    }
    CGFloat time = [self.progressBar adjustProgressViewAndprogressBarSlider:buttonX];
   
    [self.player seekToTime:CMTimeMake(time*1000, 1000)toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    //     self.progressBar.progressView.frame.size.width/240* self.progressBar.movieDurationTime;if(self.fullScreenGestureView.hidden==NO)
    //在滑动进度条时取消进度条的隐藏倒计时
    if(self.fullScreenGestureView.hidden==NO){
    [self cancelHiddenTheProgressBarInFullScreenMode];
    }
    //time*1000 为了减少滑块的回弹效果

//    self.newTime = time;
}

//当停止拖动滑块调用这个代理方法
-(void)ZCZProgressBarSliderEndSliding
{
//    [self.player seekToTime:CMTimeMake(self.lastScrollTime*1000, 1000)toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
//
//    }];
    [self startPlayer];
    
    if(self.fullScreenGestureView.hidden==NO){
     [self performSelector:@selector(hiddenTheProgressBarInFullScreenMode) withObject:nil afterDelay:5.0];
    }}

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
    //    [self.progressBar adjustProgressViewAndprogressBarSlider:curTime/CMTimeGetSeconds(self.player.currentItem.duration)*240+66];
    [self.progressBar changeProgressViewWidthAndSliderCenterByTimer:curTime];
    
}

#pragma mark - <监听屏幕旋转通知>
-(void)RotatingScreen
{
    
    UIDeviceOrientation duration = [[UIDevice currentDevice] orientation];
    //向左转
    if (duration ==UIDeviceOrientationLandscapeLeft) {
//        self.fullScreenGestureView.hidden = NO;
//        [UIApplication sharedApplication].statusBarHidden = YES;
        self.navigationController.navigationBar.hidden = YES;
//        self.progressBar.hidden = YES;
        
        [self.playerLayerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baseView);
            make.height.equalTo(@(SCREEN_HEIGHT));
             make.left.equalTo(self.baseView);
             make.right.equalTo(self.baseView);
        }];
        [self.fullScreenGestureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baseView);
            make.left.equalTo(self.baseView);
            make.right.equalTo(self.baseView);
            make.height.equalTo(@(SCREEN_HEIGHT));
        }];
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.view layoutIfNeeded];
//            self.playerLayer.transform =CATransform3DConcat(CATransform3DMakeRotation(M_PI/2, 0, 0, 1), self.oriTransform);
            self.playerLayer.frame = self.playerLayerView.bounds;
            
//            self.progressBar.transform = CGAffineTransformMakeRotation(M_PI/2);
//            self.progressBar.frame = CGRectMake(0, 0, 100, SCREEN_HEIGHT);
        }];
//        [UIView animateWithDuration:1.0f animations:^{
//            self.playerLayer.transform = CATransform3DMakeScale(2, 2, 1);}];
//        self.progressBar.hidden = YES;
//        self.navigationController.navigationBar.hidden = YES;
    [self.progressBar setBackgroundViewWidth:500];

//正常方向
    }else if (duration ==UIDeviceOrientationPortrait){

        self.progressBar.hidden = YES;
        self.headerBar.hidden = YES;
        self.navigationController.navigationBar.hidden = NO;
//        self.fullScreenGestureView.hidden = YES;
//        [UIApplication sharedApplication].statusBarHidden = NO;
//        self.progressBar.transform = CGAffineTransformIdentity;
//        self.progressBar.frame = CGRectMake(0, 300, SCREEN_WIDTH, 100);
        [self.progressBar setBackgroundViewWidth:240];
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
//        [self.playerLayer layoutIfNeeded];
//        [self.playerLayerView layoutIfNeeded];
//        [self.baseView layoutIfNeeded];
        self.playerLayer.frame = self.playerLayerView.bounds;
//        [UIView animateWithDuration:0.3f animations:^{
////            self.playerLayer.transform =self.oriTransform;
////            self.playerLayer.frame = CGRectMake(0, 64, SCREEN_WIDTH,SCREEN_WIDTH/16*9 );
//        }completion:^(BOOL finished) {
//
//        }];
    self.progressBar.hidden = NO;
    
//    if ([UIScreen mainScreen].bounds.size.height>[UIScreen mainScreen].bounds.size.width) {
//        self.progressBar.frame = CGRectMake(0, 300, 400, 200);
//    }else {
//        self.progressBar.frame = CGRectMake(0 , 200, 600, 100);
//    }
    [self cancelHiddenTheProgressBarInFullScreenMode];

    }else if (duration ==UIDeviceOrientationLandscapeRight) {
        //      self.playerLayer.transform =  CATransform3DIdentity;
        self.navigationController.navigationBar.hidden = YES;
//        [UIApplication sharedApplication].statusBarHidden = YES;
        [self.progressBar setBackgroundViewWidth:500];
//        self.fullScreenGestureView.hidden = NO;
        [UIView animateWithDuration:1.0f animations:^{
//            self.playerLayer.transform =CATransform3DConcat(CATransform3DMakeRotation(M_PI/180*90, 0, 0, -1), CATransform3DMakeScale(2, 2, 1));
            
//            self.progressBar.transform = CGAffineTransformMakeRotation(-M_PI/2);
            
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
