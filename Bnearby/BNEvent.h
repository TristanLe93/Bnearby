//
//  BNEvent.h
//  Bnearby
//
//  Created by Tristan on 20/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BNEvent : NSManagedObject

@property (nonatomic, retain) NSNumber * idevent;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * phonenumber;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * bannerurl;
@property (nonatomic, retain) NSString * eventsource;
@property (nonatomic, retain) NSString * sourceurl;

@end
