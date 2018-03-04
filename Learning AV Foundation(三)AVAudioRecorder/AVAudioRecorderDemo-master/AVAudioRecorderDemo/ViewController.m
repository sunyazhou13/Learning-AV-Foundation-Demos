//
//  ViewController.m
//  AVAudioRecorderDemo
//
//  Created by sunyazhou on 2017/3/28.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "ViewController.h"

#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>

#import "BDRecorder.h"
#import "LevelMeterView.h"
#import "MemoModel.h"
#import "MemoCell.h"
#import "LevelPair.h"

#define MEMOS_ARCHIVE    @"memos.archive"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <MemoModel *>*memos;
@property (nonatomic, strong) BDRecorder *recorder;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CADisplayLink *levelTimer;


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet LevelMeterView *levelMeterView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recorder = [[BDRecorder alloc] init];
    self.memos = [NSMutableArray array];
    self.stopButton.enabled = NO;
    
    UIImage *recordImage = [[UIImage imageNamed:@"record"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *pauseImage = [[UIImage imageNamed:@"pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *stopImage = [[UIImage imageNamed:@"stop"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.recordButton setImage:recordImage forState:UIControlStateNormal];
    [self.recordButton setImage:pauseImage forState:UIControlStateSelected];
    [self.stopButton setImage:stopImage forState:UIControlStateNormal];
    
    NSData *data = [NSData dataWithContentsOfURL:[self archiveURL]];
    if (!data) {
        _memos = [NSMutableArray array];
    } else {
        _memos = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    
    [self.tableview registerNib:[UINib nibWithNibName:@"MemoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MemoCell"];
    
    
    [self layoutSubveiws];
}

- (void)layoutSubveiws{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(30);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.tableview.mas_top).offset(-50);
    }];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(200);
    }];
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.containerView);
        make.centerX.equalTo(self.containerView.mas_centerX);
        make.height.equalTo(@25);
    }];
    
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.width.height.equalTo(@71);
    }];
    
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containerView.mas_right);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.width.height.equalTo(@71);
    }];
    
    [self.levelMeterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@30);
        make.bottom.equalTo(self.tableview.mas_top);
    }];
}


- (void)startTimer {
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:0.5
                                         target:self
                                       selector:@selector(updateTimeDisplay)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateTimeDisplay {
    self.timeLabel.text = self.recorder.formattedCurrentTime;
}

- (void)startMeterTimer {
    [self.levelTimer invalidate];
    self.levelTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeter)];
//    if ([self.levelTimer respondsToSelector:@selector(setPreferredFramesPerSecond:)]) {
//        self.levelTimer.preferredFramesPerSecond = 5;
//    } else {
    self.levelTimer.frameInterval = 5;
//    }
    [self.levelTimer addToRunLoop:[NSRunLoop currentRunLoop]
                          forMode:NSRunLoopCommonModes];
    
}


- (void)stopMeterTimer {
    [self.levelTimer invalidate];
    self.levelTimer = nil;
    [self.levelMeterView resetLevelMeter];
}

- (void)updateMeter {
    LevelPair *levels = [self.recorder levels];
    self.levelMeterView.level = levels.level;
    self.levelMeterView.peakLevel = levels.peakLevel;
    [self.levelMeterView setNeedsDisplay];
    
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.memos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemoCell"];
    cell.model = self.memos[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MemoModel *model = self.memos[indexPath.row];
    [self.recorder playbackURL:model];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MemoModel *memo = self.memos[indexPath.row];
        [memo deleteMemo];
        [self.memos removeObjectAtIndex:indexPath.row];
        [self saveMemos];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
#pragma mark - event response 所有触发的事件响应 按钮、通知、分段控件等
- (IBAction)record:(UIButton *)sender {
    self.stopButton.enabled = YES;
    if ([sender isSelected]) {
        [self stopMeterTimer];
        [self stopTimer];
        [self.recorder pause];
    } else {
        [self startMeterTimer];
        [self startTimer];
        [self.recorder record];
    }
    [sender setSelected:![sender isSelected]];
}

- (IBAction)stopRecording:(UIButton *)sender {
    [self stopMeterTimer];
    self.recordButton.selected = NO;
    self.stopButton.enabled = NO;
    [self.recorder stopWithCompletionHandler:^(BOOL result) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [self showSaveDialog];
        });
    }];
}


- (void)showSaveDialog {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存录音" message:@"输入名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"我的录音";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *filename = [alertController.textFields.firstObject text];
        [self.recorder saveRecordingWithName:filename completionHandler:^(BOOL success, id object) {
            if (success) {
                [self.memos insertObject:object atIndex:0];
                [self saveMemos];
                [self.tableview reloadData];
            } else {
                NSLog(@"Error saving file: %@", [object localizedDescription]);
            }
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Memo Archiving
//保存备忘录model  这里简单用归档的方式存储一下

- (void)saveMemos {
    NSData *fileData = [NSKeyedArchiver archivedDataWithRootObject:self.memos];
    [fileData writeToURL:[self archiveURL] atomically:YES];
}

//存储归档的路径
- (NSURL *)archiveURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    NSString *archivePath = [docsDir stringByAppendingPathComponent:MEMOS_ARCHIVE];
    return [NSURL fileURLWithPath:archivePath];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
