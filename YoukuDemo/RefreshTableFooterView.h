//
//  RefreshTableFooterView.h
//  UitableViewLoadDemo
//
//  Created by Cwind on 13-4-17.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
  FOOTPulling = 0,
  FOOTNormal,
  FOOTLoading,
} FOOTState;

@protocol RefreshTableFooterDelegate;

@interface RefreshTableFooterView : UIView
@property (nonatomic) id <RefreshTableFooterDelegate> delegate;
@property (nonatomic, weak) UILabel *footerLabel;
@property (nonatomic) FOOTState state;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)refreshNoMore;
- (void)refreshInit;
@end

@protocol RefreshTableFooterDelegate
- (void) refreshTableFooter;
- (BOOL) refreshTableFooterDataSourceIsLoading;
@end