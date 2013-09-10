//
//  MTEvButton.h
//  Prototype
//
//  Created by Lucas Michael Dilts on 31/08/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEv.h"

@interface MTEvButton : UIButton

@property (retain, nonatomic) MTEv *myEvent;

- (id) initEventButton: (NSString*)withImage :(id)forEvent;

@end
