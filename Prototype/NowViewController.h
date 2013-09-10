//
//  NowViewController.h
//  Prototype
//
//  Created by Lucas Michael Dilts on 30/08/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTNowScrollView.h"

@interface NowViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet MTNowScrollView *myScroller;

@end
