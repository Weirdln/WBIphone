//
//  CMStockListView.m
//  DzhIPhone
//
//  Created by Weirdln on 14-6-26.
//
//

#import "CMStockListView.h"

@interface CMStockListView()
{
    
}
@property (nonatomic) NSTimeInterval lastReqTime;
@property (nonatomic, retain) NSArray *pageableInfoDatas;

/**
 * 生成刷新当前正在显示的行所需要的2955请求信息
 * @param indexPaths 请求行的集合
 * @returns 请求信息集合，[RequestInfoData]
 */
- (NSArray *)_requestInfoForNeedRefreshRows:(NSArray *)indexPaths;

/**
 * 是否需要强制刷新当前显示的行
 * @param visibleRangeDic 每个section，可视行范围{section:NSRange}
 * @returns 强制刷新YES，否则NO
 */
- (BOOL)_isNeedForceRefreshWithVisibleRange:(NSDictionary *)visibleRangeDic;

/**
 * 生成需要强制刷新所需要的2955请求信息
 * @param visibleRangeDic 每个section，可视行范围{section:NSRange}
 * @returns 请求信息集合，[RequestInfoData]
 */
- (NSArray *)_requestInfoForForceRefreshWithVisibleRange:(NSDictionary *)visibleRangeDic;

/**
 * 判断是否能进行数据刷新,防止短时间多次进行数据请求
 * 1,当前正在滚动时，禁止数据刷新
 * 2,此次刷新时间距离上次刷新时间小于 刷新间隔/3 时,不能刷新。
 * @returns 可刷新YES，不可刷新NO
 */
- (BOOL)_isNeedRefresh;

/**
 * 刷新正在显示的行
 */
- (void)_refreshVisibleRows;

/**
 * 根据2955请求信息强制刷新数据
 * @param requestInfos 2955请求信息
 */
- (void)_foreceReqDataWithRequestInfo:(NSArray *)requestInfos;


@end

@implementation CMStockListView
@synthesize requestInfoDataDic = _requestInfoDataDic;
@synthesize refreshInterval = _refreshInterval;
@synthesize stockListReqDataDelegate;

- (void)setRequestInfoDataDic:(NSMutableDictionary *)requestInfoDataDic
{
    if(_requestInfoDataDic != requestInfoDataDic)
    {
        [_requestInfoDataDic release];
        _requestInfoDataDic                 = [requestInfoDataDic retain];
        
        //遍历字典，将需要进行分页的请求信息对象找出，加入可分页信息对象集合中
        NSMutableArray *pageable       = [NSMutableArray array];
        [requestInfoDataDic enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *value, BOOL *stop) {
            
            for (RequestInfoData *infoData in value)
            {
                if([infoData isPageable])
                {
                    [pageable addObject:infoData];
                }
            }
        }];
        self.pageableInfoDatas                = pageable;
    }
}

#pragma mark - 数据请求

- (void)_refreshVisibleRows
{
    _lastReqTime                    = [NSDate timeIntervalSinceReferenceDate];
    if([self.refreshDataDelegate respondsToSelector:@selector(refreshDataView:withRequestInfo:)])
    {
        NSArray *indexPaths         = [_tableView indexPathsForVisibleRows];
        [self.stockListReqDataDelegate refreshDataView:self withRequestInfo:[self _requestInfoForNeedRefreshRows:indexPaths]];
    }
}

- (void)_foreceReqDataWithRequestInfo:(NSArray *)requestInfos
{
    _lastReqTime                    = [NSDate timeIntervalSinceReferenceDate];
    if([self.refreshDataDelegate respondsToSelector:@selector(refreshDataView:withRequestInfo:)])
    {
        [self.stockListReqDataDelegate refreshDataView:self withRequestInfo:requestInfos];
    }
}

#pragma mark - 内部数据处理

- (NSArray *)_requestInfoForNeedRefreshRows:(NSArray *)indexPaths
{
    NSMutableArray *arr                         = [NSMutableArray array];
    @autoreleasepool
    {
        NSDictionary *visibleRangeDic           = [self _visibleRangeOfSectionWithVisibleIndexPaths:indexPaths];
        
        //每个section都需要刷新数据，防止第一次请求不到，后面此section再也不请求数据。
        [_requestInfoDataDic enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSArray *value, BOOL *stop) {
            
            for (RequestInfoData *config in value)
            {
                RequestInfoData *final          = [config copy];
                
                //可分页的，要设置起始位置，不可分页的起始位置为0
                if([config isPageable])
                {
                    NSRange visibleRowRange     = [[visibleRangeDic objectForKey:key] rangeValue];
                    //信息对象侦听的范围跟可视行范围有交集
                    if(NSIntersectionRange(visibleRowRange, config.range).length != 0)
                    {
                        NSInteger startPostion  = config.range.location;
                        
                        if(config.range.location < visibleRowRange.location)
                            startPostion        = visibleRowRange.location;
                        
                        //设置起始位置，进行优化，将起始位置向前移动最大请求数/4，减少向前滑动出现同样股票代码数据的概率
                        final.startPosition     = MAX(startPostion - final.maxReqCount*.25, final.range.location);
                    }
                }
                [arr addObject:final];
                [final release];
            }
        }];
    }
    return arr;
}

- (BOOL)_isNeedForceRefreshWithVisibleRange:(NSDictionary *)visibleRangeDic
{
    for (RequestInfoData *infoData in _pageableInfoDatas)
    {
        NSValue *value          = [visibleRangeDic objectForKey:@(infoData.section)];
        if(value)
        {
            NSRange range       = [value rangeValue];//整个section的可视行范围
            
            NSRange realRange   = NSIntersectionRange(range, infoData.range);
            
            if ([self isDataNotExistAtRange:realRange infoData:infoData position:NULL])//如果有任何行没有数据，则强制刷新
                return YES;
        }
    }
    return NO;
}

- (NSArray *)_requestInfoForForceRefreshWithVisibleRange:(NSDictionary *)visibleRangeDic
{
    NSMutableArray *arr                     = [NSMutableArray array];
    for (RequestInfoData *infoData in _pageableInfoDatas)
    {
        NSValue *value                      = [visibleRangeDic objectForKey:@(infoData.section)];
        if(value)
        {
            NSRange range                   = [value rangeValue];//整个section的可视行范围
            
            NSRange realRange               = NSIntersectionRange(range, infoData.range);
            
            int idx                         = 0;
            if ([self isDataNotExistAtRange:realRange infoData:infoData position:&idx])//如果有任何行没有数据，则加入请求队列
            {
                RequestInfoData *final      = [infoData copy];
                final.startPosition         = MAX(idx - final.maxReqCount*.25, final.range.location);
                //                CDebugLog(@"final:%@, final.startPosition:%d", final, final.startPosition);
                //                [[iToast makeText:[NSString stringWithFormat:@"final:%@, final.startPosition:%d", final, final.startPosition]] show];
                [arr addObject:final];
                [final release];
            }
        }
    }
    return arr;
}

- (BOOL)_isNeedRefresh
{
    if (_tableView.dragging || _tableView.decelerating)//如果正在滚动，则禁止刷新数据
        return NO;
    
    NSTimeInterval time     = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval interval = time - _lastReqTime;
    if(interval < self.refreshInterval/3)//如果上次请求时间（可能为滚动时的刷新）与当前请求时间的间隔小于 刷新间隔/3 则忽略此次请求
        return NO;
    else //如果上次请求时间（可能为滚动时的刷新）与当前请求时间的间隔大于等于 刷新间隔/3 则此次请求虽然间隔较短，但仍算有效
        return YES;
}

#pragma mark - 外部数据处理方法

- (void)refreshCurrentVisibleRows
{
    if([self _isNeedRefresh])
        [self _refreshVisibleRows];
}

- (void)forceRefreshCurrentVisibleRows
{
    [self _refreshVisibleRows];
}

- (void)setTotalCount:(NSInteger)totalCount responseData:(NSArray *)responseData withInfoData:(RequestInfoData *)infoData
{
    NSInteger section                   = infoData.section;
    NSRange range                       = infoData.range;
    NSArray *infos                      = [_requestInfoDataDic objectForKey:@(section)];
    for (RequestInfoData *requestInfo in infos)
    {
        if(NSEqualRanges(range, requestInfo.range))
        {
            requestInfo.totalCount      = totalCount;
            requestInfo.startPosition   = infoData.startPosition;
            
            [self mappingData:responseData intoInfoData:requestInfo];//进行数据映射
            
            break;
        }
    }
    [_tableView reloadData];
}

- (id)dataAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr        = [_requestInfoDataDic objectForKey:@(indexPath.section)];
    
    for (RequestInfoData *infoData in arr)
    {
        if(NSLocationInRange(indexPath.row, infoData.range))
        {
            int idx     = indexPath.row - infoData.range.location;
            return [self dataAtIndex:idx infoData:infoData];//查找对应数据
        }
    }
    return nil;
}

- (void)removeDataAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr        = [_requestInfoDataDic objectForKey:@(indexPath.section)];
    
    for (RequestInfoData *infoData in arr)
    {
        if(NSLocationInRange(indexPath.row, infoData.range))
        {
            int idx     = indexPath.row - infoData.range.location;
            
            [self removeDataAtIndex:idx infoData:infoData];
        }
    }
}

- (NSUInteger)countForSection:(NSInteger)section
{
    NSArray *arr        = [_requestInfoDataDic objectForKey:@(section)];
    NSUInteger count    = 0;
    
    for (RequestInfoData *infoData in arr)
    {
        if([infoData isPageable])
            count       += infoData.totalCount;
        else
            count       += [infoData.responseData count];
    }
    return count;
}

#pragma mark - 模版方法

- (BOOL)isDataNotExistAtRange:(NSRange)range infoData:(RequestInfoData *)infoData position:(int *)position
{
    for (int i = range.location; i < NSMaxRange(range); i++)
    {
        if([infoData.responseData objectForKey:@(i)] == nil)
        {
            if(*position)
                *position               = i;
            
            return YES;
        }
    }
    
    return NO;
}

- (void)mappingData:(NSArray *)responseData intoInfoData:(RequestInfoData *)infoData
{
    NSMutableDictionary *dic            = infoData.responseData;
    NSInteger startPosition             = infoData.startPosition;
    NSInteger maxReq                    = infoData.maxReqCount;
    
    [responseData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(idx < maxReq)//防止返回的数据超出最大请求个数
            [dic setObject:obj forKey:@(startPosition + idx)];//将数据设置到对应的位置
    }];
}

- (id)dataAtIndex:(NSInteger)index infoData:(RequestInfoData *)infoData
{
    return [infoData.responseData objectForKey:@(index)];
}

- (void)removeDataAtIndex:(NSInteger)index infoData:(RequestInfoData *)infoData
{
    [infoData.responseData removeObjectForKey:@(index)];
    
    NSMutableDictionary *dic    = [NSMutableDictionary dictionary];
    
    [infoData.responseData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSInteger p             = [key integerValue];
        if(p > index)
            [dic setObject:obj forKey:@(p - 1)];
        else
            [dic setObject:obj forKey:@(p)];
    }];
    
    infoData.responseData       = dic;
}

#pragma mark - 读写本地数据

- (void)loadDataFromFile
{
    [_requestInfoDataDic enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *arr, BOOL *stop) {
        for (RequestInfoData *infoData in arr)
        {
            [infoData loadDataFromFile];
        }
    }];
    [_tableView reloadData];
}

- (void)saveDataIntoFile
{
    [_requestInfoDataDic enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *arr, BOOL *stop) {
        for (RequestInfoData *infoData in arr)
        {
            [infoData saveDataIntoFile];
        }
    }];
}

- (void)removeDiskData
{
    [_requestInfoDataDic enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *arr, BOOL *stop) {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (RequestInfoData *infoData in arr)
        {
            [infoData removeDiskDataWithFileManager:fileManager];
        }
    }];
}


#pragma mark - UIScrollViewDelegate
- (void)_onEndScroll
{
    NSDictionary *visibleRangeDic = [self _visibleRangeOfSectionWithVisibleIndexPaths:[_tableView indexPathsForVisibleRows]];
    
    if([self _isNeedForceRefreshWithVisibleRange:visibleRangeDic])
    {
        CDebugLog(@"%s", __FUNCTION__);
        [self _foreceReqDataWithRequestInfo:[self _requestInfoForForceRefreshWithVisibleRange:visibleRangeDic]];
    }
}

@end
