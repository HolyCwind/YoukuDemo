//
//  ListTableViewController.h
//  YoukuDemo
//
//  Created by Cwind on 13-4-19.
//  Copyright (c) 2013年 com.cwind. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YoukuHelp.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RefreshTableFooterView.h"
#import "RefreshTableHeaderView.h"

typedef enum{
  REFRESHHead = 0,
  REFRESHFoot,
} RefreshType;

@interface ListTableViewController : UITableViewController<RefreshTableFooterDelegate,RefreshTableHeaderDelegate>
@property (nonatomic, strong) YoukuHelp *myYouku;
@property (nonatomic, weak) RefreshTableFooterView *footerView;
@property (nonatomic, weak) RefreshTableHeaderView *headerView;
@property (nonatomic) RefreshType refreshType;
@property (nonatomic) BOOL isLoading;

- (void)reloadTableViewDataSource;
- (void)doneLoadTableViewData;
- (id)chooseRefreshType;
@end
