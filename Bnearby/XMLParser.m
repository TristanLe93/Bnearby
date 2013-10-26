//
//  XMLParser.m
//  Bnearby
//
//  Created by Tristan on 20/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "XMLParser.h"
#import "BnearbyAppDelegate.h"
#import "BNEvent.h"

@implementation XMLParser 
@synthesize events;

- (XMLParser *)initXMLParser {
    events = [[NSMutableArray alloc] init];
    
    BnearbyAppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    context = appDel.managedObjectContext;
    
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"event"]) {
        BNEvent *event = [NSEntityDescription insertNewObjectForEntityForName:@"BNEvent" inManagedObjectContext:context];
        
        // set all attributes to the event class
        for (id key in attributeDict) {
            if ([key isEqualToString:@"idevent"] || [key isEqualToString:@"rating"] ||
                [key isEqualToString:@"minprice"] || [key isEqualToString:@"maxprice"]) {
                // all integer values need to be converted to NSNumber before set
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                [f setNumberStyle:NSNumberFormatterDecimalStyle];
                
////                NSNumber *myNumber = [f numberFromString:key];
//                NSNumber *myNumber = [f numberFromString:[attributeDict valueForKey:key]];
//                [event setValue:myNumber forKey:key];
                
                if ([key isEqualToString:@"rating"]) {
                    NSDecimal inDecimal = [[attributeDict valueForKey:key] decimalValue];
                    NSDecimalNumber *inDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:inDecimal];
                    NSNumber *myNumber = inDecimalNumber;
                    [event setValue:myNumber forKey:key];
                }
                else {
                    NSNumber *myNumber = [f numberFromString:[attributeDict valueForKey:key]];
                    [event setValue:myNumber forKey:key];
                }
                
                
            } else {
                [event setValue:[attributeDict valueForKey:key] forKey:key];
            }
        }
        
        [events addObject:event];
        event = nil;
    }
}

@end
