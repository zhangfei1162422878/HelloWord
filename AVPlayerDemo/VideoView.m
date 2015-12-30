//
//  VideoView.m
//  AVPlayerDemo
//
//  Created by qianfeng on 15/12/26.
//  Copyright © 2015年 张鹏飞. All rights reserved.
//

#import "VideoView.h"
#import <AVFoundation/AVFoundation.h>

@implementation VideoView



//如果想要把 AVPlayer 的内容展示在 view 上，改view 对应得 layer 一定要为 AVPlayer

//想要设置一个 view 对应的 layer 需要重写下面的方法

+(Class)layerClass {
    return [AVPlayerLayer class];
}

//把AVPlayer 和 AVPlayerLayer 关联起来，这样 AVPlayer 提供内容，AVPlayerLayer 负责渲染内容，并展示在view上

-(void)setPlayer:(AVPlayer *)player {

    AVPlayerLayer *layer = (AVPlayerLayer *)self.layer;
    [layer setPlayer:player];

}


@end
