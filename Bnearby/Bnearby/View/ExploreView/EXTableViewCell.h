//
//  EXTableViewCell.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EXScrollView.h"

@interface EXTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet EXScrollView *myScrollView;

@end
