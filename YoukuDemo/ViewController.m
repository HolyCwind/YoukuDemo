//
//  ViewController.m
//  YoukuDemo
//
//  Created by Cwind on 13-4-20.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//


#define myURL @"http://i.youku.com/u/UMTMwMzg5Mg==/videos"

#import "ViewController.h"
#import "ListTableViewController.h"

@interface ViewController ()
@property (nonatomic ,weak) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.myYouku = [[YoukuHelp alloc] init];
  [self.myYouku initWithUrl:[NSURL URLWithString:myURL]];
  
  self.title = self.myYouku.name;
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
  [self.view addSubview:imageView];
  self.imageView = imageView;
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.text = self.myYouku.details;
  label.numberOfLines = 0;
  label.lineBreakMode = NSLineBreakByWordWrapping;
   UIFont *font = [UIFont systemFontOfSize:13];
  CGSize size = CGSizeMake(300, 300);
  CGSize labelSize = [self.myYouku.details sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
  label.font = font;
  label.frame = CGRectMake(10,imageView.frame.size.height + 20, labelSize.width, labelSize.height);
  [self.view addSubview:label];
  
  dispatch_queue_t downloadQueue = dispatch_queue_create("download",NULL);
  dispatch_async(downloadQueue, ^{
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:self.myYouku.imageUrl]];
    dispatch_async(dispatch_get_main_queue(), ^{
      self.imageView.image = image;
      [self.imageView setFrame: CGRectMake((320 - image.size.width) / 2.0, 10, image.size.width, image.size.height)];
    });
  });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  [segue.destinationViewController setMyYouku:self.myYouku];
}

@end
