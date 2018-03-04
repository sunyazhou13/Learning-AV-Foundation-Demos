//
//  ViewController.m
//  AVSpeechSynthesizerDemo
//
//  Created by sunyazhou on 2017/3/11.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "ViewController.h"
#import "SpeechCell.h"
#import <Masonry/Masonry.h>

#import <AVFoundation/AVFoundation.h>


@interface ViewController () <UITableViewDataSource, UITableViewDelegate, AVSpeechSynthesizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;


@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer; //语音合成

@property (strong, nonatomic) NSArray *voices; //存放声音类型
@property (strong, nonatomic) NSMutableArray *speechStrings; //要播放的字符串数组


@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //创建语音合成器
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    self.synthesizer.delegate = self;
    //播放的国家的语言
    self.voices = @[[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"],
                    [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"]
                    ];
    self.speechStrings = [[NSMutableArray alloc] init];
    
}

- (NSArray *)buildSpeechStrings {
    return @[@"who you are? 说话在不",
             @"我是孙亚洲,an iOS developer from harbin",
             @"where is harbin?, 哈尔滨在哪？",
             @"在中国东北. north east of China",
             @"hello, what's the going on?",
             @"老样子",
             @"just so so",
             @"not so bad, 不算太好",
             @"看到你的博客,可否自我介绍一下, I've saw your technology blog",
             @"嗨，我是孙亚洲, 一个来自北国冰城的iOS&macOS开发者,就职于百度,爱好书法。开发5年有余,没有为往圣续绝学深感惭愧，今2017年开始写博客, 望诸位同仁多多指教."];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableview配置
    [self.chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.chatTableView registerNib:[UINib nibWithNibName:@"SpeechCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SpeechCell"];

    
    //播放语音
    NSArray *speechStringsArray = [self buildSpeechStrings];
    for (NSUInteger i = 0; i < speechStringsArray.count; i++) {
        //创建AVSpeechUtterance 对象 用于播放的语音文字
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:speechStringsArray[i]];
        //设置使用哪一个国家的语言播放
        utterance.voice = self.voices[0];
        //本段文字播放时的 语速, 应介于AVSpeechUtteranceMinimumSpeechRate 和 AVSpeechUtteranceMaximumSpeechRate 之间
        utterance.rate = 0.5;
        //在播放特定语句时改变声音的声调, 一般取值介于0.5(底音调)~2.0(高音调)之间
        utterance.pitchMultiplier = 0.8f;
        //声音大小, 0.0 ~ 1.0 之间
        utterance.volume = 1.0f;
        //播放后的延迟, 就是本次文字播放完之后的停顿时间, 默认是0
        utterance.preUtteranceDelay = 0;
        //播放前的延迟, 就是本次文字播放前停顿的时间, 然后播放本段文字, 默认是0
        utterance.postUtteranceDelay = 0.1f;
        [self.synthesizer speakUtterance:utterance];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.speechStrings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpeechCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpeechCell"];
    
    cell.label.text = self.speechStrings[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark -
#pragma mark - AVSpeechSynthesizer 代理
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"正在朗读:\n%@",utterance.speechString);
    //获取utterance 当前播放的文字
    [self.speechStrings addObject:utterance.speechString];
    
    [self.chatTableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.speechStrings.count -1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
