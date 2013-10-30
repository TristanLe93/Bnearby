//
//  NWTableViewController.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 24/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Social/Social.h>
#import "BnearbyAppDelegate.h"
#import "Weather.h"

@interface NWTableViewController : UITableViewController <MKMapViewDelegate, UIActionSheetDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *context;
}

@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

//@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (nonatomic) UIButton *WeatherBT;
@property (strong, nonatomic) BnearbyAppDelegate *app;
@property (strong, nonatomic) Weather *weather;
//- (IBAction)func:(id)sender;
//+ (void)bannerTapped:(UIGestureRecognizer *)gestureRecognizer;

@end
