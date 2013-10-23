//
//  WeatherParser.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 13/10/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "WeatherParser.h"

@implementation WeatherParser

- (id)initWeatherParser {
    if (self == [super init]) {
        app = (BnearbyAppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"current"]) {
        app.listArray = [[NSMutableArray alloc] init];
        weather = [[Weather alloc] init];
        weather.cityId = [[attributeDict objectForKey:@"id"] integerValue];
    }
    else {
////        weather = [[Weather alloc] init];
////        weather.cityId = [[attributeDict objectForKey:@"id"] integerValue];
        if ([elementName isEqualToString:@"city"]) {
            weather.cityId = [[attributeDict objectForKey:@"id"] integerValue];
            weather.name = [attributeDict objectForKey:@"name"];
//            NSLog(@"id %d", weather.cityId);
//            NSLog(@"name %@", weather.name);
        }
        if ([elementName isEqualToString:@"temperature"]) {
            weather.currentTemperature = [[attributeDict objectForKey:@"value"] integerValue];
//            NSLog(@"weather %@", weather.currentTemperature);
            weather.maxTemperature = [[attributeDict objectForKey:@"max"] integerValue];
            weather.minTemperature = [[attributeDict objectForKey:@"min"] integerValue];
//            NSLog(@"weather %@", weather.currentTemperature);
        }
        if ([elementName isEqualToString:@"weather"]) {
            weather.description = [attributeDict objectForKey:@"value"];
            weather.icon = [attributeDict objectForKey:@"icon"];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentElementValue) {
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    } else {
//        NSLog(@"%@", string);
        [currentElementValue appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"current"]) {
        return;
    }
    if ([elementName isEqualToString:@"lastupdate"]) {
        [app.listArray addObject:weather];
        weather = nil;
    }
//    else {
////        [weather setValue:currentElementValue forKey:elementName];
////        currentElementValue = nil;
//    }
}

@end
