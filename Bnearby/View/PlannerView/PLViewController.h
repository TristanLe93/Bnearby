//
//  PLViewController.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *plannerEvents;
@property (strong, nonatomic) IBOutlet UIButton *menuBtn;

@end