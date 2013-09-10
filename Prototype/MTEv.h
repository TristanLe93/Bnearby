//
//  Event.h
//  TravelApp
//
//  Created by Tristan on 21/08/13.
//  Copyright (c) 2013 Tristan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MTEv : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *bannerImage;

- (id) initWithName:(NSString *)name AndTime:(NSString *)theTime AndLocation:(NSString *)theLocation AndBanner:(NSString *)theBanner;

@end
