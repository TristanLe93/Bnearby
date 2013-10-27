//
//  DESelectedEventViewController.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 27/10/2013.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DESelectedEventViewController : UIViewController {
    NSManagedObjectContext *context;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (weak, nonatomic) NSDictionary *theVenue;

- (IBAction)selectButtonPressed:(id)sender;

@end
