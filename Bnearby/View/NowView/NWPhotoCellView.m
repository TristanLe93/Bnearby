//
//  NWPhotoCellView.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 25/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "NWPhotoCellView.h"

@interface NWPhotoCellView()
@property (nonatomic, strong) NSArray *images;
@end

@implementation NWPhotoCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    self.images = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"Loading_Variation_One.png"],
                       [UIImage imageNamed:@"Loading_Variation_One.png"],
                       [UIImage imageNamed:@"Loading_Variation_One.png"],
                       [UIImage imageNamed:@"Loading_Variation_One.png"],
                       [UIImage imageNamed:@"Loading_Variation_One.png"],
                       nil];
    for (NSInteger i = 0; i < self.imageViews.count; i++) {
        [[self.imageViews objectAtIndex:i] setImage:[self.images objectAtIndex:i]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
