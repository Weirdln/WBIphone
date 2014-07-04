//
//  CMRefreshTableHeaderView.h
//  DzhIPhone
//
//  Created by Weirdln on 14-7-4.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define startOffset 65.0f

typedef enum {
    CMPullOrientationDown = 0, /* Pull Down */
    CMPullOrientationUp,       /* Pull Up */
    CMPullOrientationRight,    /* Pull Right */
    CMPullOrientationLeft,     /* Pull Left */
}CMPullOrientation;

typedef enum{
	CMPullRefreshPulling = 0,
	CMPullRefreshNormal,
	CMPullRefreshLoading,
    CMPullRefreshEnd,
} CMPullRefreshState;

@protocol CMRefreshTableHeaderDelegate;
@interface CMRefreshTableHeaderView : UIView {
	
	id _delegate;
	CMPullRefreshState _state;
    CMPullOrientation _orientation;
    
    UIScrollView* _scrollView;
    
    BOOL _pagingEnabled;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

//@property (nonatomic) float startOffset; // 开始判断的偏移量
@property (nonatomic,assign) id <CMRefreshTableHeaderDelegate> delegate;

- (id)initWithScrollView:(UIScrollView* )scrollView orientation:(CMPullOrientation)orientation;

// UIScrollViewde contensize发生改变时，需要重新设置framework
- (void)adjustPosition;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end



@protocol CMRefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(CMRefreshTableHeaderView*)view pullDirection:(CMPullOrientation) cmDirection;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(CMRefreshTableHeaderView*)view;

@optional

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(CMRefreshTableHeaderView*)view;

@end

