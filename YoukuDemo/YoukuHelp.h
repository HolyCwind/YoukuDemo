//
//  YoukuHelp.h
//  YoukuDemo
//
//  Created by Cwind on 13-4-19.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#define URLYOUKU1 @"http://v.youku.com/player/getRealM3U8/vid/"
#define URLYOUKU2 @"/type"
#define NEXTURL @"/order_1_view_1_page_"

#import <Foundation/Foundation.h>
#import "TFHpple.h"

typedef enum{
  YOUKU720P = 0,
  YOUKU480P,
  YOUKU360P,
} VIDEOTYPE;

@interface YoukuHelp : NSObject
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic) int pageTotal;
@property (nonatomic) int page;
@property (nonatomic) NSString *details;
@property (nonatomic) NSString *name;
@property (nonatomic) NSURL *imageUrl;

- (void)initWithUrl:(NSURL *)url;
- (NSString *)getTitle:(int)row;
- (UIImage *)getThumbnail:(int)row;
- (NSURL *)getVideoUrl:(int)row withType:(int)type;
- (void)addList;
@end
