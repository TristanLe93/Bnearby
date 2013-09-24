//
//  EventSearchViewController.h
//  Bnearby
//
//  Created by Tristan on 24/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventSearchViewController : UITableViewController {
    NSManagedObjectContext *context;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
