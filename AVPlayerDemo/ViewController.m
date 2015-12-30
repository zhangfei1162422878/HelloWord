//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by qianfeng on 15/12/26.
//  Copyright © 2015年 张鹏飞. All rights reserved.
//

#import "ViewController.h"
#import "VideoView.h"
#import <AVFoundation/AVFoundation.h>

#define VIDEOSTREAMURL @"http:live.ipanda.com/xmcd/"
//@"http://flv2.bn.netease.com/videolib3/1510/23/tmKCo4108/SD/tmKCo4108-mobile.mp4"

//@"http://cdn.kxai.cn/res/qms/20131219/mp3/3c/09/3c093d74f1784f099270139aa5ac9986_64.mp3"
//@"http://maichang.kssws.ks-cdn.com/upload20150716161913.mp4"

@interface ViewController () {
    //播放器类（系统给我们提供的），用它来进行播放
//    AVPlayer *_player;

}

//播放器类(系统给我们提供的),用它来进行播放影音文件(包括在线的视频,音频或本地的)
@property (nonatomic, strong) AVPlayer *player;


@property (weak, nonatomic) IBOutlet UISlider *slider;


@property (weak, nonatomic) IBOutlet VideoView *videoView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _slider.minimumValue = 0.0;
    _slider.maximumValue = 1.0;
    _slider.value = 0.0;


}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)player:(id)sender {
    if (_player != nil) {
        [_player play];
        return;
    }
    
//    AVAsset *avAsset = [];
   
    AVURLAsset *netURLAsset = nil;
    
#if 1
     //播放网络资源，AVURLAsset负责来创建一个可播放的资源
     netURLAsset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:VIDEOSTREAMURL] options:nil];
#elif 1
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"mp4"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    netURLAsset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
#endif
    
    
    //这个类是对Asset 的资源内容的描述，它里边包含了影片的长度，播放状态等
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:netURLAsset];
    //一旦使用playerWithPlayerItem来初始化AVPlayer，影片会预加载，然后会直接播放
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    
    [_videoView setPlayer:_player];
    
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        // AVPlayerItemStatusReadyToPlay 播放器准备就绪,可以进行播放
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            [_player play];
            // CMTime  在 AVFoundation 描述的是一个时间 value/timescale = seconds
            // CMTimeMake(1, 1) = 1s
            // CMTimeMake(1, 2) = 0.5s
            //AVPlayer 里边提供一个可以周期性回调的一个 block ,CMTimeMake(1, 1)表示每隔1s 回调这个 block
            
            
            CMTime time = CMTimeMake(1, 1);
            
            __weak typeof(self) weakSelf = self;
            [_player addPeriodicTimeObserverForInterval:time queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                //time 表示当前播放的时间(播放到哪了)
                //计算影片的总长度
                CMTime totalTime = weakSelf.player.currentItem.duration;
                // 转化成秒CMTimeGetSeconds
                float totalSecond = CMTimeGetSeconds(totalTime);
                //当前播放的时间
                float currentSecond = CMTimeGetSeconds(time);
                
                weakSelf.slider.value = (1.0*currentSecond)/totalSecond;
            }];
        }
    }
}




- (IBAction)pause:(id)sender {
    //播放停止
    [_player pause];
    
}

- (IBAction)slider:(UISlider *)sender {

    float progress = _slider.value;
    //影片总长度，如果是直播的话，获取的是零，点播的话就是影片的总长度
    CMTime totalTime = _player.currentItem.duration;
    //拖拽进度
    [_player seekToTime:CMTimeMultiplyByFloat64(totalTime, progress)];

}




@end
