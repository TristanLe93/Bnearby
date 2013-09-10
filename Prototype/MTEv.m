//
//  Event.m
//  TravelApp
//
//  Created by Tristan on 21/08/13.
//  Copyright (c) 2013 Tristan. All rights reserved.
//

#import "MTEv.h"

@implementation MTEv
@synthesize name, time, location, bannerImage;

- (id)init {
    if (self = [super init]) {
        name = @"Default Name";
        time = @"Default Time";
        location = @"Default Location";
        bannerImage = @"Explore_Kids.png";
    }
    
    return self;
}

- (id)initWithName:(NSString *)theName AndTime:(NSString *)theTime AndLocation:(NSString *)theLocation AndBanner:(NSString *)theBanner {
    if (self = [super init]) {
        self.name = theName;
        self.time = theTime;
        self.location = theLocation;
        self.bannerImage = theBanner;
    }
    
    return self;
}

@end
