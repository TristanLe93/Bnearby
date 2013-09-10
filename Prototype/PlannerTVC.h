//
//  PlannerTVC.h
//  TravelApp
//
//  Created by Tristan on 21/08/13.
//  Copyright (c) 2013 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlannerTVC : UITableViewController

@property (strong, nonatomic) NSMutableArray *plannerEvents;
@property (strong, nonatomic) IBOutlet UIButton *menuBtn;

@end
