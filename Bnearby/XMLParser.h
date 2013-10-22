//
//  XMLParser.h
//  Bnearby
//
//  Created by Tristan on 20/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNEvent;

@interface XMLParser : NSObject <NSXMLParserDelegate> {
    NSManagedObjectContext *context;
}

@property (nonatomic, retain) NSMutableArray *events;

- (XMLParser *)initXMLParser;

@end
