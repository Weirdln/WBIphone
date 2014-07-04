//
//  CMTableView.h
//  DzhIPhone
//
//  Created by Weirdln on 14-6-27.
//
//

#import <UIKit/UIKit.h>
#import "CMRefreshTableHeaderView.h"
#import "MethodInterceptor.h"

#define timeOutTimeInterval 2  // 刷新超时时间

// pull direction
typedef enum {
    CMTableViewPullDirectionNone,
    CMTableViewPullDirectionDown      = (1 << CMPullOrientationDown),
    CMTableViewPullDirectionUp        = (1 << CMPullOrientationUp),
    CMTableViewPullDirectionRight     = (1 << CMPullOrientationRight),
    CMTableViewPullDirectionLeft      = (1 << CMPullOrientationLeft),
    CMTableViewPullDirectionUpDown    = (CMTableViewPullDirectionUp | CMTableViewPullDirectionDown),
    CMTableViewPullDirectionRightLeft = (CMTableViewPullDirectionRight | CMTableViewPullDirectionLeft),
    CMTableViewPullDirectionAll       = (CMTableViewPullDirectionUp | CMTableViewPullDirectionDown | CMTableViewPullDirectionRight | CMTableViewPullDirectionLeft)
}CMTableViewPullDirection;

// Load type
typedef enum {
    CMTableViewLoadType_Reload,           // 刷新
    CMTableViewLoadType_LoadMore,         // 加载更多
    CMTableViewLoadType_LoadRollRange,    // 加载当前滚动范围
    CMTableViewLoadType_PreLoad           // 预加载更多
}CMTableViewLoadType;


// CMRefreshTableViewDelegate
@class CMTableView;
@protocol CMRefreshTableViewDelegate <NSObject>

@optional

/**
 *  下拉刷新或者上拉加载更多
 *
 *  @param dataView 当前tableView
 *  @param loadType 加载类型
 *  @param currentIndexPath 当前需要的indexPath，可用于判断目前已有的总数
 *         CMTableViewLoadType_Reload    indexPath ＝ {0, 0}
 *         CMTableViewLoadType_LoadMore  indexPath ＝ {last section ,last row}
 *         CMTableViewLoadType_PreLoad   indexPath ＝ {current section ,current row}
 */
- (void)refreshDataView:(CMTableView *)dataView loadType:(CMTableViewLoadType)loadType indexPath:(NSIndexPath*)indexPath;

/**
 *  滚动加载当前视图
 *
 *  @param dataView 当前tableView
 *  @param visibleRange    当前视图范围{section : range,...}
 */
- (void)refreshDataView:(CMTableView *)dataView visibleRange:(NSDictionary *)rangeDict;


@end



@interface CMTableView : UIView<CMRefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    CMRefreshTableHeaderView  *_headView;
    CMRefreshTableHeaderView  *_footerView;
    CMRefreshTableHeaderView  *_leftView;
    CMRefreshTableHeaderView  *_rightView;
    
    CMTableViewPullDirection   pullDirection;  // 拉动加载方向
    BOOL                       isRollingLoad;  // 是否滚动的时候加载
    
    MethodInterceptor          *_methodInterceptor;

    BOOL _reloading;
    UITableView *_tableView;
}

@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, assign) CMRefreshTableHeaderView  *headView;
@property (nonatomic, assign) CMRefreshTableHeaderView  *footerView;
@property (nonatomic, assign) CMRefreshTableHeaderView  *leftView;
@property (nonatomic, assign) CMRefreshTableHeaderView  *rightView;
@property (nonatomic, assign) id <UITableViewDataSource> dataSource;
@property (nonatomic, assign) id <UITableViewDelegate> delegate;
@property (nonatomic, assign) id <CMRefreshTableViewDelegate> refreshDataDelegate;

/**
 *  需要上下拉加载的创建实例方法
 *
 *  @param frame       frame description
 *  @param cmDirection 支持的方向，上，下
 *
 *  @return 实例
 */
- (id)initWithFrame:(CGRect)frame pullDirection:(CMTableViewPullDirection) cmDirection;

/**
 * 获取行对应的数据
 * @param frame
 * @returns 创建实例
 */
- (id)initWithFrame:(CGRect)frame rollingLoad:(BOOL)load;

/**
 *  刷新tableView
 */
-(void)reloadData;

/**
 *  如果需要手动调用刷新，可使用次方法
 */
-(void)startManualRefresh;

/**
 *  上下拉联网完成后调用，结束动画并隐藏
 */
- (void)refreshDone;

/**
 * 计算每个section的正显示行的范围
 * @param indexPaths 正在显示的行索引集合
 * @returns 字典{section:NSRange}
 */
- (NSDictionary *)_visibleRangeOfSectionWithVisibleIndexPaths:(NSArray *)indexPaths;

@end
