//
//  YoukuHelp.m
//  YoukuDemo
//
//  Created by Cwind on 13-4-19.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#import "YoukuHelp.h"

@implementation YoukuHelp
  
+ (YoukuHelp *)initWithUrl:(NSURL *)url
{
  YoukuHelp *myYouku = [[YoukuHelp alloc] init];
  NSData *siteData = [NSData dataWithContentsOfURL:url];
  TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:siteData];
  myYouku.listArray = [xpathParser searchWithXPathQuery:@"//ul[@class='v']/li[@class][position()=2]/img"];
  return myYouku;
}

- (NSString *)getTitle:(int)row
{
  NSDictionary *dic;
  NSString *detailString;
  TFHppleElement *element = [self.listArray objectAtIndex:row];
  dic = [element attributes];
  detailString = dic[@"title"];
  return detailString;
}

- (UIImage *)getThumbnail:(int)row
{
  NSDictionary *dic;
  TFHppleElement *element = [self.listArray objectAtIndex:row];
  dic = [element attributes];
  NSURL *thumbnail = [NSURL URLWithString:dic[@"src"]];
  UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:thumbnail]];
  return image;
}

- (NSURL *)getVideoUrl:(int)row withType:(int)type
{
  NSDictionary *dic;
  TFHppleElement *element = [self.listArray objectAtIndex:row];
  dic = [element attributes];
  NSString *urlTemp = [URLYOUKU1 stringByAppendingFormat:@"%@%@",dic[@"name"],URLYOUKU2];
  NSArray *suffixArray = @[@"/hd2/v.m3u8",@"/mp4/v.m3u8",@"/flv/v.m3u8"];
  NSString *videoUrl = [urlTemp stringByAppendingString:suffixArray[type]];
  return [NSURL URLWithString:videoUrl];
 }
@end
