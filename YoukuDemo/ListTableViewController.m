//
//  ListTableViewController.m
//  YoukuDemo
//
//  Created by Cwind on 13-4-19.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#import "ListTableViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Youku Demo";
 
  if (self.footerView == nil) {
    RefreshTableFooterView *footerView = [[RefreshTableFooterView alloc] initWithFrame:CGRectMake(0,  MAX(self.myYouku.listArray.count * 44,self.tableView.bounds.size.height), 320, self.tableView.bounds.size.height)];
    footerView .delegate = self;
    [self.tableView addSubview:footerView];
    self.footerView = footerView;
  }
  if (self.headerView == nil) {
    RefreshTableHeaderView *headerView = [[RefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - self.tableView.bounds.size.height, 320, self.tableView.bounds.size.height)];
    headerView.delegate = self;
    [self.tableView addSubview:headerView];
    self.headerView = headerView;
  }

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
  
  MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
  [self presentMoviePlayerViewControllerAnimated:mp];
}

#pragma mark - Refresh Methods

- (void)doneLoadTableViewData
{
  [[self chooseRefreshType] refreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (id)chooseRefreshType
{
  if (self.refreshType == REFRESHHead) {
    return self.headerView;
  }else {
    return self.footerView;
  }
}

- (void)reloadTableViewDataSource
{
  self.myYouku.page++;
  dispatch_queue_t downloadQueue = dispatch_queue_create("loadMore",NULL);
  dispatch_async(downloadQueue, ^{
    
    int numberOfOriginalRows = self.myYouku.listArray.count;
    [self.myYouku addList];
    int numberOfNewRows = self.myYouku.listArray.count;
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (int i = numberOfOriginalRows; i < numberOfNewRows; i++) {
      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
      [indexPathArray addObject:indexPath];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      self.footerView.frame = CGRectMake(0, 44 * self.myYouku.listArray.count, 320, 48);
      [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationMiddle];
      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfOriginalRows inSection:0];
      [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
      self.isLoading = NO;
      [self doneLoadTableViewData];
    });
  });
}

- (void)refreshTableViewDataSource
{
  [self.myYouku initWithUrl:self.myYouku.url];
  [self.tableView reloadData];
  self.isLoading = NO;
  [self.footerView refreshInit];
  self.footerView.frame = CGRectMake(0, MAX(self.myYouku.listArray.count * 44,self.tableView.bounds.size.height + 15), 320, 48);
  [self doneLoadTableViewData];

}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (scrollView.contentOffset.y > 0) {
    self.refreshType = REFRESHFoot;
    if (self.myYouku.pageTotal == self.myYouku.page) {
      [self.footerView refreshNoMore];
      return;
    }
  }else {
    self.refreshType = REFRESHHead;
  }
  [[self chooseRefreshType] refreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  if (scrollView.contentOffset.y > 0 && self.myYouku.pageTotal == self.myYouku.page) {
    return;
  }
  [[self chooseRefreshType] refreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)refreshTableHeader
{
  self.isLoading = YES;
  [self performSelector:@selector(refreshTableViewDataSource) withObject:nil afterDelay:0.5];
}

- (BOOL)refreshTableHeaderDataSourceIsLoading
{
  return self.isLoading;
}

#pragma mark - EGORefreshTableFooterDelegate Methods

- (void)refreshTableFooter
{
  self.isLoading = YES;
  [self performSelector:@selector(reloadTableViewDataSource) withObject:nil afterDelay:0.5];
}

- (BOOL)refreshTableFooterDataSourceIsLoading
{
  return self.isLoading;
}

#pragma mark - Memory Management

- (void)dealloc
{
  self.footerView.delegate = nil;
  self.headerView.delegate = nil;
}

@end
