//
//  VenueCategorySelectView.m
//  Bnearby
//
//  Created by Tristan on 27/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "VenueCategorySelectView.h"
#import "VenueResultsView.h"

static NSString *baseurl = @"https://api.Foursquare.com/v2";

@implementation VenueCategorySelectView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    venueCategories = [[NSMutableDictionary alloc] init];
    
    //Hide table while calling api
    self.tableView.hidden = YES;
    
    // Setting Up Activity Indicator View
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    // form base url
    NSString *fourSquareURL = [NSString stringWithFormat:@"%@", baseurl];
    
    // create url link
    NSString *clientID = [NSString stringWithUTF8String:kCLIENT_ID];
    NSString *clientSecret = [NSString stringWithUTF8String:kCLIENT_SECRET];
    NSString *resourcePath = [NSString stringWithFormat:@"/venues/categories?client_id=%@&client_secret=%@", clientID,clientSecret];
    NSString *fullURL = [NSString stringWithFormat:@"%@%@",fourSquareURL,resourcePath];
    
    // do request
    NSURL *URL=[NSURL URLWithString:fullURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // request url and parse JSON response
    AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *listAllCategoriesInResponse = [JSON objectForKey:@"response"];
        NSArray *listCategories = [listAllCategoriesInResponse objectForKey:@"categories"];
        
        // set the id of categories in dictionary. Make the Name the key for the object
        for (int i = 0; i < listCategories.count; i++) {
            NSDictionary *category = [listCategories objectAtIndex:i];
            [venueCategories setObject:[category objectForKey:@"id"] forKey:[category objectForKey:@"name"]];
        }
        [self.activityIndicatorView stopAnimating];
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        UIAlertView *av =[[UIAlertView alloc] initWithTitle: @"ERROR" message:[NSString stringWithFormat: @"%@", error] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }];
    
    [operation1 start];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return venueCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"categoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *keys = [venueCategories allKeys];
    cell.textLabel.text = [keys objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"categoryToVenue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSArray *keys = [venueCategories allKeys];
        NSString *key = [keys objectAtIndex:indexPath.row];
        NSString *categoryid = [venueCategories objectForKey:key];
        
        VenueResultsView *destVC = segue.destinationViewController;
        destVC.categoryid = categoryid;
    }
}

@end
