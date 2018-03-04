//
//  MemoCell.m
//  AVAudioRecorderDemo
//
//  Created by sunyazhou on 2017/4/5.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "MemoCell.h"
#import <Masonry/Masonry.h>

@interface MemoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation MemoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.right.lessThanOrEqualTo(self.dateLabel.mas_left);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@26).priorityHigh();
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.top.equalTo(self.mas_top).offset(5);
        make.width.equalTo(@80).priorityHigh();
        make.height.equalTo(@20);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.text = self.model.title;
    self.timeLabel.text = self.model.timeString;
    self.dateLabel.text = self.model.dateString;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
