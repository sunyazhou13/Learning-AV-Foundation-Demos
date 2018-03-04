//
//  LevelMeterView.h
//  AVAudioRecorderDemo
//
//  Created by sunyazhou on 2017/4/5.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelMeterView : UIView

@property (nonatomic, assign) CGFloat level;
@property (nonatomic, assign) CGFloat peakLevel;

- (void)resetLevelMeter;


@end
