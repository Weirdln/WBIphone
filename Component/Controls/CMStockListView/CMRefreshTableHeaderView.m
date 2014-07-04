//
//  CMRefreshTableHeaderView.m
//  DzhIPhone
//
//  Created by Weirdln on 14-7-4.
//
//

#import "CMRefreshTableHeaderView.h"


#define FLIP_ANIMATION_DURATION 0.18f


@interface CMRefreshTableHeaderView (Private)
{
    
}
- (void)setState:(CMPullRefreshState)aState;

@end

@implementation CMRefreshTableHeaderView

//@synthesize startOffset;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
//        // 默认拖动65开始生效
//        startOffset = 65.0f;
        
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

/**
 *  获取table视图最大高度
 *
 *  @return footer加载的位置
 */
-(float)maxSizeHeight
{
    return MAX(_scrollView.contentSize.height, _scrollView.frame.size.height);
}

-(float)maxSizeWidth
{
    return MAX(_scrollView.contentSize.width, _scrollView.frame.size.width);
}

- (void)adjustPosition
{
    CGSize size = _scrollView.frame.size;
    CGPoint center = CGPointZero;
    
    NSLog(@"contentheight = %f, height = %f",_scrollView.contentSize.height,_scrollView.frame.size.height);
    
    switch (_orientation)
    {
        case CMPullOrientationDown:
            center = CGPointMake(size.width/2, 0.0f-size.height/2);
            break;
        case CMPullOrientationUp:
            center = CGPointMake(size.width/2, [self maxSizeHeight] + size.height/2);
            break;
        case CMPullOrientationRight:
            center = CGPointMake(0.0f-size.width/2, size.height/2);
            break;
        case CMPullOrientationLeft:
            center = CGPointMake(_scrollView.contentSize.width+size.width/2, size.height/2);
            break;
        default:
            break;
    }
    
    self.center = center;
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
            center = CGPointMake(size.width/2,[self maxSizeHeight]+size.height/2);
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


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate
{
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)])
    {
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
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
        case CMPullRefreshEnd:
            _arrowImage.hidden = YES;
            [_activityView stopAnimating];
            _statusLabel.text = NSLocalizedString(@"没有了...", @"");
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark - ScrollView Methods
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    // 加载状态 ,只处理偏移量(拖动位置)，与拖动状态互斥
	if (_state == CMPullRefreshLoading)
    {
        switch (_orientation)
        {
            case CMPullOrientationDown:
            {
                CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
                offset = MIN(offset, startOffset);
                scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
                break;
            }
            case CMPullOrientationUp:
            {
                CGFloat offset = MAX(scrollView.frame.size.height+scrollView.contentOffset.y-scrollView.contentSize.height, 0);
                offset = MIN(offset, startOffset);
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
                break;
            }
            case CMPullOrientationRight:
            {
                CGFloat offset = MAX(scrollView.contentOffset.x * -1, 0);
                offset = MIN(offset, startOffset);
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, offset, 0.0f, 0.0f);
                break;
            }
            case CMPullOrientationLeft:
            {
                CGFloat offset = MAX(scrollView.frame.size.width+scrollView.contentOffset.x-scrollView.contentSize.width, 0);
                offset = MIN(offset, startOffset);
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, offset);
                break;
            }
            default:
                break;
        }
	}
    else if (scrollView.isDragging)
    {
        NSLog(@"scrollView.contentOffset.y = %f",scrollView.contentOffset.y);
        
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)])
        {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
        
        BOOL pullingCondition = NO;
        BOOL normalCondition = NO;
        switch (_orientation)
        {
            case CMPullOrientationDown:
            {
                pullingCondition = (scrollView.contentOffset.y > -startOffset && scrollView.contentOffset.y < 0.0f);
                normalCondition = (scrollView.contentOffset.y < -startOffset);
                break;
            }
            case CMPullOrientationUp:
            {
//                CGFloat y = scrollView.contentOffset.y+[self maxSizeHeight];
//                pullingCondition = ((y < ([self maxSizeHeight]+startOffset)) && (y > [self maxSizeHeight]));
//                normalCondition = (y > ([self maxSizeHeight]+startOffset));
                
                pullingCondition = ((scrollView.contentOffset.y + scrollView.frame.size.height < scrollView.contentSize.height + startOffset) && (scrollView.contentOffset.y > 0));
                normalCondition = scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height + startOffset;
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
                pullingCondition = ((x < (scrollView.contentSize.width+startOffset)) && (x > scrollView.contentSize.width));
                normalCondition = (x > (scrollView.contentSize.width+startOffset));
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

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
	BOOL _loading = NO;  // 是否在刷新的状态，如果处于刷新状态则不需要再次调用
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)])
    {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
    
    BOOL condition = NO;
    UIEdgeInsets insets = UIEdgeInsetsZero;
    switch (_orientation)
    {
        case CMPullOrientationDown:
        {
            condition = (scrollView.contentOffset.y <= - startOffset);
            insets = UIEdgeInsetsMake(startOffset, 0.0f, 0.0f, 0.0f);
            break;
        }
        case CMPullOrientationUp:
        {
            CGFloat y = scrollView.contentOffset.y+scrollView.frame.size.height-scrollView.contentSize.height;
            condition = (y > startOffset);
            insets = UIEdgeInsetsMake(0.0f, 0.0f, startOffset, 0.0f);
            break;
        }
        case CMPullOrientationRight:
        {
            condition = (scrollView.contentOffset.x <= - startOffset);
            insets = UIEdgeInsetsMake(0.0f, startOffset, 0.0f, 0.0f);
            break;
        }
        case CMPullOrientationLeft:
        {
            CGFloat x = scrollView.contentOffset.x+scrollView.frame.size.width-scrollView.contentSize.width;
            condition = (x > startOffset);
            insets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, startOffset);
            break;
        }
        default:
            break;
    }
    
	if (condition && !_loading)
    {
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:pullDirection:)])
        {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self pullDirection:_orientation];
		}
		
        /* Set NO paging Disable */
        _pagingEnabled = scrollView.pagingEnabled;
        scrollView.pagingEnabled = NO;
        
		[self setState:CMPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = insets;
		[UIView commitAnimations];
	}
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsZero];
	[UIView commitAnimations];
	scrollView.pagingEnabled = _pagingEnabled;
	[self setState:CMPullRefreshNormal];
    
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

