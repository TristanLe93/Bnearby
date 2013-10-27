//
//  DESelectedEventViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 27/10/2013.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "DESelectedEventViewController.h"
#import "BnearbyAppDelegate.h"
#import "BNEvent.h"

@interface DESelectedEventViewController ()
@end

@implementation DESelectedEventViewController
@synthesize myDatePicker, theVenue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    BnearbyAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;
    
    NSDate *now = [NSDate date];
    [myDatePicker setDate:now animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// saves data
- (IBAction)selectButtonPressed:(id)sender {
    NSDate *date = [myDatePicker date];
    NSDictionary *location = [theVenue objectForKey:@"location"];
    NSDictionary *contact = [theVenue objectForKey:@"contact"];
    
    BNEvent *event = [NSEntityDescription insertNewObjectForEntityForName:@"BNEvent" inManagedObjectContext:context];
    
    //set data
    event.title = [theVenue objectForKey:@"name"];
    event.address = [self addressBuilder:location];
    event.date = date;
    event.phonenumber = [contact objectForKey:@"formattedPhone"];
    
    NSError *error;
    NSString *message;
    if (![context save:&error]) {
        message = @"Error: Venue was not able to save";
    } else {
        message = @"The venue was saved to Planner";
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Venue" message:message delegate:Nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [alert show];
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (NSMutableString *)addressBuilder:(NSDictionary *)location {
    NSMutableString *address = [[NSMutableString alloc] init];
    
    [address appendString:[location objectForKey:@"address"]];
    [address appendString:@", "];
    [address appendString:[location objectForKey:@"city"]];
    [address appendString:@" "];
    [address appendString:[location objectForKey:@"state"]];
    [address appendString:@" "];
    [address appendString:[location objectForKey:@"postalCode"]];
    [address appendString:@" "];
    [address appendString:[location objectForKey:@"country"]];
    
    return address;
}
/*
address;
@property (nonatomic, retain) NSString * bannerurl;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * idevent;
@property (nonatomic, retain) NSNumber * maxprice;
@property (nonatomic, retain) NSNumber * minprice;
@property (nonatomic, retain) NSString * phonenumber;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * sourceurl;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * tileBanner;
@property (nonatomic, retain) NSNumber * duration;
*/
@end
