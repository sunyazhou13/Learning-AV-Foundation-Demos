//
//  MemoModel.h
//  AVAudioRecorderDemo
//
//  Created by sunyazhou on 2017/3/31.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoModel : NSObject <NSCopying>
@property (copy, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSURL *url;
@property (copy, nonatomic, readonly) NSString *dateString;
@property (copy, nonatomic, readonly) NSString *timeString;

+ (instancetype)memoWithTitle:(NSString *)title url:(NSURL *)url;

- (BOOL)deleteMemo;
@end
