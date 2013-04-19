//
//  YoukuHelp.h
//  YoukuDemo
//
//  Created by Cwind on 13-4-19.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#define URLYOUKU1 @"http://v.youku.com/player/getRealM3U8/vid/"
#define URLYOUKU2 @"/type"

#import <Foundation/Foundation.h>
#import "TFHpple.h"

typedef enum{
  YOUKU720P = 0,
  YOUKU480P,
  YOUKU360P,
} VIDEOTYPE;

@interface YoukuHelp : NSObject
@property (nonatomic, strong) NSArray *listArray;
+ (YoukuHelp *)initWithUrl:(NSURL *)url;
- (NSString *)getTitle:(int)row;
- (UIImage *)getThumbnail:(int)row;
- (NSURL *)getVideoUrl:(int)row withType:(int)type;
@end
