//
//  CMDialogAndAlert.m
//  WBIphone
//
//  Created by Weirdln on 13-12-5.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import "CMDialogAndAlert.h"


@interface CMDialogAndAlert ()
{
    BOOL _isWaitingTap;                // 是否已选择
    int _alertViewRetValue;            // 点击的按钮的索引值
}
@property (nonatomic)  BOOL isWaitingTap;
@property (nonatomic)  int alertViewRetValue;
@property (nonatomic,retain)UIAlertView *tipsAlert;
@end

@implementation CMDialogAndAlert

static CMDialogAndAlert *_defaultDialog = nil;
@synthesize isWaitingTap = _isWaitingTap;
@synthesize alertViewRetValue = _alertViewRetValue;
@synthesize tipsAlert;

// 显示一个按钮的标题的提示框
+(void)setAlertMessage:(NSString*)str title:(NSString*)tit cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertView *tipsAlert=[[UIAlertView alloc]initWithTitle:tit message:str delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
	[tipsAlert show];
    [tipsAlert release];
}

// 直接返回选择对话框的按钮的index
+(int)setDialogTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    [[CMDialogAndAlert sharedDialog] setAlertTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    return [[CMDialogAndAlert sharedDialog] alertSelectIndex];
}

+(void)setDialogSelectIndex:(int)index
{
    [[CMDialogAndAlert sharedDialog].tipsAlert  dismissWithClickedButtonIndex:index animated:YES];
//    [[self sharedDialog].tipsAlert dismissWithIndex:index];
    [CMDialogAndAlert sharedDialog].alertViewRetValue = index;
    [CMDialogAndAlert sharedDialog].isWaitingTap = NO;
    NSLog(@"__%s___isWaitingTap:%d", __FUNCTION__,[CMDialogAndAlert sharedDialog].isWaitingTap);
    
//    [[CMDialogAndAlert sharedDialog].tipsAlert dismiss];
//    [[CMDialogAndAlert sharedDialog] CustomeAlertViewDismiss:nil index:index];
}

// 生成单例
+ (CMDialogAndAlert *)sharedDialog
{
    @synchronized(self)
    {
        if (_defaultDialog == nil)
        {
            _defaultDialog = [[CMDialogAndAlert alloc] init];
        }
        return _defaultDialog;
    }
}

// 根据输入生成对话框
- (void)setAlertTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];

//    CustomeAlertView *alert =[[CustomeAlertView alloc]initWithBtnTitleArray:[NSArray arrayWithObjects:cancelButtonTitle,otherButtonTitles, nil] widethArray:[NSArray arrayWithObjects:[NSNumber numberWithInt:120],[NSNumber numberWithInt:120] ,nil]];
   
    alert.delegate = self;
    self.tipsAlert = alert;
    [alert show];
    [alert release];
    _isWaitingTap = YES;
}

// 等待点击并返回点击按钮的索引
-(int)alertSelectIndex
{
    while (_isWaitingTap)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return _alertViewRetValue;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _alertViewRetValue = buttonIndex;  //选择的值
    _isWaitingTap = NO;                // 选择以后将isWaitingTap置为No,结束NSRunLoop
    NSLog(@"_isWaitingTap:%d", _isWaitingTap);
}


//-(void)CustomeAlertViewDismiss:(CustomeAlertView *) alertView index:(int)index
//{
//    _alertViewRetValue = index;  //选择的值
//    _isWaitingTap = NO;                // 选择以后将isWaitingTap置为No,结束NSRunLoop
//}

-(void)dealloc
{
    self.tipsAlert = nil;
    [super dealloc];
}


@end
