//
//  DEViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <dispatch/dispatch.h>

#import "DEViewController.h"
#import "BNEvent.h"

@implementation DEViewController
@synthesize theEvent, titleLabel, addressLabel, phoneLable, ratingLabel, typeLabel, priceLabel, sourceLabel, thumbnailImage;


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    titleLabel.text = theEvent.title;
    addressLabel.text = theEvent.address;
    phoneLable.text = theEvent.phonenumber;
    ratingLabel.text = [NSString stringWithFormat:@"Rating: %@/5", theEvent.rating];
    typeLabel.text = theEvent.type;
    priceLabel.text = [NSString stringWithFormat:@"Price: $%@ - $%@", theEvent.minprice, theEvent.maxprice];
    sourceLabel.text = [NSString stringWithFormat:@"Source: %@", theEvent.source];
    
    // perform async image download
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:theEvent.bannerurl];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                thumbnailImage.image = image;
            }
        });
    });
}

@end

