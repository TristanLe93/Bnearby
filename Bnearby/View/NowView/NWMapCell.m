//
//  NWMapCell.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 10/10/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "NWMapCell.h"

@implementation NWMapCell

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
