//
//  Genre.h
//  MetaDemo
//
//  Created by sunyazhou on 2017/7/31.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 音频歌曲 风格  eg: 蓝调 、乡村 等
 */
@interface Genre : NSObject <NSCopying>
@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, copy, readonly) NSString *name;

+ (NSArray *)musicGenres;

+ (NSArray *)videoGenres;

+ (Genre *)id3GenreWithIndex:(NSUInteger)index;

+ (Genre *)id3GenreWithName:(NSString *)name;

+ (Genre *)iTunesGenreWithIndex:(NSUInteger)index;

+ (Genre *)videoGenreWithName:(NSString *)name;
@end
