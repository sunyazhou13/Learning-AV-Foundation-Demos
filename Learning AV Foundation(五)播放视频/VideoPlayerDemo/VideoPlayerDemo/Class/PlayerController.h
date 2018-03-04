//
//  PlayerController.h
//  VideoPlayerDemo
//
//  Created by SUNYAZHOU on 2018/3/4.
//  Copyright © 2018年 sunyazhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PlayerController : NSObject
@property (nonatomic, strong, readonly) UIView *view;
- (id)initWithURL:(NSURL *)assetURL;
@end
