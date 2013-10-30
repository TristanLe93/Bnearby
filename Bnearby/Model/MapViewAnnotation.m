//
//  MapViewAnnotation.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 30/10/2013.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title, coordinate, event;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
//	[super init];
	title = ttl;
	coordinate = c2d;
	return self;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title {
    return [NSString stringWithFormat:@"%@", event.title];
}

// optional
- (NSString *)subtitle {
    return [NSString stringWithFormat:@"%@", event.address];
    
}

@end
