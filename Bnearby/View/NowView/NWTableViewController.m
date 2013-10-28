//
//  NWTableViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 24/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "NWTableViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "NWPhotoCellView.h"
#import "NWPhotoCellScroller.h"
#import "NWMapCell.h"
#import "NWWeatherCell.h"
#import "WeatherParser.h"
#import "ILTranslucentView.h"

@interface NWTableViewController ()
//@property (strong, nonatomic) UILabel *weatherLabel;
//@property (strong, nonatomic) UILabel *detailedWeatherLabel;
//@property (strong, nonatomic) UIImageView *weatherIcon;
@property (strong, nonatomic) MKMapView *theMap;
//@property (strong, nonatomic) NWWeatherCell *weatherCell;
//@property (strong, nonatomic) NSString *weatherText;
//@property (strong, nonatomic) NSString *detailedWeatherText;
@property (assign, nonatomic) BOOL refresh;
@property (assign, nonatomic) BOOL once;


@end

@implementation NWTableViewController {
}

@synthesize menuBtn;
@synthesize WeatherBT;
@synthesize locationManager;
@synthesize app;
@synthesize weather;

//NSString * temperature;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Pull to Refresh Controls
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor orangeColor];
    [refreshControl addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
//    // Background image setup
//    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
//    [tempImageView setFrame:self.tableView.frame];
//    self.tableView.backgroundView = tempImageView;
    
    // Sliding Menu Controls
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    // Location Services and Mapping setup
    app = [[UIApplication sharedApplication] delegate];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//    [self.locationManager startUpdatingLocation];
    [self.theMap setMapType:MKMapTypeStandard];
    [self.theMap setZoomEnabled:YES];
    [self.theMap setScrollEnabled: YES];

    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier0 = @"weatherCell";
    static NSString *CellIdentifier2 = @"photoCell";
    static NSString *CellIdentifier1 = @"plannerCell";
    static NSString *CellIdentifier3 = @"mapCell";
    UITableViewCell *cell = nil;

    switch (indexPath.row) {
        case 0: {
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0 forIndexPath:indexPath];
            
            if (self.once) {
                NSArray *array = cell.contentView.subviews;
                [(ILTranslucentView*)[array objectAtIndex:0] removeFromSuperview];
            }
            
            weather = [app.listArray objectAtIndex:0];
            
            UILabel *weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 14, 202, 21)];
            UILabel *detailedWeatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 43, 202, 21)];
            UIImageView *weatherIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 50, 50)];
            weatherLabel.text = [NSString stringWithFormat:@"%d℃ %@", (int)weather.currentTemperature, weather.description];
            weatherLabel.adjustsFontSizeToFitWidth = YES;
//            self.weatherLabel.minimumFontSize = 0;
            weatherLabel.numberOfLines = 1;
            detailedWeatherLabel.text = [NSString stringWithFormat:@"lo %.d℃ hi %.d℃", (int)weather.minTemperature, (int)weather.maxTemperature];
            NSString *aux = [self iconForWeather:weather.icon];
            weatherIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", aux]];
            self.navigationItem.title = [NSString stringWithFormat:@"%@", weather.name];
            
            
            ILTranslucentView *translucentView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(10, 10, 300, 78)];
            [translucentView addSubview:weatherIcon];
            [translucentView addSubview:weatherLabel];
            [translucentView addSubview:detailedWeatherLabel];
            
            //optional:
            translucentView.translucentAlpha = 0.5;
            translucentView.translucentStyle = UIBarStyleDefault;
            translucentView.translucentTintColor = [UIColor colorWithRed:255/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f];
            translucentView.backgroundColor = [UIColor clearColor];
            
            [cell.contentView addSubview:translucentView];
            cell.backgroundColor = [UIColor clearColor];
            break;}
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
            
            if (self.once) {
                NSArray *array = cell.contentView.subviews;
                UIView *oldPlannerView = [array objectAtIndex:0];
                NSArray *array2 = oldPlannerView.subviews;
                [(ILTranslucentView*)[array2 objectAtIndex:0] removeFromSuperview];
            }
            
            UIView *plannerView = (UIView*)[cell.contentView viewWithTag:71];
            UILabel *plannerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 21)];
            plannerLabel.text = @"Next Events";
            
            ILTranslucentView *translucentView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 0, 300, 122)];
            
            //optional:
            translucentView.translucentAlpha = 0.5;
            translucentView.translucentStyle = UIBarStyleDefault;
            translucentView.translucentTintColor = [UIColor colorWithRed:255/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f];
            translucentView.backgroundColor = [UIColor clearColor];
            
        
            
            
            [translucentView addSubview:plannerLabel];
            [plannerView addSubview:translucentView];
            cell.backgroundColor = [UIColor clearColor];
            break;}
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
            
            if (self.once) {
                NSArray *array = cell.contentView.subviews;
                NWPhotoCellScroller *scroller = [array objectAtIndex:0];
                NSArray *array2 = scroller.subviews;
                for (id obj in array2) {
                    if ([obj isMemberOfClass:[ILTranslucentView class]]) {
                        [(ILTranslucentView*)obj removeFromSuperview];
                    }
                }
                
                [(ILTranslucentView*)[array2 objectAtIndex:0] removeFromSuperview];
                
            }
            
            NWPhotoCellScroller *scroller = (NWPhotoCellScroller*)[cell viewWithTag:100];
            [scroller setContentSize:(CGSizeMake(1115, 132))];
            [scroller setScrollEnabled:YES];
            NWPhotoCellView *view = [[NWPhotoCellView alloc] initWithFrame:CGRectMake(0, 0, 1095, 122)];
            NSMutableArray *images = [[NSMutableArray alloc] init];
            for (int i = 0; i < 5; i++) {
                UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(((i+1)*5) + (i*213), 5, 213, 112)];
                [view addSubview:newImageView];
                [images addObject:newImageView];
            }
            
            ILTranslucentView *translucentView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(10, 10, 1095, 122)];
            
            //optional:
            translucentView.translucentAlpha = 0.5;
            translucentView.translucentStyle = UIBarStyleDefault;
            translucentView.translucentTintColor = [UIColor colorWithRed:255/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f];
            translucentView.backgroundColor = [UIColor clearColor];
            
            view.imageViews = images;
            [view initWithFrame:view.frame];
            [translucentView addSubview:view];
            [scroller addSubview:translucentView];
            cell.backgroundColor = [UIColor clearColor];
            break;}
        case 3: {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3 forIndexPath:indexPath];
            
//            if (self.once) {
//                NSArray *array = cell.contentView.subviews;
//                [(ILTranslucentView*)[array objectAtIndex:0] removeFromSuperview];
//            }
            self.once = YES;
            
            self.theMap = (MKMapView*)[cell viewWithTag:30];
            MKCoordinateRegion region = {{-27.4679, 153.0277}, {0.1f, 0.1f}};
            [self.theMap setRegion:region animated:YES];
            cell.backgroundColor = [UIColor clearColor];
            break;}
        default:{
            break;}
    }
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    switch (indexPath.row) {
        case 0:
            height = 88;
            break;
        case 1:
            height = 132;
            break;
        case 2:
            height = 132;
            break;
        case 3:
            height = 200;
            break;
        default:
            break;
    }
    return height;
}

- (NSString*)iconForWeather: (NSString*)iconId {
    NSString *image;
    if ([iconId isEqualToString:@"01d"]) {
        image = @"32 - Sunny.png";
    } else if ([iconId isEqualToString:@"01n"]) {
        image = @"31 - Clear Night";
    } else if ([iconId isEqualToString:@"02d"] || [iconId isEqualToString:@"03d"] || [iconId isEqualToString:@"04d"]) {
        image = @"26 - Cloudy.png";
    } else if ([iconId isEqualToString:@"02n"] || [iconId isEqualToString:@"03n"] || [iconId isEqualToString:@"04n"]) {
        image = @"27 - Cloudy Night.png";
    } else if ([iconId isEqualToString:@"09d"] || [iconId isEqualToString:@"10d"] || [iconId isEqualToString:@"09n"] || [iconId isEqualToString:@"10n"]) {
        image = @"Rainy.png";
    } else if ([iconId isEqualToString:@"11d"] || [iconId isEqualToString:@"11n"]) {
        image = @"4 - Thunderstorms.png";
    }
    return image;
}

- (void)refreshLocation {
    [app parseWeather];
    _refresh = !_refresh;
    [self performSelector:@selector(updateTable) withObject:nil
               afterDelay:1];
}

- (void)updateTable {
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

//- (IBAction)func:(id)sender {
//    
////    [self.theMap setMapType:MKMapTypeStandard];
////    [self.theMap setZoomEnabled:YES];
////    [self.theMap setScrollEnabled: YES];
//    MKCoordinateRegion region = {{0.0, 0.0}, {0.0, 0.0}};
//    region.center.latitude = self.locationManager.location.coordinate.latitude;
//    region.center.longitude = self.locationManager.location.coordinate.longitude;
//    
//    region.span.longitudeDelta = 0.007f;
//    region.span.latitudeDelta = 0.007f;
//    [self.theMap setRegion:region animated:YES];
//    [self.theMap setDelegate:sender];
//    self.theMap.showsUserLocation = YES;
//    return;
//  }

//-(void)displayLocation {
//    MKCoordinateRegion region = {{0.0, 0.0}, {0.0, 0.0}};
//    region.center.latitude = self.locationManager.location.coordinate.latitude;
//    region.center.longitude = self.locationManager.location.coordinate.longitude;
//    
//    NSLog(@"Latitude: %f", region.center.latitude);
//    NSLog(@"Longitude: %f", region.center.longitude);
//    
//    region.span.longitudeDelta = 0.007f;
//    region.span.latitudeDelta = 0.007f;
//    [self.theMap setRegion:region animated:YES];
////    [self.theMap setDelegate:sender];
//    self.theMap.showsUserLocation = YES;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
