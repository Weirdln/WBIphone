//
//  WBDetailViewController.h
//  WBMaster
//
//  Created by Weirdln on 14-2-12.
//  Copyright (c) 2014年 Weirdln. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
