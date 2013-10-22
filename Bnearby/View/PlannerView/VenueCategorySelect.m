//
//  VenueCategorySelectView.m
//  Bnearby
//
//  Created by Tristan on 27/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "VenueCategorySelect.h"
#import "VenueResultsView.h"

static NSString *entertaiment_id = @"4d4b7104d754a06370d81259";
static NSString *food_id = @"4d4b7105d754a06374d81259";
static NSString *nightlife_id = @"4d4b7105d754a06376d81259";
static NSString *outdoors_id = @"4d4b7105d754a06377d81259";
static NSString *clothing_id = @"4bf58dd8d48988d103951735";

@implementation VenueCategorySelect

- (void)viewDidLoad {
    [super viewDidLoad];
    
    venueCategories = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                       entertaiment_id, @"Arts & Entertainment",
                       food_id, @"Food",
                       nightlife_id, @"Nightlife Spots",
                       outdoors_id, @"Outdoors",
                       clothing_id, @"Clothing Stores",
                       nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return venueCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSArray *keys = [venueCategories allKeys];
    cell.textLabel.text = [keys objectAtIndex:indexPath.row];

    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"VenueResultsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *key = [[venueCategories allKeys] objectAtIndex:indexPath.row];
        NSString *categoryId = [venueCategories objectForKey:key];
        
        VenueResultsView *destinationView = segue.destinationViewController;
        destinationView.categoryId = categoryId;
    }

}

@end
