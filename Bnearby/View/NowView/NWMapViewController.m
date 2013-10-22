//
//  NWMapViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 15/10/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "NWMapViewController.h"

@interface NWMapViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation NWMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    MKCoordinateRegion region = {{-27.4679, 153.0277}, {0.1f, 0.1f}};
    [self.expandedMap setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startUpdatingCurrentLocation {
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 2;
    }
    

    [self.locationManager startUpdatingLocation];
}

//Delegate method
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    CLLocation* location = [locations lastObject];
//    NSDate* eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (abs(howRecent) < 15.0) {
//        self.longLabel.text = [NSString stringWithFormat:@"%.4f",location.coordinate.longitude];
//        self.latLabel.text = [NSString stringWithFormat:@"%.4f",location.coordinate.latitude];
//    }
    
    MKCoordinateRegion region;
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;

    region.span.longitudeDelta = 0.007f;
    region.span.latitudeDelta = 0.007f;
    
    [self.expandedMap setRegion:region animated:YES];
    self.expandedMap.showsUserLocation = YES;
    [self stopUpdatingCurrentLocation];
}


- (void)stopUpdatingCurrentLocation
{
    [self.locationManager stopUpdatingLocation];
}

- (IBAction)findMeButton:(id)sender {
    [self startUpdatingCurrentLocation];
}

@end
