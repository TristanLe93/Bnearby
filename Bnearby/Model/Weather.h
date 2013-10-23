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
@property (readwrite, nonatomic) NSInteger currentTemperature;
@property (readwrite, nonatomic) NSInteger minTemperature;
@property (readwrite, nonatomic) NSInteger maxTemperature;
@property (strong, nonatomic) NSString *icon;
@property (readwrite, nonatomic) NSInteger cityId;
@property (strong, nonatomic) NSString *description;

@end
