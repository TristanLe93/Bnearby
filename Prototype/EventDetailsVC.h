//
//  EventDetailsVC.h
//  TravelApp
//
//  Created by Tristan on 21/08/13.
//  Copyright (c) 2013 Tristan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTEv.h"
#import "MTEvButton.h"

//<UITableViewDataSource, UITableViewDelegate>
@interface EventDetailsVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    MTEv *theEvent;
    MTEvButton *button;
}

@property (nonatomic, strong) MTEv *theEvent;
@property (weak, nonatomic) IBOutlet UIImageView *eventBanner;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *eventDetails;

//@property (strong, nonatomic) MTEvButton *recievedButton;
@property (strong, nonatomic) MTEv *receivedEvent;

@end
