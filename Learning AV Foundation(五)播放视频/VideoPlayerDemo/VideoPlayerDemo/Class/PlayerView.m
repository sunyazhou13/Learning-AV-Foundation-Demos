//
//  PlayerView.m
//  VideoPlayerDemo
//
//  Created by SUNYAZHOU on 2018/3/4.
//  Copyright © 2018年 sunyazhou. All rights reserved.
//

#import "PlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "THOverlayView.h"
@interface PlayerView ()

@property (nonatomic, strong) THOverlayView *overlayView;

@end

@implementation PlayerView
+ (Class)layerClass{
    return [AVPlayerLayer class];
}

- (id)initWithPlayer:(AVPlayer *)player{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [(AVPlayerLayer *)[self layer] setPlayer:player];
        [[NSBundle mainBundle] loadNibNamed:@"THOverlayView" owner:self options:nil];
        [self addSubview:self.overlayView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.overlayView.frame = self.bounds;
}

- (id <TransportProtocol>)transport{
    return self.overlayView;
}

@end
