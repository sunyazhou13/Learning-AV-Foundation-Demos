//
//  PlayerView.h
//  VideoPlayerDemo
//
//  Created by SUNYAZHOU on 2018/3/4.
//  Copyright © 2018年 sunyazhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransportProtocol.h"
@class AVPlayer;
@interface PlayerView : UIView
@property (nonatomic, readonly) id <TransportProtocol>  transport;
- (id)initWithPlayer:(AVPlayer *)player;
@end
