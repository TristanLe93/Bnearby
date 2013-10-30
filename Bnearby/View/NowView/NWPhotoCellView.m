//
//  NWPhotoCellView.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 25/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "NWPhotoCellView.h"
#import "NWTableViewController.h"

@interface NWPhotoCellView()
//@property (nonatomic, strong) NSArray *images;
@end

@implementation NWPhotoCellView
@synthesize images;
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
    NSMutableArray *interArray = [NSMutableArray arrayWithObjects:
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@", [images objectAtIndex:0]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@", [images objectAtIndex:1]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@", [images objectAtIndex:2]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@", [images objectAtIndex:3]]],
                       [UIImage imageNamed:[NSString stringWithFormat:@"%@", [images objectAtIndex:4]]],
                       nil];
    for (NSInteger i = 0; i < self.imageViews.count; i++) {
//        [[self.imageViews objectAtIndex:i] setImage:[interArray objectAtIndex:i]];
//        UIImageView *aux = [self.imageViews objectAtIndex:i];
//        aux.tag = i;
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:[NWTableViewController class] action:@selector(bannerTapped:)];
//        singleTap.numberOfTapsRequired = 1;
//        singleTap.numberOfTouchesRequired = 1;
//        [[self.imageViews objectAtIndex:i] addGestureRecognizer:singleTap];
//        [[self.imageViews objectAtIndex:i] setUserInteractionEnabled:YES];
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
