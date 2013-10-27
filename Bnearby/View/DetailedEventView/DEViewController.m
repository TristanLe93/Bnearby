//
//  DEViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "DEViewController.h"
#import "DESelectedEventViewController.h"
#import "BNEvent.h"

@interface DEViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *myScroller;
@property (weak, nonatomic) IBOutlet UIView *myDetailsView;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@end

@implementation DEViewController
@synthesize event;
@synthesize theVenue;
@synthesize type;
@synthesize myButton;
@synthesize myDetailsView;
@synthesize myImageView;
@synthesize myScroller;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *title = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, myDetailsView.frame.size.width, 30))];
    UILabel *category = [[UILabel alloc] initWithFrame:(CGRectMake(0, 30, myDetailsView.frame.size.width, 21))];
    UILabel *summary = [[UILabel alloc] initWithFrame:(CGRectMake(0, 51, myDetailsView.frame.size.width, 80))];
    UILabel *address = [[UILabel alloc] initWithFrame:(CGRectMake(0, 131, myDetailsView.frame.size.width, 21))];
    UILabel *phone = [[UILabel alloc] initWithFrame:(CGRectMake(0, 152, myDetailsView.frame.size.width, 21))];
    UILabel *price = [[UILabel alloc] initWithFrame:(CGRectMake(0, 173, myDetailsView.frame.size.width, 21))];
    
    [myDetailsView addSubview:title];
    [myDetailsView addSubview:category];
    [myDetailsView addSubview:summary];
    [myDetailsView addSubview:address];
    [myDetailsView addSubview:phone];
    [myDetailsView addSubview:price];
    
    switch ([type integerValue]) {
        case 1:
            NSLog(@"TYPE %@", type);
            //set core data information
            myImageView.frame = CGRectMake(0, 0, 320, 168);
            myImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", event.tileBanner]];

            title.text = event.title;
            category.text = event.category;
            summary.text = event.summary;
            address.text = event.address;
            phone.text = event.phonenumber;
            price.text = [NSString stringWithFormat:@"min %@ and max %@", event.minprice, event.maxprice];
            break;
            
        case 2:
            // set foursquare information
            myImageView.frame = CGRectMake(0, 0, 320, 168);
            myImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Loading_Variation_One.png"]];

            NSDictionary *location = [theVenue objectForKey:@"location"];
            NSString *venueAddress = [NSString stringWithFormat:@"%@, %@ %@ %@, %@", [location objectForKey:@"address"], [location objectForKey:@"city"], [location objectForKey:@"state"], [location objectForKey:@"postalCode"], [location objectForKey:@"country"]];
            
            NSDictionary *contact = [theVenue objectForKey:@"contact"];
            
            title.text = [theVenue objectForKey:@"name"];
            address.text = [NSString stringWithFormat:@"%@", venueAddress];
            phone.text = [contact objectForKey:@"formattedPhone"];
            break;
    
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"venueSaveSegue"] && theVenue != nil && [type isEqual:@2]) {
        DESelectedEventViewController *viewController = segue.destinationViewController;
        viewController.theVenue = theVenue;
        viewController.type = type;
    }
    if ([segue.identifier isEqualToString:@"venueSaveSegue"] && event != nil && [type isEqual:@1]) {
        DESelectedEventViewController *viewController = segue.destinationViewController;
        viewController.event = event;
        viewController.type = type;
    }
}

@end

