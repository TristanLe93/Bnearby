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

static NSString *baseurl = @"https://api.foursquare.com/v2/";
static NSString *resourcePath = @"venues/explore?";

@interface VenueResultsView () {
    NSArray *venues;

}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation VenueResultsView

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Loading Animation start
    [self.spinner startAnimating];
    venues = [[NSMutableArray alloc] init];
    
    // setup client key and secret
    NSString *clientID=[NSString stringWithUTF8String:kCLIENT_ID];
    NSString *clientSecret=[NSString stringWithUTF8String:kCLIENT_SECRET];
    
    NSString *currentLocation = @"Brisbane";
    
//    NSString *fullUrl = [NSString stringWithFormat:@"%@%@ll=%@,%@&near=%@&client_id=%@&client_secret=%@", baseurl, resourcePath, currentLocation, clientID, clientSecret];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@near=%@&categoryId=%@&client_id=%@&client_secret=%@", baseurl, resourcePath, currentLocation, self.categoryId, clientID, clientSecret];
    
//    NSLog(@"URL %@", [NSString stringWithFormat:@"%@%@near=%@&categoryId=%@&client_id=%@&client_secret=%@", baseurl, resourcePath, currentLocation, self.categoryId, clientID, clientSecret]);
    
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
        
        venues = [tempVenues sortedArrayUsingDescriptors:sortDescriptors];
        
        [self.tableView reloadData];
        self.title = [NSString stringWithFormat:@"%i Results", venues.count];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
          //Error Pop up
          UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Error Retriveing Data" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
          [av show];
    }];

    [operation start];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
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
    }
}

@end
