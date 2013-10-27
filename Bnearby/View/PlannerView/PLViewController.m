//
//  PLViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "PLViewController.h"
#import "DEViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "BnearbyAppDelegate.h"
#import "BNEvent.h"

@interface PLViewController ()

@property (strong, nonatomic) NSMutableArray *allEvents;
@property (strong, nonatomic) NSMutableArray *selectedEvents;
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;
//@property (assign, nonatomic) int test;


@end

@implementation PLViewController

@synthesize allEvents;
@synthesize selectedEvents;
@synthesize sections;
@synthesize sortedDays;
@synthesize sectionDateFormatter;
@synthesize cellDateFormatter;

int testtt = 0;

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
    
    // Put fetchedResuts into an array
    [self eventsToArray];
    
    // Begin organising events
    NSDate *now = [NSDate date];
    NSDate *startDate = [self dateAtBeginningOfDayForDate:now];
    NSDate *endDate = [self dateByAddingYears:1 toDate:startDate];
    
    self.selectedEvents = [[NSMutableArray alloc] init];
    for (BNEvent* event in self.allEvents) {
        if ([self date:event.date isBetweenDate:startDate andDate:endDate]) {
            [self.selectedEvents addObject:event];
        }
    }
    
    self.sections = [NSMutableDictionary dictionary];
    for (BNEvent *event in selectedEvents) {
        // Reduce event start date to date components (year, month, day)
        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:event.date];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            // Use the reduced date as dictionary key to later retrieve the event list this day
            [self.sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
        }
        
        // Add the event to the list for this day
        [eventsOnThisDay addObject:event];
    }
    
    // Create a sorted list of days
    NSArray *unsortedDays = [self.sections allKeys];
    self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
    
    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
    [self.sectionDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // side menu setup
    [self.menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

// number of rows in each section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    return [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        // Remove date from plan
        NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
        NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        BNEvent *event = [eventsOnThisDay objectAtIndex:indexPath.row];
//        NSLog(@"Event being deleted name: %@", event.title);
        event.date = nil;

//        NSLog(@"Sections before: %d", [sections count]);
//        NSLog(@"Number of events in one day before: %d", [eventsOnThisDay count]);
        
        if (eventsOnThisDay.count == 1) {

            NSMutableArray *newSortedDates = [[NSMutableArray alloc] initWithArray:sortedDays];
//            NSLog(@"Number of new sorted days: %d", newSortedDates.count);
            [newSortedDates removeObject:dateRepresentingThisDay];
//            NSLog(@"Number of new sorted days after removed: %d", newSortedDates.count);
            sortedDays = [[NSArray alloc] initWithArray:newSortedDates];
//            NSLog(@"Number of sorted days after: %d", sortedDays.count);
           

//            NSLog(@"Method call %d", [self numberOfSectionsInTableView:self.tableView]);
            [self.sections removeObjectForKey:dateRepresentingThisDay];
//            NSLog(@"Sections after removed: %d", [sections count]);
//            NSLog(@"Method call %d", [self numberOfSectionsInTableView:self.tableView]);
            
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
        }
        else {
            NSMutableArray *newEventsOnThisDay = [eventsOnThisDay mutableCopy];
//            NSLog(@"Number of events in newEvents: %d", [newEventsOnThisDay count]);
            [newEventsOnThisDay removeObject:event];
//            NSLog(@"Number of events in newEvents after event removed: %d", [newEventsOnThisDay count]);
            [self.sections removeObjectForKey:dateRepresentingThisDay];
//            NSLog(@"Sections after removed: %d", [sections count]);
            [self.sections setObject:newEventsOnThisDay forKey:dateRepresentingThisDay];
//            NSLog(@"Sections after added: %d", [sections count]);
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        
//        NSDate *test1 = [self.sortedDays objectAtIndex:indexPath.section];
//        NSArray *test2 = [self.sections objectForKey:test1];
        
//        NSLog(@"Number of events in one day after all: %d", [test2 count]);
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        [self.tableView reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PlannedEventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    BNEvent *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
//    if (event != nil) {
//        NSLog(@"Test");
        // set event title
        UILabel *eventTitle = (UILabel *)[cell viewWithTag:101];
        eventTitle.text = event.title;
        
        // set event address
        UILabel *eventAddress = (UILabel *)[cell viewWithTag:102];
        eventAddress.text = event.address;
        eventAddress.adjustsFontSizeToFitWidth = YES;
        
        // set image according to its event type
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
        UIImage *image;
        
        if ([event.type isEqualToString:@"Hotel"]) {
            image = [UIImage imageNamed:@"Shopping Icons.png"];
        }
        else if ([event.type isEqualToString:@"Restaurant"]) {
            image = [UIImage imageNamed:@"Food Icons.png"];
        }
        else if ([event.type isEqualToString:@"Attraction"]) {
            image = [UIImage imageNamed:@"Entertainment Icons.png"];
        }
        imageView.image = image;
//    }
    

    
    return cell;
}


- (void)eventsToArray {
    self.allEvents = [[NSMutableArray alloc] init];
    for (int i = 0; i < [fetchedResultsController.fetchedObjects count]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        BNEvent *event = [fetchedResultsController objectAtIndexPath:indexPath];
        if (i == 0 && testtt == 0) {
            event.date = [NSDate date];
            testtt = 0;
        }
        if (i == 1 && testtt == 0) {
            event.date = [NSDate date];
            testtt = 0;
        }
        if (i == 2 && testtt == 0) {
            event.date = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
            testtt = 0;
        }
        if (i == 3 && testtt == 0) {
            event.date = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
            testtt = 1;
        }
        if (event.date != Nil) {
            [self.allEvents addObject:event];
        }
    }
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

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate {
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate {
    // Use the user's current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:numberOfYears];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    return newDate;
}
//
//- (void)doThis {
//    // Begin organising events
//    NSDate *now = [NSDate date];
//    NSDate *startDate = [self dateAtBeginningOfDayForDate:now];
//    NSDate *endDate = [self dateByAddingYears:1 toDate:startDate];
//    
//    self.selectedEvents = [[NSMutableArray alloc] init];
//    for (BNEvent* event in self.allEvents) {
//        if ([self date:event.date isBetweenDate:startDate andDate:endDate]) {
//            [self.selectedEvents addObject:event];
//        }
//    }
//    
//    self.sections = [NSMutableDictionary dictionary];
//    for (BNEvent *event in selectedEvents) {
//        // Reduce event start date to date components (year, month, day)
//        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:event.date];
//        
//        // If we don't yet have an array to hold the events for this day, create one
//        NSMutableArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
//        if (eventsOnThisDay == nil) {
//            eventsOnThisDay = [NSMutableArray array];
//            
//            // Use the reduced date as dictionary key to later retrieve the event list this day
//            [self.sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
//        }
//        
//        // Add the event to the list for this day
//        [eventsOnThisDay addObject:event];
//    }
//    
//    // Create a sorted list of days
//    NSArray *unsortedDays = [self.sections allKeys];
//    self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
//    
//    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
//    [self.sectionDateFormatter setDateStyle:NSDateFormatterLongStyle];
//    [self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
//    
//    self.cellDateFormatter = [[NSDateFormatter alloc] init];
//    [self.cellDateFormatter setDateStyle:NSDateFormatterNoStyle];
//    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
//}

// transfers event object to the destination VC
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DEViewController *destVC = segue.destinationViewController;
        
        //destVC.theEvent = [fetchedResultsController objectAtIndexPath:indexPath];
    }
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end