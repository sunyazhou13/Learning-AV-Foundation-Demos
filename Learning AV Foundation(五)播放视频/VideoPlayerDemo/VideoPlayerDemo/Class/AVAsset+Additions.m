//
//  AVAsset+Additions.m
//  VideoPlayerDemo
//
//  Created by SUNYAZHOU on 2018/3/4.
//  Copyright © 2018年 sunyazhou. All rights reserved.
//

#import "AVAsset+Additions.h"

@implementation AVAsset (Additions)
- (NSString *)title {
    
    AVKeyValueStatus status =
    [self statusOfValueForKey:@"commonMetadata" error:nil];
    if (status == AVKeyValueStatusLoaded) {
        NSArray *items =
        [AVMetadataItem metadataItemsFromArray:self.commonMetadata
                                       withKey:AVMetadataCommonKeyTitle
                                      keySpace:AVMetadataKeySpaceCommon];
        if (items.count > 0) {
            AVMetadataItem *titleItem = [items firstObject];
            return (NSString *)titleItem.value;
        }
    }
    
    return nil;
}
@end
