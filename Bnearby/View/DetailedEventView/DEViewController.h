//
//  DEViewController.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNEvent.h"

@interface DEViewController : UIViewController

@property (strong, nonatomic) NSDictionary *theVenue;
@property (strong, nonatomic) NSNumber *type;
@property (strong, nonatomic) BNEvent *event;


@end
