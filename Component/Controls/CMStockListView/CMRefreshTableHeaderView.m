//
//  CMRefreshTableHeaderView.m
//  DzhIPhone
//
//  Created by Weirdln on 14-7-4.
//
//

#import "CMRefreshTableHeaderView.h"

@interface CMRefreshTableHeaderView ()
{
    float maxSizeFrameOrContent;        // ContentSize和Frame中height或者width的最大值
    float marginSizeFramePlusContent;   // Frame比ContentSize中height或者width的长的距离，如果Frame比较小，则取值为0
}

@end

@implementation CMRefreshTableHeaderView

@synthesize startOffset;
@synthesize clickHeight;
@synthesize arrowImage = _arrowImage;
@synthesize state = _state;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
        // 默认拖动65开始生效
        startOffset = clickHeight = 65.0f;
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
        
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"CMRefresh.bundle/whiteArrow"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		
		[self setState:CMPullRefreshNormal];
    }
	
    return self;
}

- (id)initWithScrollView:(UIScrollView* )scrollView orientation:(CMPullOrientation)orientation
{
    CGSize size = scrollView.frame.size;
    CGPoint center = CGPointZero;
    CGFloat degrees = 0.0f;
    
    _orientation = orientation;
    _scrollView = scrollView;
    
    switch (orientation)
    {
        case CMPullOrientationDown:
            center = CGPointMake(size.width/2, 0.0f-size.height/2);
            degrees = 0.0f;
            break;
        case CMPullOrientationUp:
            center = CGPointMake(size.width/2,scrollView.contentSize.height+size.height/2);
            degrees = 180.0f;
            break;
        case CMPullOrientationRight:
            center = CGPointMake(0.0f-size.width/2, size.height/2);
            size = CGSizeMake(size.height, size.width);
            degrees = -90.0f;
            break;
        case CMPullOrientationLeft:
            center = CGPointMake(scrollView.contentSize.width+size.width/2, size.height/2);
            size = CGSizeMake(size.height, size.width);
            degrees = 90.0f;
            break;
        default:
            break;
    }
    self = [self initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        self.transform = CGAffineTransformMakeRotation((degrees * M_PI) / 180.0f);
        self.center = center;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        if (CMPullOrientationUp == _orientation)
        {
            _lastUpdatedLabel.transform = CGAffineTransformMakeRotation((degrees * M_PI) / 180.0f);
            _statusLabel.transform = CGAffineTransformMakeRotation((degrees * M_PI) / 180.0f);
        }
        [scrollView addSubview:self];
    }
    return self;
}


#pragma mark - 动态调整
/**
 *  获取table视图最大高度
 *
 *  @return footer加载的位置
 */
-(float)maxSize
{
    return MAX(_scrollView.contentSize.height, _scrollView.frame.size.height);
}

-(float)marginSize
{
    return MAX(_scrollView.frame.size.height - _scrollView.contentSize.height, 0) ;
}

- (void)adjustPosition
{
    CGSize size = _scrollView.frame.size;
    CGPoint center = CGPointZero;
    
    maxSizeFrameOrContent = [self maxSize];
    marginSizeFramePlusContent = [self marginSize];
    
    switch (_orientation)
    {
        case CMPullOrientationDown:
            center = CGPointMake(size.width/2, 0.0f-size.height/2);
            break;
        case CMPullOrientationUp:
            if(_state == CMPullRefreshClickNormal || _state == CMPullRefreshClickLoading)
            {
                //调整尾部高度和控件位置
                self.frame = RectSetHeight(self.frame, clickHeight);
                center = CGPointMake(size.width/2, _scrollView.contentSize.height + clickHeight/2);
                
                _statusLabel.frame = RectSetY(_statusLabel.frame, (self.frame.size.height - 20.0)/2);
                _activityView.frame = RectSetY(_activityView.frame, (self.frame.size.height - 20.0)/2);
            }
            else if(_state == CMPullRefreshEnd)
            {
                center = CGPointMake(size.width/2, _scrollView.contentSize.height + self.frame.size.height/2);
            }
            else
            {
                center = CGPointMake(size.width/2, maxSizeFrameOrContent + size.height/2);
            }
            break;
        case CMPullOrientationRight:
            center = CGPointMake(0.0f-size.width/2, size.height/2);
            break;
        case CMPullOrientationLeft:
            center = CGPointMake(maxSizeFrameOrContent+size.width/2, size.height/2);
            break;
        default:
            break;
    }
    
    self.center = center;
}

#pragma mark Setters

- (void)refreshLastUpdatedDate
{
	if ([_delegate respondsToSelector:@selector(cmRefreshTableHeaderDataSourceLastUpdated:)])
    {
		NSDate *date = [_delegate cmRefreshTableHeaderDataSourceLastUpdated:self];
		date = date ? date : [NSDate date];
        
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
        
        NSString *dateString = [formatter stringFromDate:date];
        NSString *title = NSLocalizedString(@"今天", nil);
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date toDate:[NSDate date] options:0];
        int year = [components year];
        int month = [components month];
        int day = [components day];
        if (year == 0 && month == 0 && day < 3)
        {
            if (day == 0)
            {
                title = NSLocalizedString(@"今天",nil);
            }
            else if (day == 1)
            {
                title = NSLocalizedString(@"昨天",nil);
            }
            else if (day == 2)
            {
                title = NSLocalizedString(@"前天",nil);
            }
            formatter.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
            dateString = [formatter stringFromDate:date];
        }
        
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"最后更新", @""),dateString];
        
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"CMRefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
	}
    else
    {
		_lastUpdatedLabel.text = nil;
	}
}

- (void)setState:(CMPullRefreshState)aState
{
    BOOL refresh = (_orientation == CMPullOrientationDown||_orientation == CMPullOrientationRight);
    
	switch (aState)
    {
		case CMPullRefreshPulling:
            if (refresh) {
                _statusLabel.text = NSLocalizedString(@"释放刷新...", @"");
            } else {
                _statusLabel.text = NSLocalizedString(@"释放加载更多...", @"");
            }
			
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
		case CMPullRefreshNormal:
			if (_state == CMPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
            if (refresh) {
                _statusLabel.text = NSLocalizedString(@"下拉刷新...", @"");
            } else {
                _statusLabel.text = NSLocalizedString(@"上拉加载更多...", @"");
            }
			
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			break;
		case CMPullRefreshLoading:
            if (refresh) {
                _statusLabel.text = NSLocalizedString(@"正在刷新...", @"");
            } else {
                _statusLabel.text = NSLocalizedString(@"正在加载...", @"");
            }
            
            [_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			break;
        case CMPullRefreshClickNormal:
            _arrowImage.hidden = YES;
            _statusLabel.text = NSLocalizedString(@"更多...", @"");
            [_activityView stopAnimating];
            break;
        case CMPullRefreshClickLoading:
            _arrowImage.hidden = YES;
            _statusLabel.text = NSLocalizedString(@"正在加载...", @"");
            [_activityView startAnimating];
			break;
        case CMPullRefreshEnd:
            _arrowImage.hidden = YES;
            _statusLabel.text = NSLocalizedString(@"没有了...", @"");
            [_activityView stopAnimating];
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark - ScrollView Methods
- (void)cmRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    // 只需要处理  正在下拉、下拉达到释放刷新 两种情况（主要目的再两个状态之间切换）
    if (scrollView.isDragging && (_state == CMPullRefreshNormal || _state == CMPullRefreshPulling))
    {
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(cmRefreshTableHeaderDataSourceIsLoading:)])
        {
			_loading = [_delegate cmRefreshTableHeaderDataSourceIsLoading:self];
		}
        
        BOOL pullingCondition = NO;
        BOOL normalCondition = NO;
        switch (_orientation)
        {
            case CMPullOrientationDown:
            {
                pullingCondition = (scrollView.contentOffset.y > -startOffset && scrollView.contentOffset.y < 0.0f);
                normalCondition = (scrollView.contentOffset.y < -startOffset);
//                NSLog(@"_state = %d,pullingCondition = %d,normalCondition = %d,_loading = %d",_state,pullingCondition,normalCondition,_loading);
                break;
            }
            case CMPullOrientationUp:
            {
                CGFloat y = scrollView.contentOffset.y+scrollView.frame.size.height; // 当前滑动的最大距离
                pullingCondition = ((y < maxSizeFrameOrContent + startOffset) && (y > maxSizeFrameOrContent));
                normalCondition = (y > maxSizeFrameOrContent + startOffset);
                break;
            }
            case CMPullOrientationRight:
            {
                pullingCondition = (scrollView.contentOffset.x > -startOffset && scrollView.contentOffset.x < 0.0f);
                normalCondition = (scrollView.contentOffset.x < -startOffset);
                break;
            }
            case CMPullOrientationLeft:
            {
                CGFloat x = scrollView.contentOffset.x+scrollView.frame.size.width;
                pullingCondition = ((x < maxSizeFrameOrContent + startOffset) && (x > maxSizeFrameOrContent));
                normalCondition = (x > maxSizeFrameOrContent + startOffset);
                break;
            }
            default:
                break;
        }
        
		if (_state == CMPullRefreshPulling && pullingCondition && !_loading)
        {
			[self setState:CMPullRefreshNormal];
		}
        else if (_state == CMPullRefreshNormal && normalCondition && !_loading)
        {
			[self setState:CMPullRefreshPulling];
		}
	}
}

- (void)cmRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
	BOOL _loading = NO;  // 是否在刷新的状态，如果处于刷新状态则不需要再次调用
	if ([_delegate respondsToSelector:@selector(cmRefreshTableHeaderDataSourceIsLoading:)])
    {
		_loading = [_delegate cmRefreshTableHeaderDataSourceIsLoading:self];
	}
    
    BOOL condition = NO;
    UIEdgeInsets insets = scrollView.contentInset;
    switch (_orientation)
    {
        case CMPullOrientationDown:
        {
            condition = (scrollView.contentOffset.y <= - startOffset);
            insets = EdgeInsetSetTop(insets, startOffset);
            break;
        }
        case CMPullOrientationUp:
        {
            if(_state == CMPullRefreshClickNormal || _state == CMPullRefreshClickLoading)
                condition = (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height + clickHeight);
            else
                condition = (scrollView.contentOffset.y + scrollView.frame.size.height >= maxSizeFrameOrContent + startOffset);

            insets = EdgeInsetSetBottom(insets, marginSizeFramePlusContent + startOffset);
            break;
        }
        case CMPullOrientationRight:
        {
            condition = (scrollView.contentOffset.x <= - startOffset);
            insets = EdgeInsetSetLeft(insets, startOffset);
            break;
        }
        case CMPullOrientationLeft:
        {
            condition = (scrollView.contentOffset.x+scrollView.frame.size.width >= maxSizeFrameOrContent + startOffset);
            insets = EdgeInsetSetRight(insets, marginSizeFramePlusContent + startOffset);
            break;
        }
        default:
            break;
    }
    
	if (condition && !_loading && _state != CMPullRefreshEnd)
    {
        /* Set NO paging Disable */
        _pagingEnabled = scrollView.pagingEnabled;
        scrollView.pagingEnabled = NO;
        
        if(_state == CMPullRefreshClickNormal || _state == CMPullRefreshClickLoading)
        {
            [self setState:CMPullRefreshClickLoading];
        }
        else
        {
            [self setState:CMPullRefreshLoading];
            [UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
                scrollView.contentInset = insets;
            }];
        }
        
        if ([_delegate respondsToSelector:@selector(cmRefreshTableHeaderDidTriggerRefresh:pullDirection:)])
        {
			[_delegate cmRefreshTableHeaderDidTriggerRefresh:self pullDirection:_orientation];
		}
	}
}

- (void)cmRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
//    if(!_activityView.isAnimating) // 如果当前没有动画，不做处理
//        return;
    UIEdgeInsets insets = scrollView.contentInset;
    
    if(_state == CMPullRefreshClickNormal || _state == CMPullRefreshClickLoading)
    {
        [self setState:CMPullRefreshClickNormal];
        insets = EdgeInsetSetBottom(insets, clickHeight);
    }
    else if(_state == CMPullRefreshEnd && _orientation == CMPullOrientationUp && insets.bottom > 0 && insets.bottom == clickHeight)  // 如果是End状态并且是可以点击加载，在刷新以后需要重置
    {
        [self setState:CMPullRefreshClickNormal];
        insets = EdgeInsetSetBottom(insets, clickHeight);
    }
    else
    {
        [self setState:CMPullRefreshNormal];
        switch (_orientation)
        {
            case CMPullOrientationDown:
            {
                insets = EdgeInsetSetTop(insets, 0);
                break;
            }
            case CMPullOrientationUp:
            {
                insets = EdgeInsetSetBottom(insets, marginSizeFramePlusContent);
                break;
            }
            case CMPullOrientationRight:
            {
                insets = EdgeInsetSetLeft(insets, 0);
                break;
            }
            case CMPullOrientationLeft:
            {
                insets = EdgeInsetSetRight(insets, marginSizeFramePlusContent);
                break;
            }
            default:
                break;
        }
    }

    [UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
        [scrollView setContentInset:insets];
    }];
    scrollView.pagingEnabled = _pagingEnabled;
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}

@end

