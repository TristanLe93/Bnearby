//
//  MTScrollView.h
//  Prototype
//
//  Created by Lucas Michael Dilts on 26/08/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTView.h"

@interface MTScrollView : UIScrollView

@property (weak, nonatomic) IBOutlet MTView *myView;
@end
