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
#import "ILTranslucentView.h"

@interface DEViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *myScroller;
@property (weak, nonatomic) IBOutlet UIView *myDetailsView;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIView *summayView;
@property (weak, nonatomic) IBOutlet UIView *datesView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *additionalInfoView;
@end

@implementation DEViewController
@synthesize event;
@synthesize theVenue;
@synthesize type;
@synthesize myButton;
@synthesize myDetailsView;
@synthesize myImageView;
@synthesize myScroller;
@synthesize summayView;
@synthesize datesView;
@synthesize addressView;
@synthesize additionalInfoView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myScroller.contentSize = CGSizeMake(320, 583);
    
    ILTranslucentView *summayTlcView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 0, summayView.frame.size.width, summayView.frame.size.height)];
    summayTlcView.translucentAlpha = 0.8;
    summayTlcView.translucentStyle = UIBarStyleDefault;
    summayTlcView.translucentTintColor = [UIColor clearColor];
    summayTlcView.backgroundColor = [UIColor clearColor];
    
    ILTranslucentView *datesTlcView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 0, datesView.frame.size.width, datesView.frame.size.height)];
    datesTlcView.translucentAlpha = 0.8;
    datesTlcView.translucentStyle = UIBarStyleDefault;
    datesTlcView.translucentTintColor = [UIColor clearColor];
    datesTlcView.backgroundColor = [UIColor clearColor];
    
    ILTranslucentView *addressTlcView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 0, addressView.frame.size.width, addressView.frame.size.height)];
    addressTlcView.translucentAlpha = 0.8;
    addressTlcView.translucentStyle = UIBarStyleDefault;
    addressTlcView.translucentTintColor = [UIColor clearColor];
    addressTlcView.backgroundColor = [UIColor clearColor];
    
    ILTranslucentView *additionalInfoTlcView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 0, additionalInfoView.frame.size.width, additionalInfoView.frame.size.height)];
    additionalInfoTlcView.translucentAlpha = 0.8;
    additionalInfoTlcView.translucentStyle = UIBarStyleDefault;
    additionalInfoTlcView.translucentTintColor = [UIColor clearColor];
    additionalInfoTlcView.backgroundColor = [UIColor clearColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 320, 30))];
    
    UILabel *summary = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 320, 80))];
    UILabel *address = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 320, 21))];
    address.adjustsFontSizeToFitWidth = YES;
    address.numberOfLines = 2;
    UILabel *phone = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 320, 21))];
    UILabel *price = [[UILabel alloc] initWithFrame:(CGRectMake(0, 21, 320, 21))];
    UILabel *category = [[UILabel alloc] initWithFrame:(CGRectMake(0, 42, 320, 21))];
    UILabel *date = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 320, 21))];
   
    
//    [contentView addSubview:title];
    [summayTlcView addSubview:summary];
    [datesTlcView addSubview:date];
    [addressTlcView addSubview:address];
    [additionalInfoTlcView addSubview:phone];
    [additionalInfoTlcView addSubview:price];
    [additionalInfoTlcView addSubview:category];
    
    [summayView addSubview:summayTlcView];
    [datesView addSubview:datesTlcView];
    [addressView addSubview:addressTlcView];
    [additionalInfoView addSubview:additionalInfoTlcView];
    
//    [myDetailsView addSubview:contentView];
    
    switch ([type integerValue]) {
        case 1:
            NSLog(@"TYPE %@", type);
            //set core data information
            myImageView.frame = CGRectMake(0, 0, 320, 168);
            myImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", event.tileBanner]];

            
            
            title.text = event.title;
            
            summary.text = event.summary;
            if (event.date != nil) {
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear| NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:event.date];
                NSInteger day = [components day];
                NSInteger month = [components month];
                NSInteger year = [components year];
                NSInteger hour = [components hour];
                NSInteger minute = [components minute];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                NSString *monthName = [[df monthSymbols] objectAtIndex:month - 1];
                
                date.text = [NSString stringWithFormat:@"%d %@ %d, %d:%d", day, monthName, year, hour, minute];
            }
            else {
                date.text = @"This venue is not in the Planner";
            }
            address.text = event.address;
            phone.text = event.phonenumber;
            price.text = [NSString stringWithFormat:@"min %@ and max %@", event.minprice, event.maxprice];
            category.text = event.category;
            break;
            
        case 2:
            // set foursquare information
            myImageView.frame = CGRectMake(0, 0, 320, 168);
            myImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Loading_Variation_One.png"]];

            NSDictionary *location = [theVenue objectForKey:@"location"];
            NSString *venueAddress = [NSString stringWithFormat:@"%@, %@ %@ %@, %@", [location objectForKey:@"address"], [location objectForKey:@"city"], [location objectForKey:@"state"], [location objectForKey:@"postalCode"], [location objectForKey:@"country"]];
            
            NSDictionary *contact = [theVenue objectForKey:@"contact"];
            
            title.text = [theVenue objectForKey:@"name"];
            date.text = @"This venue is not in the Planner";
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

-(IBAction)cancelUnwindSegue:(UIStoryboardSegue *)segue {
    // When user taps cancel in the DESelectedEventViewConroller
    // Nothing needed here.
}

@end

