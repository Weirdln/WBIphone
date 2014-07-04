//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"


#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
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
		layer.contents = (id)[UIImage imageNamed:@"EGORefresh.bundle/whiteArrow"].CGImage;
		
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
		
		
		[self setState:EGOOPullRefreshNormal];
    }
	
    return self;
}

- (void)adjustPosition
{
    CGSize size = _scrollView.frame.size;
    CGPoint center = CGPointZero;
    
    switch (_orientation)
    {
        case EGOPullOrientationDown:
            center = CGPointMake(size.width/2, 0.0f-size.height/2);
            break;
        case EGOPullOrientationUp:
            center = CGPointMake(size.width/2, _scrollView.contentSize.height+size.height/2);
            break;
        case EGOPullOrientationRight:
            center = CGPointMake(0.0f-size.width/2, size.height/2);
            break;
        case EGOPullOrientationLeft:
            center = CGPointMake(_scrollView.contentSize.width+size.width/2, size.height/2);
            break;
        default:
            break;
    }
    
    self.center = center;
}

- (id)initWithScrollView:(UIScrollView* )scrollView orientation:(EGOPullOrientation)orientation
{
    CGSize size = scrollView.frame.size;
    CGPoint center = CGPointZero;
    CGFloat degrees = 0.0f;
    
    _orientation = orientation;
    _scrollView = scrollView;
    
    switch (orientation)
    {
        case EGOPullOrientationDown:
            center = CGPointMake(size.width/2, 0.0f-size.height/2);
            degrees = 0.0f;
            break;
        case EGOPullOrientationUp:
            center = CGPointMake(size.width/2, scrollView.contentSize.height+size.height/2);
            degrees = 180.0f;
            break;
        case EGOPullOrientationRight:
            center = CGPointMake(0.0f-size.width/2, size.height/2);
            size = CGSizeMake(size.height, size.width);
            degrees = -90.0f;
            break;
        case EGOPullOrientationLeft:
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
        if (EGOPullOrientationUp == _orientation)
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
        
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	}
    else
    {
		_lastUpdatedLabel.text = nil;
	}
}

- (void)setState:(EGOPullRefreshState)aState
{
    BOOL refresh = (_orientation == EGOPullOrientationDown||_orientation == EGOPullOrientationRight);
    
	switch (aState)
    {
		case EGOOPullRefreshPulling:
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
		case EGOOPullRefreshNormal:
			if (_state == EGOOPullRefreshPulling) {
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
		case EGOOPullRefreshLoading:
            if (refresh) {
                _statusLabel.text = NSLocalizedString(@"正在刷新...", @"");
            } else {
                _statusLabel.text = NSLocalizedString(@"正在加载...", @"");
            }			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			break;
        case EGOOPullRefreshEnd:
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
	if (_state == EGOOPullRefreshLoading)
    {
        switch (_orientation)
        {
            case EGOPullOrientationDown:
            {
                CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
                offset = MIN(offset, 65);
                scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
                break;
            }
            case EGOPullOrientationUp:
            {
                CGFloat offset = MAX(scrollView.frame.size.height+scrollView.contentOffset.y-scrollView.contentSize.height, 0);
                offset = MIN(offset, 65);
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, offset, 0.0f);
                break;
            }
            case EGOPullOrientationRight:
            {
                CGFloat offset = MAX(scrollView.contentOffset.x * -1, 0);
                offset = MIN(offset, 65);
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, offset, 0.0f, 0.0f);
                break;
            }
            case EGOPullOrientationLeft:
            {
                CGFloat offset = MAX(scrollView.frame.size.width+scrollView.contentOffset.x-scrollView.contentSize.width, 0);
                offset = MIN(offset, 65);
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
            case EGOPullOrientationDown:
            {
                pullingCondition = (scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f);
                normalCondition = (scrollView.contentOffset.y < -65.0f);
                break;
            }
            case EGOPullOrientationUp:
            {
                CGFloat y = scrollView.contentOffset.y+scrollView.frame.size.height;
                pullingCondition = ((y < (scrollView.contentSize.height+65.0f)) && (y > scrollView.contentSize.height));
                normalCondition = (y > (scrollView.contentSize.height+65.0f));
                break;
            }
            case EGOPullOrientationRight:
            {
                pullingCondition = (scrollView.contentOffset.x > -65.0f && scrollView.contentOffset.x < 0.0f);
                normalCondition = (scrollView.contentOffset.x < -65.0f);
                break;
            }
            case EGOPullOrientationLeft:
            {
                CGFloat x = scrollView.contentOffset.x+scrollView.frame.size.width;
                pullingCondition = ((x < (scrollView.contentSize.width+65.0f)) && (x > scrollView.contentSize.width));
                normalCondition = (x > (scrollView.contentSize.width+65.0f));
                break;
            }
            default:
                break;
        }
        
		if (_state == EGOOPullRefreshPulling && pullingCondition && !_loading)
        {
			[self setState:EGOOPullRefreshNormal];
		}
        else if (_state == EGOOPullRefreshNormal && normalCondition && !_loading)
        {
			[self setState:EGOOPullRefreshPulling];
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
        case EGOPullOrientationDown:
        {
            condition = (scrollView.contentOffset.y <= - 65.0f);
            insets = UIEdgeInsetsMake(65.0f, 0.0f, 0.0f, 0.0f);
            break;
        }
        case EGOPullOrientationUp:
        {
            CGFloat y = scrollView.contentOffset.y+scrollView.frame.size.height-scrollView.contentSize.height;
            condition = (y > 65.0f);
            insets = UIEdgeInsetsMake(0.0f, 0.0f, 65.0f, 0.0f);
            break;
        }
        case EGOPullOrientationRight:
        {
            condition = (scrollView.contentOffset.x <= - 65.0f);
            insets = UIEdgeInsetsMake(0.0f, 65.0f, 0.0f, 0.0f);
            break;
        }
        case EGOPullOrientationLeft:
        {
            CGFloat x = scrollView.contentOffset.x+scrollView.frame.size.width-scrollView.contentSize.width;
            condition = (x > 65.0f);
            insets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 65.0f);
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
        
		[self setState:EGOOPullRefreshLoading];
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
	[self setState:EGOOPullRefreshNormal];
    
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
