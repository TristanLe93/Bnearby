//
//  NWWeatherCell.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 12/10/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWWeatherCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailedWeatherLabel;

@end
