//
//  ListTableViewController.m
//  YoukuDemo
//
//  Created by Cwind on 13-4-19.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#define myURL @"http://i.youku.com/u/UMTMwMzg5Mg==/videos"

#import "ListTableViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Youku Demo";
 
  self.myYouku = [YoukuHelp initWithUrl:[NSURL URLWithString:myURL]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.myYouku.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  NSString *detailString = [self.myYouku getTitle:indexPath.row];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    detailLabel.numberOfLines = 0;
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = CGSizeMake(220, 48);
    CGSize labelSize = [detailString sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    detailLabel.text = detailString;
    detailLabel.font = font;
    detailLabel.frame = CGRectMake(64 + 20,(cell.contentView.frame.size.height - labelSize.height) / 2, labelSize.width, labelSize.height);
    [cell.contentView addSubview:detailLabel];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("download image",NULL);
    dispatch_async(downloadQueue, ^{
      UIImage *image = [self.myYouku getThumbnail:indexPath.row];
      dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 64, 48);
        [cell.contentView addSubview:imageView];
      });
    });
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
  }else {
    for (id view in cell.contentView.subviews) {
      if ([view isKindOfClass:[UIImageView class]]){
        [view removeFromSuperview];
      }
    }
    dispatch_queue_t downloadQueue = dispatch_queue_create("download",NULL);
    dispatch_async(downloadQueue, ^{
      UIImage *image = [self.myYouku getThumbnail:indexPath.row];
      dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, 64, 48);
        [cell.contentView addSubview:imageView];
      });
    });
  }
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSURL *url = [self.myYouku getVideoUrl:indexPath.row withType:YOUKU720P];
  NSLog(@"%@",url);
  
  MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
  [self presentMoviePlayerViewControllerAnimated:mp];
}

@end
