//
//  YoukuHelp.m
//  YoukuDemo
//
//  Created by Cwind on 13-4-19.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#import "YoukuHelp.h"

@implementation YoukuHelp
  
- (void)initWithUrl:(NSURL *)url
{
  self.url = url;
  self.page = 1;
  NSData *siteData = [NSData dataWithContentsOfURL:url];
  TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:siteData];
  self.listArray = [xpathParser searchWithXPathQuery:@"//ul[@class='v']/li[@class][position()=2]/img"];
  
  NSArray *pageTotal = [xpathParser searchWithXPathQuery:@"//ul[@class='pages']/li[@class='last']/a"];
  if (pageTotal.count > 0) {
    TFHppleElement *element = [pageTotal objectAtIndex:0];
    TFHppleElement *element1 = [element children][1];
    NSString *pageString = element1.content;
    self.pageTotal = [pageString intValue];
  }else {
    self.pageTotal = 1;
  }
  
  NSArray *name = [xpathParser searchWithXPathQuery:@"//ul[@class='info']/li[@class='avatar']/a/img"];
  TFHppleElement *element = name[0];
  NSDictionary *dic = [element attributes];
  self.name = dic[@"title"];
  self.imageUrl = [NSURL URLWithString:dic[@"src"]];
  
  NSArray *detail = [xpathParser searchWithXPathQuery:@"//div[@class='summary']/div[@_fr='more']"];
  TFHppleElement *elementDetail = [detail[0] firstChild];
  self.details = elementDetail.content;
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

- (void)addList
{
  NSArray *list = @[];
  NSString *initUrl = [self.url absoluteString];
  NSString *tempUrl = [initUrl substringToIndex:(initUrl.length - 5)];
  NSString *tempUrl2 = [tempUrl stringByAppendingString:NEXTURL];
  NSString *url = [tempUrl2 stringByAppendingFormat:@"%d%@",self.page,@".html"];
  
  NSData *siteData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
  TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:siteData];
  list = [xpathParser searchWithXPathQuery:@"//ul[@class='v']/li[@class][position()=2]/img"];
  self.listArray = [self.listArray arrayByAddingObjectsFromArray:list];
}

@end
