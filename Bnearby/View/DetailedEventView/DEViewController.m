//
//  DEViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "DEViewController.h"
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
    
//    NSLog(@"%@", self.theVenue);
    
    switch ([type integerValue]) {
        case 1:{
            // From core data
            NSLog(@"type 1");
            NSLog(@"name: %@", event.title);
            
            myImageView.frame = CGRectMake(0, 0, 320, 168);
            myImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", event.tileBanner]];
            
            UILabel *title = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, myDetailsView.frame.size.width, 30))];
            UILabel *category = [[UILabel alloc] initWithFrame:(CGRectMake(0, 30, myDetailsView.frame.size.width, 21))];
            UILabel *summary = [[UILabel alloc] initWithFrame:(CGRectMake(0, 51, myDetailsView.frame.size.width, 80))];
            UILabel *address = [[UILabel alloc] initWithFrame:(CGRectMake(0, 131, myDetailsView.frame.size.width, 21))];
            UILabel *phone = [[UILabel alloc] initWithFrame:(CGRectMake(0, 152, myDetailsView.frame.size.width, 21))];
            UILabel *price = [[UILabel alloc] initWithFrame:(CGRectMake(0, 173, myDetailsView.frame.size.width, 21))];
            
//            [summary ]

//            myDetailsView.frame = CGRectMake(myDetailsView.frame.origin.x, myDetailsView.frame.origin.x, myDetailsView.frame.size.width, price.frame.origin.y + price.frame.size.height);
            
//            myScroller.frame = CGRectMake(myScroller.frame.origin.x, myScroller.frame.origin.y, myScroller.frame.size.width, myDetailsView.frame.origin.y + myDetailsView.frame.size.height);
            
            
            title.text = event.title;
            category.text = event.category;
            summary.text = event.summary;
            address.text = event.address;
            phone.text = event.phonenumber;
            price.text = [NSString stringWithFormat:@"min %@ and max %@", event.minprice, event.maxprice];

            [myDetailsView addSubview:title];
            [myDetailsView addSubview:category];
            [myDetailsView addSubview:summary];
            [myDetailsView addSubview:address];
            [myDetailsView addSubview:phone];
            [myDetailsView addSubview:price];
            
            
            break;}
            
        case 2:{
            // from foursquare
            NSLog(@"type 2");
            NSLog(@"name: %@", [theVenue objectForKey:@"name"]);
            
            myImageView.frame = CGRectMake(0, 0, 320, 168);
            myImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Loading_Variation_One.png"]];
            
            UILabel *title = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, myDetailsView.frame.size.width, 30))];
//            UILabel *category = [[UILabel alloc] initWithFrame:(CGRectMake(0, 30, myDetailsView.frame.size.width, 21))];
//            UILabel *summary = [[UILabel alloc] initWithFrame:(CGRectMake(0, 51, myDetailsView.frame.size.width, 80))];
            UILabel *address = [[UILabel alloc] initWithFrame:(CGRectMake(0, 131, myDetailsView.frame.size.width, 21))];
            UILabel *phone = [[UILabel alloc] initWithFrame:(CGRectMake(0, 152, myDetailsView.frame.size.width, 21))];
            UILabel *price = [[UILabel alloc] initWithFrame:(CGRectMake(0, 173, myDetailsView.frame.size.width, 21))];
            
//            myDetailsView.frame = CGRectMake(myDetailsView.frame.origin.x, myDetailsView.frame.origin.x, myDetailsView.frame.size.width, price.frame.origin.y + price.frame.size.height);
            
            NSDictionary *location = [theVenue objectForKey:@"location"];
            NSString *venueAddress = [NSString stringWithFormat:@"%@, %@ %@ %@, %@", [location objectForKey:@"address"], [location objectForKey:@"city"], [location objectForKey:@"state"], [location objectForKey:@"postalCode"], [location objectForKey:@"country"]];
            
            NSDictionary *contact = [theVenue objectForKey:@"contact"];
            
            title.text = [theVenue objectForKey:@"name"];
//            category.text = event.category;
//            summary.text = event.summary;
            address.text = [NSString stringWithFormat:@"%@", venueAddress];
            phone.text = [contact objectForKey:@"formattedPhone"];
//            price.text = [NSString stringWithFormat:@"min %@ and max %@", event.minprice, event.maxprice];
            
            [myDetailsView addSubview:title];
//            [myDetailsView addSubview:category];
//            [myDetailsView addSubview:summary];
            [myDetailsView addSubview:address];
            [myDetailsView addSubview:phone];
            [myDetailsView addSubview:price];
            
            
            break;}
        default:
            break;
    }
}


@end

