//
//  TimeController.h
//  Prototype
//
//  Created by Lucas Michael Dilts on 29/08/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeRatingDelegate;

@interface TimeController : UIControl

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame andStars:(NSUInteger)_numberOfStars;

@property (strong) UIImage *star;
@property (strong) UIImage *highlightedStar;
@property (assign) NSUInteger rating;
@property (weak) IBOutlet NSObject<TimeRatingDelegate> *delegate;

@end

@protocol TimeRatingDelegate

@optional
- (void)timeRatingControl:(TimeController *)control didUpdateRating:(NSUInteger)rating;
- (void)timeRatingControl:(TimeController *)control willUpdateRating:(NSUInteger)rating;

@end