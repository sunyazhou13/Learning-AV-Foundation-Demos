//
//  LevelPair.h
//  AVAudioRecorderDemo
//
//  Created by sunyazhou on 2017/4/5.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelPair : NSObject
@property (nonatomic, readonly) float level;
@property (nonatomic, readonly) float peakLevel;

+ (instancetype)levelsWithLevel:(float)level peakLevel:(float)peakLevel;

- (instancetype)initWithLevel:(float)level peakLevel:(float)peakLevel;

@end
