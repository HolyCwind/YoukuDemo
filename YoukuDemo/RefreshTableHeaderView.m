//
//  RefreshTableHeaderView.m
//  UitableViewLoadDemo
//
//  Created by Cwind on 13-4-17.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#define PULL  @"下拉刷新"
#define RELEASE @"好了松手啦"
#define LOADING @"加载中..."
#define DURATIONTIME 0.3f
#define UILABELHEIGHT 44

#import "RefreshTableHeaderView.h"

@implementation RefreshTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - UILABELHEIGHT, 320, UILABELHEIGHT)];
      label.backgroundColor = [UIColor clearColor];
      label.textAlignment = NSTextAlignmentCenter;
      [self addSubview:label];
      self.headerLabel = label;
      [self setStates:REFRESHNormal];
    }
    return self;
}

- (void)setStates:(RefreshState)state
{
  switch (state) {
    case REFRESHNormal:
      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationDuration:DURATIONTIME];
      self.headerLabel.text = PULL;
      [UIView commitAnimations];
      break;
      
    case REFRESHPulling:
      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationDuration:DURATIONTIME];
      self.headerLabel.text = RELEASE;
      [UIView commitAnimations];
      break;
      
    case REFRESHLoading:
      [UIView beginAnimations:nil context:NULL];
      [UIView setAnimationDuration:DURATIONTIME];
      self.headerLabel.text = LOADING;
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
  if (self.state == REFRESHLoading) {
    CGFloat offset = MAX(scrollView.contentOffset.y * -1,0);
    offset = MIN(offset, UILABELHEIGHT);
    scrollView.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0);
  }else if(scrollView.isDragging) {
    BOOL isLoading = [self.delegate refreshTableHeaderDataSourceIsLoading];
    if (self.state == REFRESHPulling && scrollView.contentOffset.y > -UILABELHEIGHT && scrollView.contentOffset.y < 0 && !isLoading) {
      [self setStates:REFRESHNormal];
    } else if (self.state == REFRESHNormal && scrollView.contentOffset.y < -UILABELHEIGHT && !isLoading) {
      [self setStates:REFRESHPulling];
    }
    
    if (scrollView.contentInset.top != 0) {
      scrollView.contentInset = UIEdgeInsetsZero;
    }
  }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
  BOOL isLoading = [self.delegate refreshTableHeaderDataSourceIsLoading];
  if (scrollView.contentOffset.y < -UILABELHEIGHT && !isLoading) {
    [self.delegate refreshTableHeader];
    [self setStates:REFRESHLoading];
    [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:DURATIONTIME];
		scrollView.contentInset = UIEdgeInsetsMake(UILABELHEIGHT, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
  }
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
  [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:DURATIONTIME];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
  
  [self setStates:REFRESHNormal];
}

@end
