//
//  BDRecorder.m
//  AVAudioRecorderDemo
//
//  Created by sunyazhou on 2017/3/29.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "BDRecorder.h"

#import "MemoModel.h"
#import "LevelPair.h"
#import "MeterTable.h"


@interface BDRecorder () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) BDRecordingStopCompletionHanlder completionHandler;
@property (nonatomic, strong) MeterTable *meterTable;
@end

@implementation BDRecorder

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *temDir = NSTemporaryDirectory();
        NSString *filePath = [temDir stringByAppendingPathComponent:@"test1.caf"];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        
        NSDictionary *setting = @{AVFormatIDKey: @(kAudioFormatAppleIMA4),
                                  AVSampleRateKey: @44100.0f,
                                  AVNumberOfChannelsKey: @1,
                                  AVEncoderBitDepthHintKey: @16,
                                  AVEncoderAudioQualityKey: @(AVAudioQualityMedium)
                                  };
        NSError *error;
        self.recorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:setting error:&error];
        if (self.recorder) {
            self.recorder.delegate = self;
            self.recorder.meteringEnabled = YES;
            [self.recorder prepareToRecord];
        } else {
            NSLog(@"Create Recorder Error: %@",[error localizedDescription]);
        }
        
        self.meterTable = [[MeterTable alloc] init];
    }
    return self;
}

- (BOOL)record {
    return [self.recorder record];
}

- (void)pause {
    [self.recorder pause];
}

- (void)stopWithCompletionHandler:(BDRecordingStopCompletionHanlder)handler {
    self.completionHandler = handler;
    [self.recorder stop];
}

- (void)saveRecordingWithName:(NSString *)name
            completionHandler:(BDRecordingSaveCompletionHanlder)handler {
    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    NSString *filename = [NSString stringWithFormat:@"%@-%f.caf", name, timestamp];
    NSString *docDir = [self documentsDirectory];
    NSString *destPath = [docDir stringByAppendingPathComponent:filename];
    NSURL *srcURL = self.recorder.url;
    NSURL *destURL = [NSURL fileURLWithPath:destPath];
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:srcURL toURL:destURL error:&error];
    if (success) {
        MemoModel *model = [MemoModel memoWithTitle:name url:destURL];
        handler(YES, model);
    }
    
}

- (NSString *)documentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

#pragma mark - 
#pragma mark - AVAudioRecorder Delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder
                           successfully:(BOOL)flag {
    if (self.completionHandler) { self.completionHandler(flag); }
}



/**
 回放录制的文件
 
 @param memo 备忘录文件model 放着当前播放的model
 @return 是否播放成功
 */
- (BOOL)playbackURL:(MemoModel *)memo {
    [self.player stop];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:memo.url error:nil];
    if (self.player) {
        [self.player play];
        return YES;
    }
    return NO;
}


/**
 返回当前录制的时间格式 HH:mm:ss

 @return 返回组装好的字符串
 */
- (NSString *)formattedCurrentTime {
    NSUInteger time = (NSUInteger)self.recorder.currentTime;
    NSInteger hours = (time / 3600);
    NSInteger minutes = (time / 60) % 60;
    NSInteger seconds = time % 60;
    
    NSString *format = @"%02i:%02i:%02i";
    return [NSString stringWithFormat:format, hours, minutes, seconds];
}


- (LevelPair *)levels {
    [self.recorder updateMeters];
    float avgPower = [self.recorder averagePowerForChannel:0];
    float peakPower = [self.recorder peakPowerForChannel:0];
    float linearLevel = [self.meterTable valueForPower:avgPower];
    float linearPeak = [self.meterTable valueForPower:peakPower];
    return [LevelPair levelsWithLevel:linearLevel peakLevel:linearPeak];
}
@end
