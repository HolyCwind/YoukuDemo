//
//  RefreshTableFooterView.m
//  UitableViewLoadDemo
//
//  Created by Cwind on 13-4-17.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#define PULL  @"上拉加载"
#define RELEASE @"好了松手啦"
#define LOADING @"加载中..."
#define NOMORE @"到底啦"
#define DURATIONTIME 0.3f
#define UILABELHEIGHT 44

#import "RefreshTableFooterView.h"

@implementation RefreshTableFooterView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, UILABELHEIGHT)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.footerLabel = label;
    [self setStates:FOOTNormal];
  }
  return self;
}

- (void)setStates:(FOOTState)state
{
  switch (state) {
    case FOOTNormal:
      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationDuration:DURATIONTIME];
      self.footerLabel.text = PULL;
      [UIView commitAnimations];
      break;
      
    case FOOTPulling:
      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationDuration:DURATIONTIME];
      self.footerLabel.text = RELEASE;
      [UIView commitAnimations];
      break;
      
    case FOOTLoading:
      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationDuration:DURATIONTIME];
      self.footerLabel.text = LOADING;
      [UIView commitAnimations];
      break;
    default:
      break;
  }
  self.state = state;
}

#pragma mark ScrollView Methods

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
  float offSetButtom = MAX(0,scrollView.contentSize.height - scrollView.frame.size.height);
  if(scrollView.isDragging) {
    BOOL isLoading = [self.delegate refreshTableFooterDataSourceIsLoading];
    if (self.state == FOOTPulling && scrollView.contentOffset.y < offSetButtom + UILABELHEIGHT && scrollView.contentOffset.y > offSetButtom && !isLoading) {
      [self setStates:FOOTNormal];
    } else if (self.state == FOOTNormal && scrollView.contentOffset.y > offSetButtom + UILABELHEIGHT && !isLoading) {
      [self setStates:FOOTPulling];
    }
  }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
  BOOL isLoading = [self.delegate refreshTableFooterDataSourceIsLoading];
  float offSetButtom = scrollView.contentSize.height - scrollView.frame.size.height;
  float offSet = MAX(0, offSetButtom);
  if (scrollView.contentOffset.y > offSet + UILABELHEIGHT && !isLoading) {
    [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:DURATIONTIME];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, MAX(UILABELHEIGHT,-offSetButtom + UILABELHEIGHT), 0.0f);
    [self setStates:FOOTLoading];
		[UIView commitAnimations];
    [self.delegate refreshTableFooter];
  }
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
  [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:DURATIONTIME];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
  
  [self setStates:FOOTNormal];
}

- (void)refreshNoMore
{
  [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:DURATIONTIME];
  self.footerLabel.text = NOMORE;
	[UIView commitAnimations];
}

- (void)refreshInit
{
  [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:DURATIONTIME];
  self.footerLabel.text = PULL;
	[UIView commitAnimations];
}

@end
