//
//  CMDialogAndAlert.h
//  WBIphone
//
//  Created by Weirdln on 13-12-5.
//  Copyright (c) 2013年 Weirdln. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMDialogAndAlert : NSObject<UIAlertViewDelegate>

// 显示一个按钮的标题的提示框
+(void)setAlertMessage:(NSString*)str title:(NSString*)tit cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
// 直接返回选择对话框的按钮的index
+(int)setDialogTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
// 设置让对话框消失
+(void)setDialogSelectIndex:(int )index;
@end
