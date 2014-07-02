//
//  CMTableView.h
//  DzhIPhone
//
//  Created by Weirdln on 14-6-27.
//
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MethodInterceptor.h"

#define timeOutTimeInterval 2  // 刷新超时时间

// pull direction
typedef enum {
    CMTableViewDirectionNone,
    CMTableViewDirectionDown      = (1 << EGOPullOrientationDown),
    CMTableViewDirectionUp        = (1 << EGOPullOrientationUp),
    CMTableViewDirectionRight     = (1 << EGOPullOrientationRight),
    CMTableViewDirectionLeft      = (1 << EGOPullOrientationLeft),
    CMTableViewDirectionUpDown    = (CMTableViewDirectionUp | CMTableViewDirectionDown),
    CMTableViewDirectionRightLeft = (CMTableViewDirectionRight | CMTableViewDirectionLeft),
    CMTableViewDirectionAll       = (CMTableViewDirectionUp | CMTableViewDirectionDown | CMTableViewDirectionRight | CMTableViewDirectionLeft)
}CMTableViewDirection;

// pull type
typedef enum {
    CMTableViewPullTypeReload,           // 从新加载
    CMTableViewPullTypeLoadMore,         // 加载更多
    CMTableViewPreLoad                   // 预加载更多
}CMTableViewPullType;


// CMRefreshTableViewDelegate
@class CMTableView;
@protocol CMRefreshTableViewDelegate <NSObject>

@optional

- (BOOL)refreshTableViewReloadTableViewDataSource:(CMTableViewPullType)refreshType;

/**
 * 请求刷新数据
 * @param dataView
 * @param requestInfo 请求信息，集合项为RequestInfoData。
 */
- (void)refreshDataView:(CMTableView *)dataView withRequestInfo:(NSArray *)requestInfos;

@end



@interface CMTableView : UIView<EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    EGORefreshTableHeaderView  *_headView;
    EGORefreshTableHeaderView  *_footerView;
    EGORefreshTableHeaderView  *_leftView;
    EGORefreshTableHeaderView  *_rightView;
    
    CMTableViewDirection       pullDirection;  // 拉动加载方向
    BOOL                       isRollingLoad;  // 是否滚动的时候加载
    
    MethodInterceptor          *_methodInterceptor;

    BOOL _reloading;
    UITableView *_tableView;
}

@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, assign) EGORefreshTableHeaderView  *headView;
@property (nonatomic, assign) EGORefreshTableHeaderView  *footerView;
@property (nonatomic, assign) EGORefreshTableHeaderView  *leftView;
@property (nonatomic, assign) EGORefreshTableHeaderView  *rightView;
@property (nonatomic, assign) id<UITableViewDataSource> dataSource;
@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@property (nonatomic, assign) id<CMRefreshTableViewDelegate> refreshDataDelegate;

/**
 *  需要上下拉加载的创建实例方法
 *
 *  @param frame       frame description
 *  @param cmDirection 支持的方向，上，下
 *
 *  @return 实例
 */
- (id)initWithFrame:(CGRect)frame pullDirection:(CMTableViewDirection) cmDirection;

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
 *  上下拉联网完成后调用，结束动画并隐藏
 */
- (void)refreshDone;


#pragma mark - 滚动加载用
/**
 * 请求信息字典 {section:[RequestInfoData]}，必须设置
 */
@property (nonatomic, retain) NSMutableDictionary *requestInfoDataDic;

/**刷新数据间隔*/
@property (nonatomic) NSTimeInterval refreshInterval;

/**
 * 获取行对应的数据
 * @param indexPath
 * @returns 行情数据
 */
- (id)dataAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 删除指定行数据
 * @param indexPath 行索引
 */
- (void)removeDataAtIndexPath:(NSIndexPath *)indexPath;

/**
 * section下行的个数
 * @param section
 * @returns 行数
 */
- (NSUInteger)countForSection:(NSInteger)section;

/**
 * 刷新当前显示行的数据，会先进行是否可以刷新判断，判断成功则刷新，失败则不刷新。
 */
- (void)refreshCurrentVisibleRows;

/**
 * 强制刷新当前显示行的数据，不进行是否可以刷新判断。
 */
- (void)forceRefreshCurrentVisibleRows;

/**
 * 设置请求的总纪录数，行所对应的数据
 * @param totalCount
 * @param responseData 响应数据
 * @param infoData 请求信息对象
 */
- (void)setTotalCount:(NSInteger)totalCount responseData:(NSArray *)responseData withInfoData:(RequestInfoData *)infoData;

/**
 * 从本地文件中读取数据，数据读取完成以后会刷新表格
 */
- (void)loadDataFromFile;

/**
 * 将内存中的数据保存到本地文件中
 */
- (void)saveDataIntoFile;

/**
 * 删除保存数据的本地文件
 */
- (void)removeDiskData;

#pragma mark - 模版方法

/**
 * 判断某个请求信息对象在某段范围是否有未加载数据的行
 * @param range 检索范围
 * @param infoData 请求信息对象
 * @param position 第一个不存在数据行的索引
 * @returns 不存在YES，存在NO
 */
- (BOOL)isDataNotExistAtRange:(NSRange)range infoData:(RequestInfoData *)infoData position:(int *)position;

/**
 * 将数据映射到信息对象中
 * @param responseData 请求返回的数据
 * @param infoData 请求信息对象
 */
- (void)mappingData:(NSArray *)responseData intoInfoData:(RequestInfoData *)infoData;

/**
 * 从请求信息对象中获取索引对应的数据。
 * @param indexPath 行索引
 * @param infoData 请求信息对象
 * @returns 行情数据
 */
- (id)dataAtIndex:(NSInteger)index infoData:(RequestInfoData *)infoData;

/**
 * 从请求信息对象中删除索引对应的数据。
 * @param indexPath 行索引
 * @param infoData 请求信息对象
 */
- (void)removeDataAtIndex:(NSInteger)index infoData:(RequestInfoData *)infoData;


@end
