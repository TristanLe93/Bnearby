//
//  MTTableViewCell.m
//  Prototype
//
//  Created by Lucas Michael Dilts on 26/08/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "MTTableViewCell.h"

@implementation MTTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
