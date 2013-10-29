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

#pragma mark -
#pragma mark - Navigation

static NSString *baseurl = @"https://api.foursquare.com/v2/";
static NSString *resourcePath = @"venues/explore?";

/*
 * Perform a segue to the VenueResultsView. 
 * We pass an array of venues.
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"VenueResultsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *key = [[venueCategories allKeys] objectAtIndex:indexPath.row];
        NSString *categoryId = [venueCategories objectForKey:key];
        
        // setup client key and secret
        NSString *clientID=[NSString stringWithUTF8String:kCLIENT_ID];
        NSString *clientSecret=[NSString stringWithUTF8String:kCLIENT_SECRET];
        
        NSString *currentLocation = @"Brisbane";
        
        NSString *fullUrl = [NSString stringWithFormat:@"%@%@near=%@&categoryId=%@&client_id=%@&client_secret=%@",
                             baseurl, resourcePath, currentLocation, categoryId, clientID, clientSecret];
        
        NSURL *url = [NSURL URLWithString:fullUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        /*
         * Begin venue fetch operation.
         *
         * Success: fetch venue information from FourSquare API and stores it in a Array.
         * Failure: display the error message in a popup.
         */
        AFJSONRequestOperation *operation= [AFJSONRequestOperation JSONRequestOperationWithRequest:request
           success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
        {
            NSMutableArray *tempVenues = [[NSMutableArray alloc] init];
            
            NSArray *groups = [[JSON objectForKey:@"response"] objectForKey:@"groups"];
            NSArray *items = [[groups objectAtIndex:0] objectForKey:@"items"];
            
            for (NSDictionary *item in items) {
                [tempVenues addObject:[item objectForKey:@"venue"]];
            }
            
            // sort the venues in alphabetical order
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
            
            NSArray *venues = [tempVenues sortedArrayUsingDescriptors:sortDescriptors];
            
            // pass view to destination
            VenueResultsView *destinationView = segue.destinationViewController;
            destinationView.venues = venues;
            
            [destinationView.tableView reloadData];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            //Error Pop up
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Error Retriveing Data" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }];
        
        [operation start];
        

    }

}



@end
