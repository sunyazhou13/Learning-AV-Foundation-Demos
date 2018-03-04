//
//  LevelPair.m
//  AVAudioRecorderDemo
//
//  Created by sunyazhou on 2017/4/5.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "LevelPair.h"

@implementation LevelPair
+ (instancetype)levelsWithLevel:(float)level peakLevel:(float)peakLevel {
    return [[self alloc] initWithLevel:level peakLevel:peakLevel];
}

- (instancetype)initWithLevel:(float)level peakLevel:(float)peakLevel {
    self = [super init];
    if (self) {
        _level = level;
        _peakLevel = peakLevel;
    }
    return self;
}

@end
