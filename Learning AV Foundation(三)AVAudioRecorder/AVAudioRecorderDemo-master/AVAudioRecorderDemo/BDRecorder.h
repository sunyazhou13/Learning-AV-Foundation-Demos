//
//  BDRecorder.h
//  AVAudioRecorderDemo
//
//  Created by sunyazhou on 2017/3/29.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class LevelPair;
@class MemoModel;
//录音停止的回调
typedef void (^BDRecordingStopCompletionHanlder)(BOOL result);
//保存录音文件完成的回调
typedef void (^BDRecordingSaveCompletionHanlder)(BOOL result, id object);

@interface BDRecorder : NSObject

/**
 * 外部获取当前录制的时间
 * 小时:分钟:秒  当然后续可以加微秒和毫秒哈就是格式字符串 00:03:02 这样
 */
@property (nonatomic, readonly) NSString *formattedCurrentTime;

- (BOOL)record; //开始录音

- (void)pause;  //暂停录音

- (void)stopWithCompletionHandler:(BDRecordingStopCompletionHanlder)handler;

- (void)saveRecordingWithName:(NSString *)name
            completionHandler:(BDRecordingSaveCompletionHanlder)handler;

/**
 回放录制的文件

 @param memo 备忘录文件model 放着当前播放的model
 @return 是否播放成功
 */
- (BOOL)playbackURL:(MemoModel *)memo;



/**
 计算音频视波等级 显示绿黄红三种音量的标示

 @return <#return value description#>
 */
- (LevelPair *)levels;
@end
