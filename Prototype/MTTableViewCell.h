//
//  MTTableViewCell.h
//  Prototype
//
//  Created by Lucas Michael Dilts on 26/08/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTScrollView.h"

@interface MTTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MTScrollView *myScrollView;

@end
