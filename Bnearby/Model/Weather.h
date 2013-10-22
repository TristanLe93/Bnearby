//
//  Weather.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 13/10/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Weather : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *currentTemperature;
@property (strong, nonatomic) NSString *minTemperature;
@property (strong, nonatomic) NSString *maxTemperature;
@property (readwrite, nonatomic) NSInteger icon;
@property (readwrite, nonatomic) NSInteger cityId;
@property (strong, nonatomic) NSString *description;

@end
