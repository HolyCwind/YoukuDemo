//
//  RefreshTableHeaderView.h
//  UitableViewLoadDemo
//
//  Created by Cwind on 13-4-17.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
  REFRESHPulling = 0,
  REFRESHNormal,
  REFRESHLoading,
} RefreshState;

@protocol RefreshTableHeaderDelegate;

@interface RefreshTableHeaderView : UIView
@property (nonatomic) id <RefreshTableHeaderDelegate> delegate;
@property (nonatomic, weak) UILabel *headerLabel;
@property (nonatomic) RefreshState state;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
@end

@protocol RefreshTableHeaderDelegate
- (void) refreshTableHeader;
- (BOOL) refreshTableHeaderDataSourceIsLoading;
@end