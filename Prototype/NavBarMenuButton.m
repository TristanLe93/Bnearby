//
//  NavBarMenuButton.m
//  Prototype
//
//  Created by Lucas Michael Dilts on 30/08/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "NavBarMenuButton.h"

@implementation NavBarMenuButton

-(id)initButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame= CGRectMake(0.0, 0.0, 34, 24);
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 34, 24) ];
    [view addSubview:button];
    self = [[NavBarMenuButton alloc] initWithCustomView:view];
    
    return self;
}

@end
