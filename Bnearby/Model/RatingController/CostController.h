//
//  CostController.h
//  Prototype
//
//  Created by Lucas Michael Dilts on 29/08/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CostRatingDelegate;

@interface CostController : UIControl

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame andStars:(NSUInteger)_numberOfStars;

@property (strong) UIImage *star;
@property (strong) UIImage *highlightedStar;
@property (assign) NSUInteger rating;
@property (weak) IBOutlet NSObject<CostRatingDelegate> *delegate;

@end

@protocol CostRatingDelegate

@optional
- (void)costRatingControl:(CostController *)control didUpdateRating:(NSUInteger)rating;
- (void)costRatingControl:(CostController *)control willUpdateRating:(NSUInteger)rating;

@end