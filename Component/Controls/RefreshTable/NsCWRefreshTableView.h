//
//  CWRefreshTableView.h
//  TableViewPull
//
//  Created by zhongxi wu on 11-12-21.
//  Copyright (c) 2011年 newcosoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

#import "NsRefreshTableHeaderView.h"

@class LotteryAppDelegate;
@class LOTitlebarView;

//pull direction

typedef enum {
    
    CWRefreshTableViewDirectionUp,
    CWRefreshTableViewDirectionDown,    
    CWRefreshTableViewDirectionAll
    
}CWRefreshTableViewDirection;

//pull type

typedef enum {
    
    CWRefreshTableViewPullTypeReload,           //从新加载
    
    CWRefreshTableViewPullTypeLoadMore,         //加载更多
    
}CWRefreshTableViewPullType;

@protocol CWRefreshTableViewDelegate;

@interface NsCWRefreshTableView : NSObject<EGORefreshTableHeaderDelegate,UIScrollViewDelegate>

{ 
    
    BOOL                        _reloading;
    
    NsRefreshTableHeaderView  *_headView;
    
    NsRefreshTableHeaderView  *_footerView;
    
    CWRefreshTableViewDirection    _direction;
//	 UITableView  *pullTableView;
	UITableView  *_pullTableView;
	id<CWRefreshTableViewDelegate>_delegate;
  
}
@property (nonatomic, assign) UITableView  *pullTableView;
@property (nonatomic,assign)NsRefreshTableHeaderView  *headView,*footerView;
@property (nonatomic, assign) id<CWRefreshTableViewDelegate> delegate;



//方向

- (id) initWithTableView:(UITableView *) tView

           pullDirection:(CWRefreshTableViewDirection) cwDirection;

//加载完成调用

- (void) DataSourceDidFinishedLoading;

@end


//

@protocol CWRefreshTableViewDelegate <NSObject>

//重新加载

- (BOOL) CWRefreshTableViewReloadTableViewDataSource:(CWRefreshTableViewPullType) refreshType;



@end
