//
//  EXEventView.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNEvent.h"


@interface EXEventView : UIView

//@property (strong, nonatomic) MTEvent *myEvent;

@property (weak, nonatomic) IBOutletCollection(UIImageView) NSArray *myImages;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
//@property (weak, nonatomic) IBOutlet UIButton *myEventButton;
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSMutableArray *myEventButtons;

//- (MTEventButton *) newButton: (NSString*)withImage :(Event*)forEvent;

@end
