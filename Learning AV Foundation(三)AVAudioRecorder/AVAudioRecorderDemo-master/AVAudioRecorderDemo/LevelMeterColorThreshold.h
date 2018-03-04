//
//  LevelMeterColorThreshold.h
//  AVAudioRecorderDemo
//
//  Created by sunyazhou on 2017/4/5.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LevelMeterColorThreshold : NSObject

@property (nonatomic, readonly) CGFloat maxValue;
@property (nonatomic, strong, readonly) UIColor *color;
@property (nonatomic, copy, readonly) NSString *name;

+ (instancetype)colorThresholdWithMaxValue:(CGFloat)maxValue color:(UIColor *)color name:(NSString *)name;


@end
