//
//  SpeechCell.m
//  AVSpeechSynthesizerDemo
//
//  Created by sunyazhou on 2017/3/11.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "SpeechCell.h"
#import <Masonry/Masonry.h>
@interface SpeechCell ()


@end

@implementation SpeechCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
