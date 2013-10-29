//
//  VenueResultsView.m
//  Bnearby
//
//  Created by Tristan on 16/10/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "VenueResultsView.h"
#import "DEViewController.h"
#import "AFNetworking.h"

@interface VenueResultsView ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end


@implementation VenueResultsView
@synthesize venues;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.spinner startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// return the number of rows in the section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return venues.count;
}

// Updates the tableview cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VenueCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *theVenue = [venues objectAtIndex:indexPath.row];
    cell.textLabel.text = [theVenue objectForKey:@"name"];

    [self.spinner stopAnimating];
    self.spinner.hidesWhenStopped = YES;

    return cell;
}

// segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"VenueDetailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *theVenue = [venues objectAtIndex:indexPath.row];
        
        DEViewController *destinationView = segue.destinationViewController;
        destinationView.theVenue = theVenue;
        destinationView.type = @2;
    }
}

@end
