//
//  AppDelegate.m
//  NSSpeechSynthesizerDemo
//
//  Created by sunyazhou on 2017/3/20.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong) NSSpeechSynthesizer *synthesizer;


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if(self.synthesizer == nil) {
        self.synthesizer = [[NSSpeechSynthesizer alloc] initWithVoice:@"com.apple.speech.synthesis.voice.ting-ting"];
        NSArray *voices = [NSSpeechSynthesizer availableVoices];
        NSLog(@"%@",voices);
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (IBAction)speech:(NSButton *)sender {
    if (self.textView.string.length > 0) {
        [self.synthesizer startSpeakingString:self.textView.string];
    }
    
}
- (IBAction)stop:(id)sender {
    [self.synthesizer stopSpeaking];
}

@end
