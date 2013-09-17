//
//  PLViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "PLViewController.h"
#import "DEViewController.h"
#import "BNEvent.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface PLViewController ()

@end

@implementation PLViewController
@synthesize plannerEvents;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    plannerEvents = [[NSMutableArray alloc] init];
    
    // create Beastie Burgers event
    BNEvent *event1 = [[BNEvent alloc] init];
    event1.name = @"Eat at Beastie Burgers";
    event1.time = @"12.00pm";
    event1.location = @"Somewhere in SouthBank";
    event1.bannerImage = @"Planner_ExampleTile1.png";
    
    [plannerEvents addObject:event1];
    
    // create Queensland Art Gallery event
    BNEvent *event2 = [[BNEvent alloc] init];
    event2.name = @"Visit Queensland Art Gallery";
    event2.time = @"13.00pm";
    event2.location = @"Brisbane, City";
    event2.bannerImage = @"Planner_ExampleTile2.png";
    
    [plannerEvents addObject:event2];
    
    [self.menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    //    UIView* bview = [[UIView alloc] init];
    //    bview.backgroundColor = [UIColor colorWithRed:5/255.0f green:254/255.0f blue:255/255.0f alpha:1.0f];
    //    [self.tableView setBackgroundView:bview];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

// number of rows in each section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return plannerEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *filePath = [[plannerEvents objectAtIndex:indexPath.row] bannerImage];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filePath]];
    //cell.textLabel.text = [[plannerEvents objectAtIndex:indexPath.row] name];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

// transfers event object to the destination VC
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DEViewController *destVC = segue.destinationViewController;
        
        destVC.receivedEvent = [plannerEvents objectAtIndex:indexPath.row];
    }
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end