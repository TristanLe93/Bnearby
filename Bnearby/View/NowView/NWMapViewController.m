//
//  NWMapViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 15/10/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "NWMapViewController.h"
#import "MapViewAnnotation.h"
#import "DEViewController.h"


@interface NWMapViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *plannedEvents;
@property (strong, nonatomic) BNEvent *tappedPinEvent;
@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineView *routeLineView; //overlay view
@end

@implementation NWMapViewController

@synthesize plannedEvents;
@synthesize expandedMap;
@synthesize tappedPinEvent;

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
    
    // setup managedcontext
    BnearbyAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);       // fail
    }
    
    expandedMap.delegate = self;
    
    [self getPlannedEvents];
    [self placePins];
    
//    //initialize your map view and add it to your view hierarchy - **set its delegate to self***
////    coordinateArray = [[NSMutableArray alloc] init];
//    CLLocationCoordinate2D  ctrpoint;
//    CLLocationCoordinate2D coordinateArray[self.plannedEvents.count + 1];
//    ctrpoint.latitude = self.locationManager.location.coordinate.latitude;
//    ctrpoint.longitude = self.locationManager.location.coordinate.longitude;
//    coordinateArray[0] = ctrpoint;
//    
//    for (int i = 0; i < plannedEvents.count; i++) {
//        BNEvent * event = [plannedEvents objectAtIndex:i];
//        ctrpoint.latitude = [event.latitude doubleValue];
//        ctrpoint.longitude =[event.longitude doubleValue];
//        coordinateArray[i + 1] = ctrpoint;
//    }
//    
//    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:plannedEvents.count + 1];
//    [expandedMap setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
//    
//    [expandedMap addOverlay:self.routeLine];
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

- (void)placePins {
    for (BNEvent* venue in plannedEvents) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [venue.latitude doubleValue];
        coordinate.longitude = [venue.longitude doubleValue];

        // Add the annotation to our map view
        MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:[NSString stringWithFormat:@"%@", venue.title] andCoordinate:coordinate];
        newAnnotation.event = venue;
        [expandedMap addAnnotation:newAnnotation];
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc]     initWithAnnotation:annotation reuseIdentifier:@"pinLocation"];
    newAnnotation.canShowCallout = YES;
    newAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return newAnnotation;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    MapViewAnnotation *pin = view.annotation;
    tappedPinEvent = pin.event;
    [self performSegueWithIdentifier:@"mapToDetailsSegue" sender:self];
}

//-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
//    if(overlay == self.routeLine) {
//        if(nil == self.routeLineView) {
//            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
//            self.routeLineView.fillColor = [UIColor redColor];
//            self.routeLineView.strokeColor = [UIColor redColor];
//            self.routeLineView.lineWidth = 5;
//        }
//        return self.routeLineView;
//    }
//    return nil;
//}

- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BNEvent" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc]
                                                               initWithFetchRequest:fetchRequest
                                                               managedObjectContext:context
                                                               sectionNameKeyPath:nil
                                                               cacheName:@"Root"];
    
    fetchedResultsController = theFetchedResultsController;
    return theFetchedResultsController;
}

- (void)getPlannedEvents {
    NSMutableArray *planned = [[NSMutableArray alloc] init];
    NSInteger numbRows = 0;
    for (int j = 0; j < fetchedResultsController.sections.count; j++) {
        id sectionInfo = [[fetchedResultsController sections] objectAtIndex:j];
        NSInteger count = [sectionInfo numberOfObjects];
        numbRows = numbRows + count;
    }
    if (numbRows > 0) {
        for (int i = 0; i < numbRows; i++) {
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
            BNEvent *event = [fetchedResultsController objectAtIndexPath:indexPath2];
            
            if (event.date != nil) {
                NSDate *now = [NSDate date];
                NSDate *endDate = [self dateAtEndOfDayForDate:now];
                
                if (event.date != nil && [self date:event.date isBetweenDate:now andDate:endDate]) {
                    [planned addObject:event];
                }
            }
        }
        if (planned.count > 0) {
            NSArray* reversedArray = [[planned reverseObjectEnumerator] allObjects];
            plannedEvents = [[NSArray alloc] initWithArray:reversedArray];
        }
    }
    
    //    plannedEvents = [planned sortedArrayUsingSelector:@selector(compare:)];
}

- (NSDate *)dateAtEndOfDayForDate:(NSDate *)inputDate {
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:23];
    [dateComps setMinute:59];
    [dateComps setSecond:59];
    
    // Convert back
    NSDate *endOfDay = [calendar dateFromComponents:dateComps];
    return endOfDay;
}

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate {
    if ([date compare:beginDate] == NSOrderedAscending) {
    	return NO;
    }
    if ([date compare:endDate] == NSOrderedDescending) {
    	return NO;
    }
    return YES;
}

- (IBAction)findMeButton:(id)sender {
    [self startUpdatingCurrentLocation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"mapToDetailsSegue"]) {
        // Get reference to the destination view controller
        
        DEViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.event = tappedPinEvent;
        vc.type = @1;
    }
}

@end
