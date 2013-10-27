//
//  DESelectedEventViewController.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 27/10/2013.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNEvent.h"

@interface DESelectedEventViewController : UIViewController {
    NSManagedObjectContext *context;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (weak, nonatomic) NSDictionary *theVenue;
@property (strong, nonatomic) BNEvent *event;
@property (weak, nonatomic) NSNumber *type;

- (IBAction)selectButtonPressed:(id)sender;

@end
