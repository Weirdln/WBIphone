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
#define FLIP_ANIMATION_DURATION 0.18f

#define RectX(rect)                                   rect.origin.x
#define RectY(rect)                                   rect.origin.y
#define RectWidth(rect)                               rect.size.width
#define RectHeight(rect)                              rect.size.height

#define RectSetWidth(rect, w)                         CGRectMake(RectX(rect), RectY(rect), w, RectHeight(rect))
#define RectSetHeight(rect, h)                        CGRectMake(RectX(rect), RectY(rect), RectWidth(rect), h)
#define RectSetX(rect, x)                             CGRectMake(x, RectY(rect), RectWidth(rect), RectHeight(rect))
#define RectSetY(rect, y)                             CGRectMake(RectX(rect), y, RectWidth(rect), RectHeight(rect))

#define RectSetSize(rect, w, h)                       CGRectMake(RectX(rect), RectY(rect), w, h)
#define RectSetOrigin(rect, x, y)                     CGRectMake(x, y, RectWidth(rect), RectHeight(rect))

#define EdgeInsetSetTop(oldEdgeInsets, newTop)        UIEdgeInsetsMake(newTop, oldEdgeInsets.left, oldEdgeInsets.bottom, oldEdgeInsets.right);
#define EdgeInsetSetLeft(oldEdgeInsets, newLeft)      UIEdgeInsetsMake(oldEdgeInsets.top, newLeft, oldEdgeInsets.bottom, oldEdgeInsets.right);
#define EdgeInsetSetBottom(oldEdgeInsets, newBottom)  UIEdgeInsetsMake(oldEdgeInsets.top, oldEdgeInsets.left, newBottom, oldEdgeInsets.right);
#define EdgeInsetSetRight(oldEdgeInsets, newRright)   UIEdgeInsetsMake(oldEdgeInsets.top, oldEdgeInsets.left, oldEdgeInsets.bottom, newRright);

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
    CMPullRefreshClickNormal,
    CMPullRefreshClickLoading,
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
@property (nonatomic) float clickHeight;   // 点击加载更多行的高度
@property (nonatomic,assign) id <CMRefreshTableHeaderDelegate> delegate;

- (id)initWithScrollView:(UIScrollView* )scrollView orientation:(CMPullOrientation)orientation;

// UIScrollViewde contensize发生改变时，需要重新设置framework
- (void)adjustPosition;

// 设置状态
- (void)setState:(CMPullRefreshState)aState;

// 刷新上次操作时间
- (void)refreshLastUpdatedDate;

- (void)cmRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)cmRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)cmRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end



@protocol CMRefreshTableHeaderDelegate

- (void)cmRefreshTableHeaderDidTriggerRefresh:(CMRefreshTableHeaderView*)view pullDirection:(CMPullOrientation) cmDirection;
- (BOOL)cmRefreshTableHeaderDataSourceIsLoading:(CMRefreshTableHeaderView*)view;

@optional

- (NSDate*)cmRefreshTableHeaderDataSourceLastUpdated:(CMRefreshTableHeaderView*)view;

@end

