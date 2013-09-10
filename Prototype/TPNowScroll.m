//
//  TPNowScroll.m
//  Prototype
//
//  Created by Lucas Michael Dilts on 31/08/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "TPNowScroll.h"

@implementation TPNowScroll

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.myScroller setScrollEnabled:YES];
        [self.myScroller setContentSize:(CGSizeMake(320, 1000))];
        
        [self addSubview:self.myScroller];
    }
    return self;
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
