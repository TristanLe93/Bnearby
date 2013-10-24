//
//  EXViewController.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define kCLIENT_ID "M4RA3Z1F5HVI1YC43LBPADNFUDG4L4DBXSAFSZ0UKA2KNJXM"
#define kCLIENT_SECRET "4E2QRUE3LY4EET3NR0SAKZREL5PBWUP2EFWVTSLEKVYPC5BV"
#define baseurl "https://api.foursquare.com/v2/"
#define resourcePath "venues/explore?"

@interface EXViewController : UITableViewController <CLLocationManagerDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *context;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;

@end
