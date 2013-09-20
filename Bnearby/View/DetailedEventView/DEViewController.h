//
//  DEViewController.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BNEvent.h"
//#import "MTEvButton.h" // ?

//<UITableViewDataSource, UITableViewDelegate>
@interface DEViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    BNEvent *theEvent;
    //BNEventButton *button;
}

@property (nonatomic, strong) BNEvent *theEvent;
@property (weak, nonatomic) IBOutlet UIImageView *eventBanner;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *eventDetails;

//@property (strong, nonatomic) MTEvButton *recievedButton;
@property (strong, nonatomic) BNEvent *receivedEvent;

@end
