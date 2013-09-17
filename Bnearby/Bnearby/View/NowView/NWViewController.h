//
//  NWViewController.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWScrollView.h"

@interface NWViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet NWScrollView *myScroller;

@end
