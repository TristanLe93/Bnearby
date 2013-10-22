//
//  EXEventButton.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "EXEventButton.h"
#import "BNEvent.h"

@implementation EXEventButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initEventButton:(NSString *)withImage :(BNEvent*)forEvent {
    self = [super init];
    if (self) {
        self = [EXEventButton buttonWithType:UIButtonTypeCustom];
        [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", withImage]] forState:UIControlStateNormal];
        
        self.myEvent = forEvent;
        
        self.frame = CGRectMake(320.0, 0.0, 320.0, 168.0);
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
