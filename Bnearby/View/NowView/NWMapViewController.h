//
//  NWMapViewController.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 15/10/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BnearbyAppDelegate.h"
#import "BNEvent.h"

@interface NWMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *context;
}

@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet MKMapView *expandedMap;

- (IBAction)findMeButton:(id)sender;



@end
