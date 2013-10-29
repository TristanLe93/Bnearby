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
#import "BNEvent.h"
#import "DEViewController.h"

@interface NWTableViewController ()
@property (strong, nonatomic) MKMapView *theMap;
@property (assign, nonatomic) BOOL refresh;
@property (assign, nonatomic) BOOL once;
@property (strong, nonatomic) NSArray *plannedEvents;
@property (strong, nonatomic) NSDateComponents *components;
@property (strong, nonatomic) UIButton *event1;
@property (strong, nonatomic) UIButton *event2;
@property (strong, nonatomic) UIButton *event3;
@property (strong, nonatomic) UIButton *event4;
@property (readwrite, nonatomic) NSInteger position;

@end

@implementation NWTableViewController {
}
@synthesize menuBtn;
@synthesize WeatherBT;
@synthesize locationManager;
@synthesize app;
@synthesize weather;
@synthesize plannedEvents;
@synthesize components;

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
    
    // Pull to Refresh Controls
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor orangeColor];
    [refreshControl addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
//    // Background image setup
//    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
//    [tempImageView setFrame:self.tableView.frame];
//    self.tableView.backgroundView = tempImageView;
    
    // setup managedcontext
    BnearbyAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);       // fail
    }
    
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
    [self.theMap setMapType:MKMapTypeStandard];
    [self.theMap setZoomEnabled:YES];
    [self.theMap setScrollEnabled: YES];

    [self getPlannedEvents];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    fetchedResultsController = theFetchedResultsController;
    return theFetchedResultsController;
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
            
            
            ILTranslucentView *translucentView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 10, 320, 78)];
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
            
            ILTranslucentView *translucentView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 0, 320, 122)];
            
            //optional:
            translucentView.translucentAlpha = 0.5;
            translucentView.translucentStyle = UIBarStyleDefault;
            translucentView.translucentTintColor = [UIColor colorWithRed:255/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f];
            translucentView.backgroundColor = [UIColor clearColor];
            
            if (plannedEvents != nil) {
                if (plannedEvents.count > 0) {
                    for (int i =  0; i < plannedEvents.count; i++) {
                        
                        UIButton *eventButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 25 + (i*20 + i*5), 300, 20)];
                        BNEvent *addEvent = [plannedEvents objectAtIndex:i];
                        components = [[NSCalendar currentCalendar] components: NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:addEvent.date];
                        NSInteger hour = [components hour];
                        NSInteger minute = [components minute];

                        [eventButton setTitle:[NSString stringWithFormat:@"%d:%d - %@", hour, minute ,addEvent.title] forState:UIControlStateNormal];
                        
                        
                        switch (i) {
                            case 0:
                                self.event1 = eventButton;
                                [self.event1 addTarget:self action:@selector(eventSelected:) forControlEvents:UIControlEventTouchUpInside];
                                [translucentView addSubview:self.event1];
                                break;
                            case 1:
                                self.event2 = eventButton;
                                [self.event2 addTarget:self action:@selector(eventSelected:) forControlEvents:UIControlEventTouchUpInside];
                                [translucentView addSubview:self.event2];
                                break;
                            case 2:
                                self.event3 = eventButton;
                                [self.event3 addTarget:self action:@selector(eventSelected:) forControlEvents:UIControlEventTouchUpInside];
                                [translucentView addSubview:self.event3];
                                break;
                            case 3:
                                self.event4 = eventButton;
                                [self.event4 addTarget:self action:@selector(eventSelected:) forControlEvents:UIControlEventTouchUpInside];
                                [translucentView addSubview:self.event4];
                                break;
                            default:
                                break;
                        }
                        if (i == 3) {
                            break;
                        }
                    }
                }
            }
            
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
            [scroller setContentSize:(CGSizeMake(1095, 132))];
            [scroller setScrollEnabled:YES];
            NWPhotoCellView *view = [[NWPhotoCellView alloc] initWithFrame:CGRectMake(0, 0, 1095, 122)];
            NSMutableArray *images = [[NSMutableArray alloc] init];
            for (int i = 0; i < 5; i++) {
                UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(((i+1)*5) + (i*213), 5, 213, 112)];
                [view addSubview:newImageView];
                [images addObject:newImageView];
            }
            
            ILTranslucentView *translucentView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, 10, 1095, 122)];
            
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

- (IBAction)eventSelected:(id)sender {
    UIButton *thisButton = (UIButton*)sender;
    self.position = ((thisButton.frame.origin.y/25) - 1);
    [self performSegueWithIdentifier:@"miniPlannerSegue" sender:self];
}



- (void)getPlannedEvents {
    NSMutableArray *planned = [[NSMutableArray alloc] init];
    NSInteger numbRows = 0;
    for (int j = 0; j < fetchedResultsController.sections.count; j++) {
        id sectionInfo = [[fetchedResultsController sections] objectAtIndex:j];
        NSInteger count = [sectionInfo numberOfObjects];
        numbRows = numbRows + count;
    }
    if (numbRows > 0) {
        for (int i = 0; i < numbRows; i++) {
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
            BNEvent *event = [fetchedResultsController objectAtIndexPath:indexPath2];
            
            if (event.date != nil) {
                NSDate *now = [NSDate date];
                NSDate *endDate = [self dateAtEndOfDayForDate:now];
                
                if (event.date != nil && [self date:event.date isBetweenDate:now andDate:endDate]) {
                    [planned addObject:event];
                }
            }
        }
        if (planned.count > 0) {
            NSArray* reversedArray = [[planned reverseObjectEnumerator] allObjects];
            plannedEvents = [[NSArray alloc] initWithArray:reversedArray];
        }
    }
    
//    plannedEvents = [planned sortedArrayUsingSelector:@selector(compare:)];
}

- (NSDate *)dateAtEndOfDayForDate:(NSDate *)inputDate {
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:23];
    [dateComps setMinute:59];
    [dateComps setSecond:59];
    
    // Convert back
    NSDate *endOfDay = [calendar dateFromComponents:dateComps];
    return endOfDay;
}

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate {
    if ([date compare:beginDate] == NSOrderedAscending) {
    	return NO;
    }
    if ([date compare:endDate] == NSOrderedDescending) {
    	return NO;
    }
    return YES;
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"miniPlannerSegue"]) {
        // Get reference to the destination view controller
        
        
         DEViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...

        BNEvent *sendThisEvent = [plannedEvents objectAtIndex:self.position];
        vc.event = sendThisEvent;
        vc.type = @1;
    }
}
 

@end
