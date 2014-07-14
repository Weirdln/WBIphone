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

#define timeOutTimeInterval .5  // 刷新超时时间

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

// data Load type
typedef enum {
    CMTableViewLoadType_Reload,           // 刷新
    CMTableViewLoadType_LoadMore,         // 加载更多
    CMTableViewLoadType_LoadRollRange,    // 加载当前滚动范围
    CMTableViewLoadType_PreLoad           // 预加载更多
}CMTableViewLoadType;

// Style
typedef enum {
    CMTableViewStyleNormal,                  // regular table view
    CMTableViewStyleRefresh             = (1 << 0),  // 只能下来刷新
    CMTableViewStyleLoad                = (1 << 1),  // 只能上拉加载
    CMTableViewStyleClickMore           = (1 << 2),  // 可以上拉或者点击加载
    CMTableViewStyleLoadRoll            = (1 << 3),                                             // 加载滚动范围
    CMTableViewStyleRefreshAndLoad      = (CMTableViewStyleRefresh | CMTableViewStyleLoad),     // 可同时下拉刷新和上拉加载
    CMTableViewStyleRefreshAndClickMore = (CMTableViewStyleRefresh | CMTableViewStyleClickMore) // 可同时下拉刷新和上拉或者点击加载
}CMTableViewStyle;


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
 *  加载当前滚动视图
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

#pragma mark - HeaderView相关属性统一设置
/**
 *  HeaderView相关属性统一设置
 */
@property (nonatomic, assign) UIImage *arrowImage;
//@property (nonatomic, assign) float startOffset; // 开始判断的偏移量
//@property (nonatomic, assign) float clickHeight;   // 点击加载更多行的高度



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
 *  根据风格生成对应模式的table
 *
 *  @param frame frame description
 *  @param cmStyle 提供的几种风格
 *
 *  @return 实例
 */
- (id)initWithFrame:(CGRect)frame cmStyle:(CMTableViewStyle)style;

/**
 *  刷新tableView
 */
-(void)reloadData;

/**
 *  如果需要手动调用刷新，可使用次方法
 */
-(void)startManualRefresh;

/**
 *  手动加载更多，（更多按钮）
 */
-(void)startManualLoad;

/**
 *  上下拉联网完成后调用，结束动画并隐藏
 */
- (void)refreshDone;

/**
 *  数据全部数据后调用此方法，就不能再使用上拉加载
 *  操作数据以后调用refreshDone里面会对该状态重置
 */
-(void)setHitTheEnd;

/**
 * 计算每个section的正显示行的范围
 * @param indexPaths 正在显示的行索引集合
 * @returns 字典{section:NSRange}
 */
- (NSDictionary *)_visibleRangeOfSectionWithVisibleIndexPaths:(NSArray *)indexPaths;

@end
