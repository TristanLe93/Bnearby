//
//  EXScrollView.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXEventView.h"

@interface EXScrollView : UIScrollView

@property (weak, nonatomic) IBOutlet EXEventView *myView;
@end

