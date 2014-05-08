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

#import "NsRefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
#define  RefreshViewHight 65.0f

@interface NsRefreshTableHeaderView (Private)
- (void) initControl;
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation NsRefreshTableHeaderView

@synthesize delegate=_delegate;
@synthesize direction = _direction;
@synthesize lastUpdatedLabel=_lastUpdatedLabel;
@synthesize statusLabel=_statusLabel;
- (id)initWithFrame:(CGRect)frame byDirection:(EGOPullRefreshDirection)direc{
    if (self = [super initWithFrame:frame]) {
        _direction = direc;
        [self initControl];    
    }
	
    return self;
	
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _direction = EGOOPullRefreshDown; //默认下拉刷新
	
       [self initControl];    
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters
- (void)initControl{
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = TEXT_COLOR;
    label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
    _lastUpdatedLabel=label;
    [label release];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:13.0f];
    label.textColor = TEXT_COLOR;
    label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    [self addSubview:label];
    _statusLabel=label;
    [label release];
    
    
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(25.0f, self.frame.size.height - 60.0f, 30.0f, 55.0f);
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    
    [[self layer] addSublayer:layer];
    _arrowImage=layer;
    
    
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.frame = CGRectMake(25.0f, self.frame.size.height - 38.0f, 20.0f, 20.0f);
    [self addSubview:view];
    _activityView = view;
    [view release];
    
    
    [self setState:EGOOPullRefreshNormal];    
}



- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
        [formatter setDateFormat:@"yyyy/MM/dd hh:mm a"];
		//[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新时间: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
        //拖动
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"释放即可刷新...", @"释放即可刷新");

			
            [CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];			
			break;
        //加载完成
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			//_statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
            switch (_direction) 
            {
                
            case EGOOPullRefreshUp:
                
                _statusLabel.text = NSLocalizedString(@"上拉即可更新...", @"上拉即可更新...");                        
                break;
                
            case EGOOPullRefreshDown:
                
                _statusLabel.text = NSLocalizedString(@"下拉即可更新...", @"下拉即可更新...");            
                break;
                
            } 
            
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
        //加载数据中
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"载入中...", @"更新状态");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
            
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

 


- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
        switch (_direction) {
                       
            case EGOOPullRefreshUp:
                       
                        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 120.0f, 0.0f);
                      
                     break;
                     
            case EGOOPullRefreshDown:
                    
                        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
                        
                        break;
                        
                }
		
	} 
    
    
    else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
        switch (_direction) {
                
                case EGOOPullRefreshUp:
                        
                        if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHight && scrollView.contentOffset.y > 0.0f && !_loading) {
                            
                            [self setState:EGOOPullRefreshNormal];
                            
                        } else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight  && !_loading) {
                            
                            [self setState:EGOOPullRefreshPulling];
                            
                        }
                        
                        break;
                       
                    
                        
                case EGOOPullRefreshDown:
                        
                       if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
                            
                            [self setState:EGOOPullRefreshNormal];
                            
                       } else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
                            
                            [self setState:EGOOPullRefreshPulling];
                            
                        }
                        
                        break;
                       
                }
                
    
        if ((scrollView.contentInset.top != 0)) {
            
            scrollView.contentInset = UIEdgeInsetsZero;
            
        }
                
//                if (scrollView.contentInset.bottom != 0||(scrollView.contentInset.top != 0)) {
//                    
//                    scrollView.contentInset = UIEdgeInsetsZero;
//                   
//                }
        

		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
    
    switch (_direction) 
    {
            
        case EGOOPullRefreshUp:
            
            if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight && !_loading) {
                
                
                if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:direction:)]) 
                {
                    
                    [_delegate egoRefreshTableHeaderDidTriggerRefresh:self direction:_direction];
                    
                }
                
                [self setState:EGOOPullRefreshLoading];
                
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];  
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
                [UIView commitAnimations];
                
                
            }
            
            break;
            
            
            
        case EGOOPullRefreshDown:
            
            if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
                
                if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:direction:)]) {
                    
                    [_delegate egoRefreshTableHeaderDidTriggerRefresh:self direction:_direction];
                    
                }
                
                [self setState:EGOOPullRefreshLoading];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
                [UIView commitAnimations];
                
            }
            
            break;
    }
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];

}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end




    
    
    
    
