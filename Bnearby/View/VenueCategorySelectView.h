//
//  VenueCategorySelectView.h
//  Bnearby
//
//  Created by Tristan on 27/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCLIENT_ID "M4RA3Z1F5HVI1YC43LBPADNFUDG4L4DBXSAFSZ0UKA2KNJXM"
#define kCLIENT_SECRET "4E2QRUE3LY4EET3NR0SAKZREL5PBWUP2EFWVTSLEKVYPC5BV"

@interface VenueCategorySelectView : UITableViewController {
    NSMutableDictionary *venueCategories;
}

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

@end
