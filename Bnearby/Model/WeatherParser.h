//
//  WeatherParser.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 13/10/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BnearbyAppDelegate.h"
#import "Weather.h"

@interface WeatherParser : NSObject <NSXMLParserDelegate> {
    BnearbyAppDelegate *app;
    Weather *weather;
    NSMutableString *currentElementValue;
}

- (id)initWeatherParser;

@end
