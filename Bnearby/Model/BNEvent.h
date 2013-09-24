//
//  BNEvent.h
//  Bnearby
//
//  Created by Tristan on 25/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BNEvent : NSManagedObject

@property (nonatomic, retain) NSString * bannerurl;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSNumber * idevent;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * phonenumber;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * sourceurl;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * minprice;
@property (nonatomic, retain) NSNumber * maxprice;

@end
