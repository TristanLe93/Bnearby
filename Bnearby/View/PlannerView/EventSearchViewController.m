//
//  PLViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "EventSearchViewController.h"
#import "BnearbyAppDelegate.h"
#import "BNEvent.h"

@implementation EventSearchViewController
@synthesize fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup managedcontext
    BnearbyAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);       // fail
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BNEvent" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc]
                                                               initWithFetchRequest:fetchRequest
                                                               managedObjectContext:context
                                                               sectionNameKeyPath:nil
                                                               cacheName:@"Root"];
    
    self.fetchedResultsController = theFetchedResultsController;
    return theFetchedResultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return fetchedResultsController.sections.count;
}

// number of rows in each section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    NSInteger count = [sectionInfo numberOfObjects];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EventSearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // config UI stuff
    BNEvent *event = [fetchedResultsController objectAtIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    imageView.image = [UIImage imageNamed:@"Entertainment Icons.png"];
    
    UILabel *eventTitle = (UILabel *)[cell viewWithTag:101];
    eventTitle.text = event.title;
    
    UILabel *eventAddress = (UILabel *)[cell viewWithTag:102];
    eventAddress.text = event.address;
    
    return cell;
}

// transfers event object to the destination VC
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
     if ([segue.identifier isEqualToString:@"showEventDetail"]) {
     NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     DEViewController *destVC = segue.destinationViewController;
     
     destVC.receivedEvent = [plannerEvents objectAtIndex:indexPath.row];
     }*/
}

@end