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

@interface EXViewController ()
@property (weak, nonatomic) IBOutlet EXTableView *myTableView;
@property (weak, nonatomic) IBOutlet HDScrollView *myHeaderScroller;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (assign, nonatomic) BOOL searchVisible;
@property (strong, nonatomic) NSMutableArray *attractionImages;


@end

@implementation EXViewController

@synthesize menuBtn;
@synthesize mySearchBar;
@synthesize searchVisible;

static NSString *CellIdentifier = @"CellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    searchVisible = NO;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    EXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    // Configure Cell
//    [cell.myScrollView setContentSize:(CGSizeMake(640, 168))];
//    [cell.myScrollView setScrollEnabled:YES];
//    [cell.myScrollView setPagingEnabled:YES];
//    
//    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Loading_Variation_One.png"]];
//    
//    return cell;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure Cell
    EXScrollView *scroll = (EXScrollView *)[cell.contentView viewWithTag:10];
    //[label setText:[NSString stringWithFormat:@"Row %i in Section %i", [indexPath row], [indexPath section]]];
    [scroll setContentSize:(CGSizeMake(321, 168))];
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
            for (int i = 0; i < numbRows; i++) {
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
                BNEvent *event = [fetchedResultsController objectAtIndexPath:indexPath2];
                if ([event.type isEqualToString:@"Attraction"]) {
                    // Prepare Scroll View for new event
                    [cell.myScrollView setContentSize:(CGSizeMake(cell.myScrollView.myView.frame.size.width + 320, 168))];
                    // Prepare Event View for new event
                    cell.myScrollView.myView.frame = CGRectMake(cell.myScrollView.myView.frame.origin.x, cell.myScrollView.myView.frame.origin.y, cell.myScrollView.myView.frame.size.width + 320, cell.myScrollView.myView.frame.size.height);
                    // Make sure Image view isn't distorted
                    cell.myScrollView.myView.myImage.frame = CGRectMake(0, 0, 320, 168);
                    
                    // Create a new Image View
                    UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.size.width - 320, 0, 320, 168)];
                    newImage.image = [UIImage imageNamed:@"Loading_Variation_One.png"];
                    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 127, 204, 40)];
                    newLabel.text = [NSString stringWithFormat:@"%@\nMore Details Here", event.title];
                    newLabel.textColor = [UIColor whiteColor];
                    newLabel.numberOfLines = 0;
                    newLabel.adjustsFontSizeToFitWidth = YES;
                    newLabel.minimumScaleFactor = 0;
                    [newImage addSubview:newLabel];

                    [cell.myScrollView.myView addSubview:newImage];
                }
            }
            // Setup Category Tile Image
            [cell.myScrollView.myView.myImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Explore_Entertainment.png"]]];
            break;
        case 1:
            for (int i = 0; i < numbRows; i++) {
                NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:i inSection:0];
                BNEvent *event = [fetchedResultsController objectAtIndexPath:indexPath2];
                if ([event.type isEqualToString:@"Restaurant"]) {
                    // Prepare Scroll View for new event
                    [cell.myScrollView setContentSize:(CGSizeMake(cell.myScrollView.myView.frame.size.width + 320, 168))];
                    // Prepare Event View for new event
                    cell.myScrollView.myView.frame = CGRectMake(cell.myScrollView.myView.frame.origin.x, cell.myScrollView.myView.frame.origin.y, cell.myScrollView.myView.frame.size.width + 320, cell.myScrollView.myView.frame.size.height);
                    // Make sure Image view isn't distorted
                    cell.myScrollView.myView.myImage.frame = CGRectMake(0, 0, 320, 168);
                    
                    // Create a new Image View
                    UIImageView *newImage = [[UIImageView alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.size.width - 320, 0, 320, 168)];
                    newImage.image = [UIImage imageNamed:@"Loading_Variation_One.png"];
                    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.myScrollView.myView.frame.origin.x + 20, 127, 204, 40)];
                    newLabel.text = [NSString stringWithFormat:@"%@\nMore Details Here", event.title];
                    newLabel.textColor = [UIColor whiteColor];
                    newLabel.numberOfLines = 0;
                    newLabel.adjustsFontSizeToFitWidth = YES;
                    newLabel.minimumScaleFactor = 0;
                    [newImage addSubview:newLabel];
                    
                    [cell.myScrollView.myView addSubview:newImage];
                }
            }
            [cell.myScrollView.myView.myImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Explore_Resturants.png"]]];
            break;
        case 2:
            [cell.myScrollView.myView.myImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Explore_FreeFun.png"]]];
            break;
        case 3:
            [cell.myScrollView.myView.myImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Explore_Kids.png"]]];
            break;
        default:
            [cell.myScrollView.myView.myImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Loading_Variation_One.png"]]];
            break;
    }
    return cell;
}

//- (void)fetchEvents {
//    // Listing all MemberInfo from the store
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MemberInfo" inManagedObjectContext: context];
//    [fetchRequest setEntity:entity];
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest
//                                                     error:&err];
//    for (MemberInfo *info in fetchedObjects) {
//        NSLog(@"Name: %@  date:%@", info.name, info.startdate);
//    }
//}


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

// Scroll to display search bar
- (IBAction)displaySearch:(id)sender {
    [self.myHeaderScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (EXEventButton *)createEventButton: (NSString *)withImage :(BNEvent*)andEvent {
    EXEventButton *newEventButton = [[EXEventButton alloc] initEventButton:withImage :andEvent];
    [newEventButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return newEventButton;
}

-(void)buttonPressed:(EXEventButton *) sender {
    [self performSegueWithIdentifier: @"DetailSegue" sender: sender];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(EXEventButton*)sender {
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"DetailSegue"])
    {
        // Get reference to the destination view controller
        DEViewController *vc = [segue destinationViewController];
        //vc.receivedEvent = sender.myEvent;
    }
}

@end