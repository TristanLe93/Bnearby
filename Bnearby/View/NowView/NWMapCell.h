//
//  NWMapCell.h
//  Bnearby
//
//  Created by Lucas Michael Dilts on 10/10/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NWMapCell : UITableViewCell

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
