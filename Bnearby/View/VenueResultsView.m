//
//  VenueResultsView.m
//  Bnearby
//
//  Created by Tristan on 27/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "VenueResultsView.h"
#import "VenueCategorySelectView.h"

//base URL for foursquare
static NSString *const BaseURLString=@"https://api.Foursquare.com/v2";

@interface VenueResultsView ()

@property(strong) NSDictionary *venuesDictionary;
@property(strong) NSDictionary *listAllVenuesInReponse;
@property(strong) NSArray *listObjVenue;

@end

@implementation VenueResultsView

- (void)viewDidLoad {
    [super viewDidLoad];

    //Hide table while calling api
    self.tableView.hidden = YES;
    
    // Setting Up Activity Indicator View
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    //1 Form the full URL
    NSString *fourSquareURL=[NSString stringWithFormat:@"%@",BaseURLString];
    
    //2 set parameter parameter
    // TODO: GET CURRENT LAT AND LONG
    NSString *latAndlong=@"-27.4769,153.0281";//QUT Current location
    
    
    NSString *clientID=[NSString stringWithUTF8String:kCLIENT_ID];
    NSString *clientSecret=[NSString stringWithUTF8String:kCLIENT_SECRET];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];//set datetime
    [format setDateFormat:@"yyyyMMdd"];
    NSDate *now = [[NSDate alloc] init];
    NSString *datetime=[format stringFromDate:now];
    
    NSString *resourcePath=[NSString stringWithFormat:@"/venues/search?ll=%@&categoryID=%@&client_id=%@&client_secret=%@&v=%@",latAndlong,self.categoryid,clientID,clientSecret,datetime];
    NSString *fullURL=[NSString stringWithFormat:@"%@%@",fourSquareURL,resourcePath];
    NSURL *URL=[NSURL URLWithString:fullURL];
    NSURLRequest *request=[NSURLRequest requestWithURL:URL];
    
    
    //3Fetch data across the network and then parses the JSON Response
    AFJSONRequestOperation *operation1 = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _listAllVenuesInReponse = [JSON objectForKey:@"response"];
        _listObjVenue = [_listAllVenuesInReponse objectForKey:@"venues"];

        [self.activityIndicatorView stopAnimating];
        [self.tableView setHidden:NO];
        [self.tableView reloadData];
        
        NSLog(@"%@ : %i", self.categoryid, _listObjVenue.count);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        UIAlertView *av =[[UIAlertView alloc] initWithTitle: @"ERROR" message:[NSString stringWithFormat: @"%@", error] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }];
    
    
    [operation1 start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listObjVenue && self.listObjVenue.count) {
        return self.listObjVenue.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"venueCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSDictionary *objlist=[self.listObjVenue objectAtIndex:indexPath.row];
    //NSDictionary *name=[objlist objectForKey:@"name"];
    
    cell.textLabel.text = [objlist objectForKey:@"name"];
    
    return cell;
}

@end
