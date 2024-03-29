//
//  EXViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "EXViewController.h"
#import "EXTableViewCell.h"
#import "EXTableView.h"
#import "HDScrollView.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "NavBarMenuButton.h"
#import "DEViewController.h"
#import "EXEventButton.h"
#import "BNEvent.h"
#import "BnearbyAppDelegate.h"
#import "VenueResultsView.h"
//#import "StarRatingControl.h"

@interface EXViewController ()
@property (weak, nonatomic) IBOutlet EXTableView *myTableView;
@property (weak, nonatomic) IBOutlet HDScrollView *myHeaderScroller;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (assign, nonatomic) BOOL searchVisible;
@property (strong, nonatomic) NSMutableArray *attractionImages;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *venues;
@property (readwrite, nonatomic) NSInteger tilePosition;
@property (assign, nonatomic) BOOL normalTile;

@property (strong, nonatomic) NSMutableArray *row0;
@property (strong, nonatomic) NSMutableArray *row1;
@property (strong, nonatomic) NSMutableArray *row2;
@property (strong, nonatomic) NSMutableArray *row3;
@property (strong, nonatomic) NSMutableArray *row4;
@property (strong, nonatomic) NSMutableArray *row5;

@property (strong, nonatomic) NSArray *costLimits;
@property (strong, nonatomic) NSArray *ratingLimits;
@property (strong, nonatomic) NSArray *timeLimits;
@property (assign, nonatomic) BOOL refined;
@property (strong, nonatomic) NSMutableArray *refinedEvents;

@end

@implementation EXViewController

@synthesize menuBtn;
@synthesize mySearchBar;
@synthesize searchVisible;
@synthesize venues;
@synthesize starRatingControl = _starRatingControl;
@synthesize timeRatingControl = _timeRatingControl;
@synthesize costRatingControl = _costRatingControl;

static NSString *CellIdentifier = @"CellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mySearchBar.delegate = self;
    
    _starRatingControl.delegate = self;
    _timeRatingControl.delegate = self;
    _costRatingControl.delegate = self;
    
    _costLimits = [[NSArray alloc] initWithObjects:@0, @20, @40, @50, @80, @100, nil];
    _ratingLimits = [[NSArray alloc] initWithObjects:@0, @1, @2, @3, @4, @5, nil];
    _timeLimits = [[NSArray alloc] initWithObjects:@0, @1, @2, @3, @5, @6, nil];
    
    // setup managedcontext
    BnearbyAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);       // fail
    }
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.myHeaderScroller setContentSize:(CGSizeMake(1280, 44))];
    [self.myHeaderScroller setScrollEnabled:YES];
    [self.myHeaderScroller setPagingEnabled:YES];
    
    // Sliding Menu
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }

    [self.myButton addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    self.attractionImages = [[NSMutableArray alloc] init];
    
    [self startUpdatingCurrentLocation];
    venues = [[NSMutableArray alloc] init];
    
    // setup client key and secret
    NSString *clientID=[NSString stringWithUTF8String:kCLIENT_ID];
    NSString *clientSecret=[NSString stringWithUTF8String:kCLIENT_SECRET];
    NSString *bURL = [NSString stringWithUTF8String:baseurl];
    NSString *rPath = [NSString stringWithUTF8String:resourcePath];
    
    NSString *currentLocation = @"Brisbane";
    
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@ll=%f,%f&near=%@&limit=5&client_id=%@&client_secret=%@",
                         bURL, rPath,self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude, currentLocation, clientID, clientSecret];
    
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
        
//                                            [self.tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //Error Pop up
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Error Retriveing Data" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }];
    
    [operation start];
    [self stopUpdatingCurrentLocation];
    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

- (void) viewWillAppear:(BOOL)animated {
    searchVisible = NO;
}

//- (void) viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:NO];
////    [self.tableView reloadData];
//    searchVisible = NO;
//}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Avoid custom content stacking
    if (cell != Nil) {
        for (UIView *oldTile in cell.myScrollView.myView.subviews){
            if ([oldTile isKindOfClass:[UIButton class]]) {
                if (oldTile.frame.origin.x != 0) {
                    [oldTile removeFromSuperview];
                }
                cell.myScrollView.myView.frame = CGRectMake(0, 0, 320, 168);
            }
        }
    }
    // Configure Cell
    EXScrollView *scroll = (EXScrollView *)[cell.contentView viewWithTag:10];
    [scroll setContentSize:(CGSizeMake(320, 168))];
    [scroll setScrollEnabled:YES];
    [scroll setPagingEnabled:YES];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Loading_Variation_One.png"]];
    NSInteger numbRows = 0;
    for (int j = 0; j < fetchedResultsController.sections.count; j++) {
        id sectionInfo = [[fetchedResultsController sections] objectAtIndex:j];
        NSInteger count = [sectionInfo numberOfObjects];
        numbRows = numbRows + count;
    }
    switch (indexPath.row) {
        case 0:
            if (self.refined) {
                numbRows = self.refinedEvents.count;
            }
            for (int i = 0; i < numbRows; i++) {
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
                BNEvent *event;
                if (self.refined) {
                        event = [self.refinedEvents objectAtIndex:i];
                }
                else {
                    event = [fetchedResultsController objectAtIndexPath:indexPath2];
                }
                if ([event.category isEqualToString:@"Attraction"] || [event.type isEqualToString:@"Free"]) {
                    // Prepare Scroll View for new event
                    [cell.myScrollView setContentSize:(CGSizeMake(cell.myScrollView.myView.frame.size.width + 320, 168))];
                    // Prepare Event View for new event
                    cell.myScrollView.myView.frame = CGRectMake(cell.myScrollView.myView.frame.origin.x, cell.myScrollView.myView.frame.origin.y, cell.myScrollView.myView.frame.size.width + 320, cell.myScrollView.myView.frame.size.height);
                    // Make sure Image view isn't distorted
                    cell.myScrollView.myView.myImage.frame = CGRectMake(0, 0, 320, 168);
                    
                    // Create a new Image View
                    UIButton *newTile = [[UIButton alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.size.width - 320, 0, 320, 168)];
                    [newTile setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", event.tileBanner]] forState:UIControlStateNormal];
                    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 126, 204, 21)];
                    UILabel *newLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 147, 204, 21)];
                    newLabel.text = [NSString stringWithFormat:@"%@", event.title];
                    newLabel2.text = [NSString stringWithFormat:@"%@",  event.address];
                    newLabel.textColor = [UIColor whiteColor];
                    newLabel.numberOfLines = 0;
                    newLabel.adjustsFontSizeToFitWidth = YES;
                    newLabel2.textColor = [UIColor whiteColor];
                    newLabel2.numberOfLines = 0;
                    newLabel2.adjustsFontSizeToFitWidth = YES;
//                    newLabel.minimumScaleFactor = 0;
                    [newTile addSubview:newLabel];
                    [newTile addSubview:newLabel2];
                    
                    [newTile addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.row0 == nil) {
                        self.row0 = [[NSMutableArray alloc] init];
                    }
                    
                    newTile.tag = indexPath.row;
                    [self.row0 addObject:event];
                    [cell.myScrollView.myView addSubview:newTile];
                }
            }
            // Setup Category Tile Image
            [cell.myScrollView.myView.myImage setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Explore_Entertainment.png"]] forState:UIControlStateNormal];
            break;
        case 1:
            if (self.refined) {
                numbRows = self.refinedEvents.count;
            }
            for (int i = 0; i < numbRows; i++) {
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
                BNEvent *event;
                if (self.refined) {
//                    if (i+1 == self.refinedEvents.count) {
//                        break;
//                    }
                    event = [self.refinedEvents objectAtIndex:i];
                }
                else {
                    event = [fetchedResultsController objectAtIndexPath:indexPath2];
                }
                if ([event.type isEqualToString:@"Restaurant"]) {
                    // Prepare Scroll View for new event
                    [cell.myScrollView setContentSize:(CGSizeMake(cell.myScrollView.myView.frame.size.width + 320, 168))];
                    // Prepare Event View for new event
                    cell.myScrollView.myView.frame = CGRectMake(cell.myScrollView.myView.frame.origin.x, cell.myScrollView.myView.frame.origin.y, cell.myScrollView.myView.frame.size.width + 320, cell.myScrollView.myView.frame.size.height);
                    // Make sure Image view isn't distorted
                    cell.myScrollView.myView.myImage.frame = CGRectMake(0, 0, 320, 168);
                    
                    // Create a new button Tile
                    UIButton *newTile = [[UIButton alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.size.width - 320, 0, 320, 168)];
                    [newTile setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", event.tileBanner]] forState:UIControlStateNormal];
                    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 126, 204, 21)];
                    UILabel *newLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 147, 204, 21)];
                    newLabel.text = [NSString stringWithFormat:@"%@", event.title];
                    newLabel2.text = [NSString stringWithFormat:@"%@",  event.address];
                    newLabel.textColor = [UIColor whiteColor];
                    newLabel.numberOfLines = 0;
                    newLabel.adjustsFontSizeToFitWidth = YES;
                    newLabel2.textColor = [UIColor whiteColor];
                    newLabel2.numberOfLines = 0;
                    newLabel2.adjustsFontSizeToFitWidth = YES;
                    //                    newLabel.minimumScaleFactor = 0;
                    [newTile addSubview:newLabel];
                    [newTile addSubview:newLabel2];
                    
                    [newTile addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.row1 == nil) {
                        self.row1 = [[NSMutableArray alloc] init];
                    }

                    newTile.tag = indexPath.row;
                    [self.row1 addObject:event];
                    [cell.myScrollView.myView addSubview:newTile];
                }
            }
            [cell.myScrollView.myView.myImage setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Explore_Resturants.png"]] forState:UIControlStateNormal];
            break;
        case 2:
            if (self.refined) {
                numbRows = self.refinedEvents.count;
            }
            for (int i = 0; i < numbRows; i++) {
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
                BNEvent *event;
                if (self.refined) {
//                    if (i+1 == self.refinedEvents.count) {
//                        break;
//                    }
                    event = [self.refinedEvents objectAtIndex:i];
                }
                else {
                    event = [fetchedResultsController objectAtIndexPath:indexPath2];
                }
//                BNEvent *event = [fetchedResultsController objectAtIndexPath:indexPath2];
                if ([event.type isEqualToString:@"Hotel"]) {
                    // Prepare Scroll View for new event
                    [cell.myScrollView setContentSize:(CGSizeMake(cell.myScrollView.myView.frame.size.width + 320, 168))];
                    // Prepare Event View for new event
                    cell.myScrollView.myView.frame = CGRectMake(cell.myScrollView.myView.frame.origin.x, cell.myScrollView.myView.frame.origin.y, cell.myScrollView.myView.frame.size.width + 320, cell.myScrollView.myView.frame.size.height);
                    // Make sure Image view isn't distorted
                    cell.myScrollView.myView.myImage.frame = CGRectMake(0, 0, 320, 168);
                    
                    // Create a new button Tile
                    UIButton *newTile = [[UIButton alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.size.width - 320, 0, 320, 168)];
                    [newTile setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", event.tileBanner]] forState:UIControlStateNormal];
                    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 126, 204, 21)];
                    UILabel *newLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 147, 204, 21)];
                    newLabel.text = [NSString stringWithFormat:@"%@", event.title];
                    newLabel2.text = [NSString stringWithFormat:@"%@",  event.address];
                    newLabel.textColor = [UIColor whiteColor];
                    newLabel.numberOfLines = 0;
                    newLabel.adjustsFontSizeToFitWidth = YES;
                    newLabel2.textColor = [UIColor whiteColor];
                    newLabel2.numberOfLines = 0;
                    newLabel2.adjustsFontSizeToFitWidth = YES;
                    //                    newLabel.minimumScaleFactor = 0;
                    [newTile addSubview:newLabel];
                    [newTile addSubview:newLabel2];
                    
                    [newTile addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.row2 == nil) {
                        self.row2 = [[NSMutableArray alloc] init];
                    }
                    
                    newTile.tag = indexPath.row;
                    [self.row2 addObject:event];
                    [cell.myScrollView.myView addSubview:newTile];
                }
            }
            [cell.myScrollView.myView.myImage setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Explore_Accomodation.png"]] forState:UIControlStateNormal];
            break;
        case 3:
            if (self.refined) {
                numbRows = self.refinedEvents.count;
            }
            for (int i = 0; i < numbRows; i++) {
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
                BNEvent *event;
                if (self.refined) {
                    event = [self.refinedEvents objectAtIndex:i];
                }
                else {
                    event = [fetchedResultsController objectAtIndexPath:indexPath2];
                }
                if ([event.category isEqualToString:@"Free"]) {
                    // Prepare Scroll View for new event
                    [cell.myScrollView setContentSize:(CGSizeMake(cell.myScrollView.myView.frame.size.width + 320, 168))];
                    // Prepare Event View for new event
                    cell.myScrollView.myView.frame = CGRectMake(cell.myScrollView.myView.frame.origin.x, cell.myScrollView.myView.frame.origin.y, cell.myScrollView.myView.frame.size.width + 320, cell.myScrollView.myView.frame.size.height);
                    // Make sure Image view isn't distorted
                    cell.myScrollView.myView.myImage.frame = CGRectMake(0, 0, 320, 168);
                    
                    // Create a new button Tile
                    UIButton *newTile = [[UIButton alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.size.width - 320, 0, 320, 168)];
                    [newTile setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", event.tileBanner]] forState:UIControlStateNormal];
                    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 126, 204, 21)];
                    UILabel *newLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 147, 204, 21)];
                    newLabel.text = [NSString stringWithFormat:@"%@", event.title];
                    newLabel2.text = [NSString stringWithFormat:@"%@",  event.address];
                    newLabel.textColor = [UIColor whiteColor];
                    newLabel.numberOfLines = 0;
                    newLabel.adjustsFontSizeToFitWidth = YES;
                    newLabel2.textColor = [UIColor whiteColor];
                    newLabel2.numberOfLines = 0;
                    newLabel2.adjustsFontSizeToFitWidth = YES;
                    //                    newLabel.minimumScaleFactor = 0;
                    [newTile addSubview:newLabel];
                    [newTile addSubview:newLabel2];
                    
                    [newTile addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.row3 == nil) {
                        self.row3 = [[NSMutableArray alloc] init];
                    }
                    
                    newTile.tag = indexPath.row;
                    [self.row3 addObject:event];
                    [cell.myScrollView.myView addSubview:newTile];
                }
            }
            [cell.myScrollView.myView.myImage setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Explore_FreeFun.png"]] forState:UIControlStateNormal];
            break;
        case 4:
            if (self.refined) {
                numbRows = self.refinedEvents.count;
            }
            for (int i = 0; i < numbRows; i++) {
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
                BNEvent *event;
                if (self.refined) {
                    event = [self.refinedEvents objectAtIndex:i];
                }
                else {
                    event = [fetchedResultsController objectAtIndexPath:indexPath2];
                }
                if ([event.category isEqualToString:@"Attractions"]) {
                    // Prepare Scroll View for new event
                    [cell.myScrollView setContentSize:(CGSizeMake(cell.myScrollView.myView.frame.size.width + 320, 168))];
                    // Prepare Event View for new event
                    cell.myScrollView.myView.frame = CGRectMake(cell.myScrollView.myView.frame.origin.x, cell.myScrollView.myView.frame.origin.y, cell.myScrollView.myView.frame.size.width + 320, cell.myScrollView.myView.frame.size.height);
                    // Make sure Image view isn't distorted
                    cell.myScrollView.myView.myImage.frame = CGRectMake(0, 0, 320, 168);
                    
                    // Create a new button Tile
                    UIButton *newTile = [[UIButton alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.size.width - 320, 0, 320, 168)];
                    [newTile setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", event.tileBanner]] forState:UIControlStateNormal];
                    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 126, 204, 21)];
                    UILabel *newLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 147, 204, 21)];
                    newLabel.text = [NSString stringWithFormat:@"%@", event.title];
                    newLabel2.text = [NSString stringWithFormat:@"%@",  event.address];
                    newLabel.textColor = [UIColor whiteColor];
                    newLabel.numberOfLines = 0;
                    newLabel.adjustsFontSizeToFitWidth = YES;
                    newLabel2.textColor = [UIColor whiteColor];
                    newLabel2.numberOfLines = 0;
                    newLabel2.adjustsFontSizeToFitWidth = YES;
                    //                    newLabel.minimumScaleFactor = 0;
                    [newTile addSubview:newLabel];
                    [newTile addSubview:newLabel2];
                    
                    [newTile addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.row4 == nil) {
                        self.row4 = [[NSMutableArray alloc] init];
                    }
                    
                    newTile.tag = indexPath.row;
                    [self.row4 addObject:event];
                    [cell.myScrollView.myView addSubview:newTile];
                }
            }
            [cell.myScrollView.myView.myImage setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Explore_Attractions.png"]] forState:UIControlStateNormal];
            break;
        case 5:
            if (self.refined) {
                numbRows = self.refinedEvents.count;
            }
            for (int i = 0; i < numbRows; i++) {
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
                BNEvent *event;
                if (self.refined) {
                    event = [self.refinedEvents objectAtIndex:i];
                }
                else {
                    event = [fetchedResultsController objectAtIndexPath:indexPath2];
                }
                if ([event.category isEqualToString:@"Free"] || [event.type isEqualToString:@"Art"] || [event.type isEqualToString:@"Nature"]) {
                    // Prepare Scroll View for new event
                    [cell.myScrollView setContentSize:(CGSizeMake(cell.myScrollView.myView.frame.size.width + 320, 168))];
                    // Prepare Event View for new event
                    cell.myScrollView.myView.frame = CGRectMake(cell.myScrollView.myView.frame.origin.x, cell.myScrollView.myView.frame.origin.y, cell.myScrollView.myView.frame.size.width + 320, cell.myScrollView.myView.frame.size.height);
                    // Make sure Image view isn't distorted
                    cell.myScrollView.myView.myImage.frame = CGRectMake(0, 0, 320, 168);
                    
                    // Create a new button Tile
                    UIButton *newTile = [[UIButton alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.size.width - 320, 0, 320, 168)];
                    [newTile setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", event.tileBanner]] forState:UIControlStateNormal];
                    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 126, 204, 21)];
                    UILabel *newLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 147, 204, 21)];
                    newLabel.text = [NSString stringWithFormat:@"%@", event.title];
                    newLabel2.text = [NSString stringWithFormat:@"%@",  event.address];
                    newLabel.textColor = [UIColor whiteColor];
                    newLabel.numberOfLines = 0;
                    newLabel.adjustsFontSizeToFitWidth = YES;
                    newLabel2.textColor = [UIColor whiteColor];
                    newLabel2.numberOfLines = 0;
                    newLabel2.adjustsFontSizeToFitWidth = YES;
                    //                    newLabel.minimumScaleFactor = 0;
                    [newTile addSubview:newLabel];
                    [newTile addSubview:newLabel2];
                    
                    [newTile addTarget:self action:@selector(tileTapped:) forControlEvents:UIControlEventTouchUpInside];
                    if (self.row5 == nil) {
                        self.row5 = [[NSMutableArray alloc] init];
                    }
                    
                    newTile.tag = indexPath.row;
                    [self.row5 addObject:event];
                    [cell.myScrollView.myView addSubview:newTile];
                }
            }
            [cell.myScrollView.myView.myImage setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Explore_Kids.png"]] forState:UIControlStateNormal];
            break;
        case 6:{
            for (NSDictionary* venue in venues) {
                // Prepare Scroll View for new event
                [cell.myScrollView setContentSize:(CGSizeMake(cell.myScrollView.myView.frame.size.width + 320, 168))];
                // Prepare Event View for new event
                cell.myScrollView.myView.frame = CGRectMake(cell.myScrollView.myView.frame.origin.x, cell.myScrollView.myView.frame.origin.y, cell.myScrollView.myView.frame.size.width + 320, cell.myScrollView.myView.frame.size.height);
                // Make sure Image view isn't distorted
                cell.myScrollView.myView.myImage.frame = CGRectMake(0, 0, 320, 168);
                
                // Create a new button Tile
                UIButton *newTile = [[UIButton alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.size.width - 320, 0, 320, 168)];
                [newTile setBackgroundImage:[UIImage imageNamed:@"Loading_Variation_One.png"] forState:UIControlStateNormal];
                UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 127, 204, 40)];
                newLabel.text = [NSString stringWithFormat:@"%@\nMore Details Here", [venue objectForKey:@"name"]];
                newLabel.textColor = [UIColor whiteColor];
                newLabel.numberOfLines = 0;
                newLabel.adjustsFontSizeToFitWidth = YES;
                newLabel.minimumScaleFactor = 0;
                [newTile addSubview:newLabel];
                [newTile addTarget:self action:@selector(nearByTileTapped:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.myScrollView.myView addSubview:newTile];
            }
            [cell.myScrollView.myView.myImage setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Explore_Nearby.png"]] forState:UIControlStateNormal];
            break;}
        default:
            [cell.myScrollView.myView.myImage setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Loading_Variation_One.png"]] forState:UIControlStateNormal];
            break;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168;
}

-(void)startUpdatingCurrentLocation {
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 2;
    }
    
    [self.locationManager startUpdatingLocation];
}

//Delegate method
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self stopUpdatingCurrentLocation];
}

- (void)stopUpdatingCurrentLocation {
    [self.locationManager stopUpdatingLocation];
}

- (void)starRatingControl:(StarRatingControl *)control didUpdateRating:(NSUInteger)rating {
    if (rating >= 0 && rating <=5) {
        NSInteger numbRows = 0;
        for (int j = 0; j < fetchedResultsController.sections.count; j++) {
            id sectionInfo = [[fetchedResultsController sections] objectAtIndex:j];
            NSInteger count = [sectionInfo numberOfObjects];
            numbRows = numbRows + count;
        }
        self.refinedEvents = [[NSMutableArray alloc] init];
        for (int i = 0; i < numbRows; i++) {
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
            BNEvent *event = [fetchedResultsController objectAtIndexPath:indexPath2];
            // Star Rating
            float eventRating = [event.rating floatValue];
            NSInteger starLimit = [[self.ratingLimits objectAtIndex:rating] integerValue];
            
            NSInteger costRating = self.costRatingControl.rating;
            NSInteger timeRating = self.timeRatingControl.rating;
            
            if (costRating > 0 || timeRating > 0) {
                if (costRating > 0 && timeRating <= 0) {
                    // Cost Rating
                    NSInteger max = [event.maxprice integerValue];
                    NSInteger costLimit = [[self.costLimits objectAtIndex:costRating] integerValue];
                    
                    if (eventRating >= (float)starLimit && max < costLimit) {
                        [self.refinedEvents addObject:event];
                    }
                }
                if (costRating <=0 && timeRating > 0) {
                    // Time Rating
                    float timeRating = [event.duration floatValue];
                    NSInteger timeLimit = [[self.timeLimits objectAtIndex:timeRating] integerValue];
                    
                    if (eventRating >= (float)starLimit && timeRating <= timeLimit) {
                        [self.refinedEvents addObject:event];
                    }
                }
                if (costRating > 0 && timeRating > 0) {
                    // Cost Rating
                    NSInteger max = [event.maxprice integerValue];
                    NSInteger costLimit = [[self.costLimits objectAtIndex:costRating] integerValue];
                    // Time Rating
                    float timeRating = [event.duration floatValue];
                    NSInteger timeLimit = [[self.timeLimits objectAtIndex:timeRating] integerValue];
                    
                    if (eventRating >= (float)starLimit && max < costLimit && timeRating <= timeLimit) {
                        [self.refinedEvents addObject:event];
                    }
                }
            }
            else {
                if (eventRating >= starLimit) {
                    [self.refinedEvents addObject:event];
                }
            }
        }
        if (rating == 0) {
            self.refined = NO;
        }
        else {
            self.refined = YES;
        }
        [self.tableView reloadData];
    }
    else {
        NSLog(@"Ooops");
    }
}

- (void)timeRatingControl:(TimeController *)control didUpdateRating:(NSUInteger)rating {
    if (rating >= 0 && rating <=5) {
        NSInteger numbRows = 0;
        for (int j = 0; j < fetchedResultsController.sections.count; j++) {
            id sectionInfo = [[fetchedResultsController sections] objectAtIndex:j];
            NSInteger count = [sectionInfo numberOfObjects];
            numbRows = numbRows + count;
        }
        self.refinedEvents = [[NSMutableArray alloc] init];
        for (int i = 0; i < numbRows; i++) {
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
            BNEvent *event = [fetchedResultsController objectAtIndexPath:indexPath2];
            // Time Rating
            float timeRating = [event.duration floatValue];
            NSInteger timeLimit = [[self.timeLimits objectAtIndex:rating] integerValue];
            
            NSInteger costRating = self.costRatingControl.rating;
            NSInteger starRating = self.starRatingControl.rating;
            
            if (costRating > 0 || starRating > 0) {
                if (costRating > 0 && starRating <= 0) {
                    // Cost Rating
                    NSInteger max = [event.maxprice integerValue];
                    NSInteger costLimit = [[self.costLimits objectAtIndex:costRating] integerValue];
                    
                    if (max < costLimit && timeRating <= timeLimit) {
                        [self.refinedEvents addObject:event];
                    }
                }
                if (costRating <= 0 && starRating > 0) {
                    // Star Rating
                    float eventRating = [event.rating floatValue];
                    NSInteger starLimit = [[self.ratingLimits objectAtIndex:starRating] integerValue];
                    
                    if (eventRating >= (float)starLimit && timeRating <= timeLimit) {
                        [self.refinedEvents addObject:event];
                    }
                }
                if (costRating > 0 && starRating > 0) {
                    // Cost Rating
                    NSInteger max = [event.maxprice integerValue];
                    NSInteger costLimit = [[self.costLimits objectAtIndex:costRating] integerValue];
                    // Star Rating
                    float eventRating = [event.rating floatValue];
                    NSInteger starLimit = [[self.ratingLimits objectAtIndex:starRating] integerValue];
                    
                    if (eventRating >= (float)starLimit && max < costLimit && timeRating <= timeLimit) {
                        [self.refinedEvents addObject:event];
                    }
                }
            }
            else {
                if (timeRating <= timeLimit) {
                    [self.refinedEvents addObject:event];
                }
            }
        }
        if (rating == 0) {
            self.refined = NO;
        }
        else {
            self.refined = YES;
        }
        [self.tableView reloadData];
    }
    else {
        NSLog(@"Ooops");
    }
}

- (void)costRatingControl:(CostController *)control didUpdateRating:(NSUInteger)rating {
    if (rating >= 0 && rating <= 5) {
        NSInteger numbRows = 0;
        for (int j = 0; j < fetchedResultsController.sections.count; j++) {
            id sectionInfo = [[fetchedResultsController sections] objectAtIndex:j];
            NSInteger count = [sectionInfo numberOfObjects];
            numbRows = numbRows + count;
        }
        self.refinedEvents = [[NSMutableArray alloc] init];
        for (int i = 0; i < numbRows; i++) {
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
            BNEvent *event = [fetchedResultsController objectAtIndexPath:indexPath2];
            if (rating < 5) {
                // Cost Rating
                NSInteger max = [event.maxprice integerValue];
                NSInteger costLimit = [[self.costLimits objectAtIndex:rating] integerValue];
                
                NSInteger starRating = self.costRatingControl.rating;
                NSInteger timeRating = self.timeRatingControl.rating;
                
                if (starRating > 0 || timeRating > 0) {
                    
                    
                    if (starRating > 0 && timeRating <= 0) {
                        // Star Rating
                        float eventRating = [event.rating floatValue];
                        NSInteger starLimit = [[self.ratingLimits objectAtIndex:starRating] integerValue];
                        
                        if (max < costLimit && eventRating >= starLimit) {
                            [self.refinedEvents addObject:event];
                        }
                    }
                    if (starRating <= 0 && timeRating > 0) {
                        // Time Rating
                        float timeRating = [event.duration floatValue];
                        NSInteger timeLimit = [[self.timeLimits objectAtIndex:timeRating] integerValue];
                        
                        if (max < costLimit && timeRating <= timeLimit) {
                            [self.refinedEvents addObject:event];
                        }
                    }
                    if (starRating > 0 && timeRating > 0) {
                        // Star Rating
                        float eventRating = [event.rating floatValue];
                        NSInteger starLimit = [[self.ratingLimits objectAtIndex:starRating] integerValue];
                        // Time Rating
                        float timeRating = [event.duration floatValue];
                        NSInteger timeLimit = [[self.timeLimits objectAtIndex:timeRating] integerValue];
                        
                        if (max < costLimit && eventRating >= starLimit && timeRating <= timeLimit) {
                            [self.refinedEvents addObject:event];
                        }
                    }
                    
                    
                }
                else {
                    if (starRating > 0 && timeRating <= 0) {
                        // Star Rating
                        float eventRating = [event.rating floatValue];
                        NSInteger starLimit = [[self.ratingLimits objectAtIndex:starRating] integerValue];
                        
                        if (max < costLimit && eventRating >= starLimit) {
                            [self.refinedEvents addObject:event];
                        }
                    }
                    if (starRating <= 0 && timeRating > 0) {
                        // Time Rating
                        float timeRating = [event.duration floatValue];
                        NSInteger timeLimit = [[self.timeLimits objectAtIndex:timeRating] integerValue];
                        
                        if (max < costLimit && timeRating <= timeLimit) {
                            [self.refinedEvents addObject:event];
                        }
                    }
                    if (starRating > 0 && timeRating > 0) {
                        // Star Rating
                        float eventRating = [event.rating floatValue];
                        NSInteger starLimit = [[self.ratingLimits objectAtIndex:starRating] integerValue];
                        // Time Rating
                        float timeRating = [event.duration floatValue];
                        NSInteger timeLimit = [[self.timeLimits objectAtIndex:timeRating] integerValue];
                        
                        if (max < costLimit && eventRating >= starLimit && timeRating <= timeLimit) {
                            [self.refinedEvents addObject:event];
                        }
                    }
                }
            }
            else {
                NSInteger max = [event.maxprice integerValue];
                NSInteger costLimit = [[self.costLimits objectAtIndex:rating] integerValue];
                
                NSInteger starRating = self.starRatingControl.rating;
                
                if (starRating > 0) {
                    // Star Rating
                    float eventRating = [event.rating floatValue];
                    NSInteger starLimit = [[self.ratingLimits objectAtIndex:self.starRatingControl.rating] integerValue];
                    
                    if (max < costLimit && eventRating >= starLimit) {
                        [self.refinedEvents addObject:event];
                    }
                }
                else {
                    if (max < costLimit) {
                        [self.refinedEvents addObject:event];
                    }
                }
            }
        }
        if (rating == 0) {
            self.refined = NO;
        }
        else {
            self.refined = YES;
        }
        [self.tableView reloadData];
    }
    else {
        NSLog(@"Ooops");
    }
}

//- (void)costRatingControl:(CostController *)control willUpdateRating:(NSUInteger)rating {
//}

// Scroll to display search bar
- (IBAction)displaySearch:(id)sender {
    [self.myHeaderScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
}

- (IBAction)nearByTileTapped:(id)sender {
    self.normalTile = NO;
    UIButton *tile = (UIButton*)sender;
    self.tilePosition = (tile.frame.origin.x/320)-1;
    [self performSegueWithIdentifier:@"DetailSegue" sender:sender];
}

- (IBAction)leadTileTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    EXEventView *eventView = (EXEventView *)button.superview;
    EXScrollView *eventScroller = (EXScrollView *)eventView.superview;
    if (eventView.frame.size.width > 320) {
        [eventScroller setContentOffset:CGPointMake(320, 0) animated:YES];
    } else {
        CGRect newFrame = eventView.frame;
        CGRect newFrame2 = eventView.frame;
        newFrame.origin.x -= 20;
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             eventView.frame = newFrame;
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.2
                                              animations:^{
                                                  eventView.frame = newFrame2;
                                              }
                                              completion:^(BOOL finished){
                                              }];
                         }];
    }

}

- (IBAction)tileTapped:(id)sender {
    self.normalTile = YES;
    UIButton *tile = (UIButton*)sender;
    self.tilePosition = (tile.frame.origin.x/320)-1;

    [self performSegueWithIdentifier:@"DetailSegue" sender:sender];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

-(void)buttonPressed:(EXEventButton *) sender {
    [self performSegueWithIdentifier: @"DetailSegue" sender: sender];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        if (self.normalTile) {
            UIButton *tile = (UIButton*)sender;
//            NSMutableDictionary *theVenue;
            BNEvent *eventToSend;
            switch (tile.tag) {
                case 0:{
//                    theVenue = [self.row0 objectAtIndex:self.tilePosition];
                    eventToSend = [self.row0 objectAtIndex:self.tilePosition];
//                    [theVenue setObject:[self.row0 objectAtIndex:self.tilePosition] forKey:0];
                    break;}
                case 1:{
//                    theVenue = [self.row1 objectAtIndex:self.tilePosition];
                    eventToSend = [self.row1 objectAtIndex:self.tilePosition];
//                    [theVenue setObject:[self.row1 objectAtIndex:self.tilePosition] forKey:0];
                    break;}
                case 2:{
//                    theVenue = [self.row2 objectAtIndex:self.tilePosition];
                    eventToSend = [self.row2 objectAtIndex:self.tilePosition];
//                    [theVenue setObject:[self.row2 objectAtIndex:self.tilePosition] forKey:0];
                    break;}
                case 3:{
//                    theVenue = [self.row3 objectAtIndex:self.tilePosition];
                    eventToSend = [self.row3 objectAtIndex:self.tilePosition];
//                    [theVenue setObject:[self.row3 objectAtIndex:self.tilePosition] forKey:0];
                    break;}
                case 4:{
                    //                    theVenue = [self.row3 objectAtIndex:self.tilePosition];
                    eventToSend = [self.row4 objectAtIndex:self.tilePosition];
                    //                    [theVenue setObject:[self.row3 objectAtIndex:self.tilePosition] forKey:0];
                    break;}
                case 5:{
                    //                    theVenue = [self.row3 objectAtIndex:self.tilePosition];
                    eventToSend = [self.row5 objectAtIndex:self.tilePosition];
                    //                    [theVenue setObject:[self.row3 objectAtIndex:self.tilePosition] forKey:0];
                    break;}
                default:
//                    theVenue = [self.row0 objectAtIndex:self.tilePosition];
                    eventToSend = [self.row0 objectAtIndex:self.tilePosition];
//                    [theVenue setObject:[self.row0 objectAtIndex:self.tilePosition] forKey:0];
                    break;
            }
            
            DEViewController *destinationView = segue.destinationViewController;
//            destinationView.theVenue = theVenue;
            // Type 1 indicates it is from coredata
            destinationView.type = @1;
            destinationView.event = eventToSend;
        }
        else {
            NSDictionary *theVenue = [venues objectAtIndex:self.tilePosition];
            
            DEViewController *destinationView = segue.destinationViewController;
            destinationView.theVenue = theVenue;
            // Type 2 indicates it is from foursquare
            destinationView.type = @2;
        }
    }
}

#pragma mark - 
#pragma mark - UISearchBar delegate


static NSString *url = @"https://api.foursquare.com/v2/";
static NSString *path = @"venues/explore?";

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    // setup client key and secret
    NSString *clientID=[NSString stringWithUTF8String:kCLIENT_ID];
    NSString *clientSecret=[NSString stringWithUTF8String:kCLIENT_SECRET];
    
    NSString *latlng = @"brisbane";
    
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@near=%@&query=%@&client_id=%@&client_secret=%@",
                         url, path, latlng, searchBar.text, clientID, clientSecret];
    
    NSURL *url = [NSURL URLWithString:fullUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /*
     * Begin venue fetch operation.
     *
     * Success: fetch venue information from FourSquare API and stores it in a Array.
     * Failure: display the error message in a popup.
     */
    AFJSONRequestOperation *operation= [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSMutableArray *tempVenues = [[NSMutableArray alloc] init];

        NSArray *groups = [[JSON objectForKey:@"response"] objectForKey:@"groups"];
        NSArray *items = [[groups objectAtIndex:0] objectForKey:@"items"];

        for (NSDictionary *item in items) {
            [tempVenues addObject:[item objectForKey:@"venue"]];
        }

        // sort the venues in alphabetical order
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];

        NSArray *venueResults = [tempVenues sortedArrayUsingDescriptors:sortDescriptors];
        
        // perform transition
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        VenueResultsView *destination = [storyboard instantiateViewControllerWithIdentifier:@"VenueResultsView"];
        destination.venues = venueResults;
        [destination.tableView reloadData];
        [self.navigationController pushViewController:destination animated:YES];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //Error Pop up
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"Error Retriveing Data" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }];
    
    [operation start];
}

@end