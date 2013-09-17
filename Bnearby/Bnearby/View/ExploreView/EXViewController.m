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
//#import "MTEventButton.h"
#import "DEViewController.h"
#import "EXEventButton.h"

@interface EXViewController ()
@property (weak, nonatomic) IBOutlet EXTableView *myTableView;
@property (weak, nonatomic) IBOutlet HDScrollView *myHeaderScroller;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
//@property (weak, nonatomic) IBOutlet MTEvButton *myEventsButton;


@end

@implementation EXViewController

@synthesize menuBtn;

static NSString *CellIdentifier = @"CellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.myHeaderScroller setContentSize:(CGSizeMake(960, 44))];
    [self.myHeaderScroller setScrollEnabled:YES];
    [self.myHeaderScroller setPagingEnabled:YES];
    
    // Sliding Menu
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    //    self.menuBtn = [[NavBarMenuButton alloc] initButton];
    [self.myButton addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor colorWithRed:140/255.0f green:255/255.0f blue:241/255.0f alpha:1.0f];
    [self.tableView setBackgroundView:bview];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure Cell
    [cell.myScrollView setContentSize:(CGSizeMake(640, 168))];
    [cell.myScrollView setScrollEnabled:YES];
    [cell.myScrollView setPagingEnabled:YES];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Loading_Variation_One.png"]];
    
    
    
    BNEvent *event = [[BNEvent alloc] initWithName:@"Queensland Art Gallery" AndTime:@"8am to 5pm" AndLocation:@"Location" AndBanner:@"Planner_ExampleTile2.png"];
    
    BNEvent *event2 = [[BNEvent alloc] initWithName:@"Beastie Burgers" AndTime:@"8am to 5pm" AndLocation:@"Location" AndBanner:@"Planner_ExampleTile1.png"];
    
    
    switch (indexPath.row) {
        case 0:
            [cell.myScrollView.myView.myImage initWithImage: [UIImage imageNamed: @"Explore_Entertainment.png"]];
            [cell.myScrollView.myView addSubview:[self createEventButton:@"Art_Gallery_Explore.png" :event]];
            break;
        case 1:
            [cell.myScrollView.myView.myImage initWithImage: [UIImage imageNamed: @"Explore_Resturants.png"]];
            [cell.myScrollView.myView addSubview:[self createEventButton:@"Beastie_Burgers_Explore.png" :event2]];
            break;
        case 2:
            [cell.myScrollView.myView.myImage initWithImage: [UIImage imageNamed:@"Explore_FreeFun.png"]];
            break;
        case 3:
            [cell.myScrollView.myView.myImage initWithImage: [UIImage imageNamed: @"Explore_Kids.png"]];
            break;
            
        default:
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
        
        // Pass any objects to the view controller here, like...
        //        MTEvent *sendEvent = sender.myEvent;
        //        [vc setTheEvent:sendEvent];
        vc.receivedEvent = sender.myEvent;
        //vc.recievedButton = sender;
    }
}

@end