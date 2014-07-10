//
//  CMTableView.m
//  DzhIPhone
//
//  Created by Weirdln on 14-6-27.
//
//

#import "CMTableView.h"

@interface CMTableView ()


@end



@implementation CMTableView

@synthesize tableView  = _tableView;
@synthesize headView   = _headView;
@synthesize footerView = _footerView;
@synthesize rightView  = _rightView;
@synthesize leftView   = _leftView;
@synthesize dataSource = _dataSource;
@synthesize delegate   = _delegate;
@synthesize refreshDataDelegate;

-(void)dealloc
{
    [_methodInterceptor release];
    [_headView release];
    [_footerView release];
    [_rightView release];
    [_leftView release];
    
    self.delegate = nil;
    self.dataSource = nil;
    self.refreshDataDelegate = nil;
    
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame pullDirection:CMTableViewPullDirectionNone rollingLoad:NO];
}

- (id)initWithFrame:(CGRect)frame rollingLoad:(BOOL)load
{
    return [self initWithFrame:frame pullDirection:CMTableViewPullDirectionNone rollingLoad:load];
}

- (id)initWithFrame:(CGRect)frame pullDirection:(CMTableViewPullDirection) cmDirection
{
    return [self initWithFrame:frame pullDirection:cmDirection rollingLoad:NO];
}

// 下边提示条一直存在的初始化方法
- (id)initWithFrame:(CGRect)frame cmStyle:(CMTableViewStyle)style
{
    self = [self initWithFrame:frame pullDirection:CMTableViewPullDirectionUpDown rollingLoad:NO];
    if(self)
    {
        [_footerView setState:CMPullRefreshClickNormal];
        // 默认获取第一个cell的高度，如果取不到设默认值 65.0
        float heightOfFirstCell =[_tableView.delegate tableView:_tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        _footerView.clickHeight = heightOfFirstCell <= 0 ? 65.0f : heightOfFirstCell;
        _tableView.contentInset = EdgeInsetSetBottom(_tableView.contentInset, _footerView.clickHeight);
        
        
        UIButton *loadButton = [[UIButton alloc] initWithFrame:_footerView.bounds];
        loadButton.backgroundColor = [UIColor clearColor];
        [loadButton addTarget:self action:@selector(startManualLoad) forControlEvents:UIControlEventTouchDown];
        [_footerView addSubview:loadButton];
        [loadButton release];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame pullDirection:(CMTableViewPullDirection) cmDirection rollingLoad:(BOOL)load
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _methodInterceptor              = [[MethodInterceptor alloc] init];
        _methodInterceptor.intercept    = self;
        
        pullDirection = cmDirection;
        isRollingLoad = load;

        self.clipsToBounds = YES;
        _tableView          = [[UITableView alloc] initWithFrame:self.bounds];
        if (IOS_VERSION_7_OR_ABOVE)
        {
            if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])//ios7中UITableView的cell separator默认不是从最左边开始
            {
                [_tableView setSeparatorInset:UIEdgeInsetsZero];
            }
        }
        [self addSubview:_tableView];
        [_tableView release];
        
        if((cmDirection & (1 << CMPullOrientationDown)) >> CMPullOrientationDown)
        {
            // 头部，下拉时显示刷新
            _headView = [[CMRefreshTableHeaderView alloc] initWithScrollView:_tableView orientation:CMPullOrientationDown];
            _headView.backgroundColor = [UIColor purpleColor];
            _headView.delegate = self;
        }
        
        if((cmDirection & (1 << CMPullOrientationUp)) >> CMPullOrientationUp)
        {
            // 底部，上拉时加载更多
            _footerView = [[CMRefreshTableHeaderView alloc] initWithScrollView:_tableView orientation:CMPullOrientationUp];
            _footerView.backgroundColor = [UIColor cyanColor];
            _footerView.delegate = self;
        }
        
        if((cmDirection & (1 << CMPullOrientationRight)) >> CMPullOrientationRight)
        {
            // 左边，右拉时显示刷新
            _leftView = [[CMRefreshTableHeaderView alloc] initWithScrollView:_tableView orientation:CMPullOrientationRight];
            _leftView.backgroundColor = [UIColor magentaColor];
            _leftView.delegate = self;
        }
        
        if((cmDirection & (1 << CMPullOrientationLeft)) >> CMPullOrientationLeft)
        {
            // 右边，左拉时加载更多
            _rightView = [[CMRefreshTableHeaderView alloc] initWithScrollView:_tableView orientation:CMPullOrientationLeft];
            _rightView.backgroundColor = [UIColor brownColor];
            _rightView.delegate = self;
        }
        
        
        // tableView reload以后contentSize可能会发生变化，此时需要更新_headView
        [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    _tableView.backgroundColor = backgroundColor;
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    _tableView.dataSource = dataSource;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    _methodInterceptor.receiver = delegate;
    _tableView.delegate = (id)_methodInterceptor;
}

-(void)reloadData
{
    [_tableView reloadData];
}

- (void)refreshDone
{
    _reloading = NO;
    [self reloadData];

//    if(_tableView.contentOffset.y <= 0)
        [_headView cmRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
//    else if(_tableView.contentOffset.y >= 0)
        [_footerView cmRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
//    if(_tableView.contentOffset.x <= 0)
        [_rightView cmRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
//    else if(_tableView.contentOffset.x >= 0)
        [_leftView cmRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}

-(void)startManualRefresh
{
    _reloading = NO;
    [_headView setState:CMPullRefreshLoading];
    [_headView refreshLastUpdatedDate];
    [UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
        _tableView.contentInset = EdgeInsetSetTop(_tableView.contentInset, startOffset);
    }];
    [self cmRefreshTableHeaderDidTriggerRefresh:_headView pullDirection:CMPullOrientationDown];
}

-(void)startManualLoad
{
    _reloading = NO;
    [_footerView setState:CMPullRefreshClickLoading];
    [self cmRefreshTableHeaderDidTriggerRefresh:_footerView pullDirection:CMPullOrientationUp];
}


-(void)setHitTheEnd
{
    [_footerView setState:CMPullRefreshEnd];
    [_rightView setState:CMPullRefreshEnd];
}


/**
 *  调整header的freameWork
 */
-(void)adjustAllRefreshView
{
    [_headView adjustPosition];
    [_footerView adjustPosition];
    [_rightView adjustPosition];
    [_leftView adjustPosition];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(pullDirection != CMTableViewPullDirectionNone)
    {
        if(scrollView.contentOffset.y < 0)
            [_headView cmRefreshScrollViewDidScroll:scrollView];
        else if(scrollView.contentOffset.y > 0)
            [_footerView cmRefreshScrollViewDidScroll:scrollView];
        
        if(scrollView.contentOffset.x < 0)
            [_rightView cmRefreshScrollViewDidScroll:scrollView];
        else if(scrollView.contentOffset.x > 0)
            [_leftView cmRefreshScrollViewDidScroll:scrollView];
    }
    
    // 如果上层需要这个代理，则传递出去
    if([_methodInterceptor.receiver respondsToSelector:@selector(scrollViewDidScroll:)])
        [_methodInterceptor.receiver scrollViewDidScroll:scrollView];
}
 
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(pullDirection != CMTableViewPullDirectionNone)
    {
        if(scrollView.contentOffset.y < 0)
            [_headView cmRefreshScrollViewDidEndDragging:scrollView];
        else if(scrollView.contentOffset.y > 0)
            [_footerView cmRefreshScrollViewDidEndDragging:scrollView];
        
        if(scrollView.contentOffset.x < 0)
            [_rightView cmRefreshScrollViewDidEndDragging:scrollView];
        else if(scrollView.contentOffset.x > 0)
            [_leftView cmRefreshScrollViewDidEndDragging:scrollView];
    }
    else if(isRollingLoad)
    {
        if (!scrollView.dragging && !scrollView.decelerating)
        {
            CDebugLog(@"%s", __FUNCTION__);
            [self _onEndScroll];
        }
    }
    
    // 如果上层需要这个代理，则传递出去
    if([_methodInterceptor.receiver respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        [_methodInterceptor.receiver scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(isRollingLoad)
    {
        if (!scrollView.dragging && !scrollView.decelerating)
        {
            CDebugLog(@"%s", __FUNCTION__);
            [self _onEndScroll];
        }
    }
    
    // 如果上层需要这个代理，则传递出去
    if([_methodInterceptor.receiver respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        [_methodInterceptor.receiver scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - CMRefreshTableHeaderDelegate

- (void)cmRefreshTableHeaderDidTriggerRefresh:(CMRefreshTableHeaderView*)view pullDirection:(CMPullOrientation) cmDirection
{
    if(self.refreshDataDelegate != nil && [self.refreshDataDelegate respondsToSelector:@selector(refreshDataView:loadType:indexPath:)])
    {
        _reloading = YES;
        if(cmDirection == CMPullOrientationDown || cmDirection == CMPullOrientationRight)
        {
            NSIndexPath *zeroIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.refreshDataDelegate refreshDataView:self loadType:CMTableViewLoadType_Reload indexPath:zeroIndexPath];
        }
        else if(cmDirection == CMPullOrientationUp || cmDirection == CMPullOrientationLeft)
        {
            NSIndexPath *lastIndexPath = [[_tableView indexPathsForVisibleRows] lastObject];
            [self.refreshDataDelegate refreshDataView:self loadType:CMTableViewLoadType_LoadMore indexPath:lastIndexPath];
        }
    }
}

- (BOOL)cmRefreshTableHeaderDataSourceIsLoading:(CMRefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)cmRefreshTableHeaderDataSourceLastUpdated:(CMRefreshTableHeaderView*)view
{
    return [NSDate date];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self adjustAllRefreshView];
}


#pragma mark - 滚动加载相关

- (NSDictionary *)_visibleRangeOfSectionWithVisibleIndexPaths:(NSArray *)indexPaths
{
    int section                 = -1;
    NSMutableDictionary *dic    = [NSMutableDictionary dictionary];
    NSRange range               = {0,0};
    
    for (NSIndexPath *indexPath in indexPaths)
    {
        if(section != indexPath.section)
        {
            if(range.length != 0)//保存上一个section的可视行索引范围
            {
                [dic setObject:[NSValue valueWithRange:range] forKey:@(section)];
                range.length    = 0;
            }
            
            section             = indexPath.section;
            range.location      = indexPath.row;
            range.length        = 1;
        }
        else
        {
            range.length        = range.length + 1;
        }
    }
    
    if(range.length != 0)
        [dic setObject:[NSValue valueWithRange:range] forKey:@(section)];
    
    return dic;
}

/**
 *  滚动结束，开始判断是否发送请求
 */
-(void)_onEndScroll
{
    if([self.refreshDataDelegate respondsToSelector:@selector(refreshDataView:visibleRange:)])
    {
        NSDictionary *visibleRangeDic = [self _visibleRangeOfSectionWithVisibleIndexPaths:[_tableView indexPathsForVisibleRows]];
        [self.refreshDataDelegate refreshDataView:self visibleRange:visibleRangeDic];
    }
}



@end
