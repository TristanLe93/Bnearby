//
//  DESelectedEventViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 27/10/2013.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "DESelectedEventViewController.h"
#import "BnearbyAppDelegate.h"
#import "BNEvent.h"

@interface DESelectedEventViewController ()
@property (nonatomic, strong) EKEventStore *eventStore;
@property BOOL eventStoreAccessGranted;
@property (assign, nonatomic) BOOL alertType;
//@property (assign, nonatomic) BOOL beReminded;
//@property (assign, nonatomic) BOOL doneConfig;
@end

@implementation DESelectedEventViewController
@synthesize myDatePicker, theVenue;
@synthesize type;
@synthesize event;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
//    
//    [self.view addSubview:backgroundImage];
//    [self.view sendSubviewToBack:backgroundImage];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.alertType = YES;
//    self.beReminded = NO;
//    self.doneConfig = NO;
    
    BnearbyAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    context = delegate.managedObjectContext;
    
    // Reminders setup
    self.eventStore = [[EKEventStore alloc] init];
	self.eventStoreAccessGranted = NO;
	[self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL success, NSError *error)
     {
         self.eventStoreAccessGranted = success;
         
         if(!success)
             NSLog(@"User has not granted access to add reminders.");
     }];
    
    // Date picker setup
    NSDate *now = [NSDate date];
    [myDatePicker setDate:now animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// saves data
- (IBAction)selectButtonPressed:(id)sender {
    NSDate *date = [myDatePicker date];
    switch ([type integerValue]) {
        case 1:
            if (event.date == nil) {
                event.date = date;
                
                NSError *error;
                NSString *message;
                if (![context save:&error]) {
                    message = @"Error: Not able to modify date";
                } else {
                    message = @"The Date has been modified";
                    self.event = event;
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Venue" message:message delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Remind Me", nil];
                [alert show];
            }
            else {
                event.date = date;
                
                NSError *error;
                NSString *message;
                if (![context save:&error]) {
                    message = @"Error: Not able to modify date";
                } else {
                    message = @"The Date has been modified";
                    self.event = event;
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Venue" message:message delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Remind Me", nil];
                [alert show];
            }
            break;
        case 2:{
            NSDictionary *location = [theVenue objectForKey:@"location"];
            NSDictionary *contact = [theVenue objectForKey:@"contact"];
            
            BNEvent *thisEvent = [NSEntityDescription insertNewObjectForEntityForName:@"BNEvent" inManagedObjectContext:context];
            
            //set data
            thisEvent.title = [theVenue objectForKey:@"name"];
            thisEvent.address = [self addressBuilder:location];
            thisEvent.date = [myDatePicker date];
            thisEvent.phonenumber = [contact objectForKey:@"formattedPhone"];
            thisEvent.latitude = [location objectForKey:@"lat"];
            thisEvent.longitude = [location objectForKey:@"lng"];
//            NSLog(@"lat %@ lng %@", event.latitude, event.longitude);
            self.event = thisEvent;
            
            NSError *error;
            NSString *message;
            if (![context save:&error]) {
                message = @"Error: Venue was not able to save";
            } else {
                message = @"The venue was saved to Planner";
                self.event = event;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save Venue" message:message delegate:self cancelButtonTitle:@"Done" otherButtonTitles:@"Remind Me", nil];
            [alert show];
            
            break;}
        default:
            NSLog(@"ERROR");
            break;
    }
    

}

- (NSMutableString *)addressBuilder:(NSDictionary *)location {
    NSMutableString *address = [[NSMutableString alloc] init];
    
    [address appendString:[location objectForKey:@"address"]];
    [address appendString:@", "];
    [address appendString:[location objectForKey:@"city"]];
    [address appendString:@" "];
    [address appendString:[location objectForKey:@"state"]];
    [address appendString:@" "];
    if ([location objectForKey:@"postalCode"] != nil) {
        [address appendString:[location objectForKey:@"postalCode"]];
        [address appendString:@" "];
    }
    [address appendString:[location objectForKey:@"country"]];
    
    return address;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.alertType) {
        if (buttonIndex != [alertView cancelButtonIndex]){
            self.alertType = NO;
            [self addReminder];
        }
    }
    else {
        if (buttonIndex != [alertView cancelButtonIndex]){
//            self.beReminded = YES;
            [self addAReminderWithAlarm];
//            [NSTimer scheduledTimerWithTimeInterval:5.0 invocation:nil repeats:NO];
//            [self doneAndExit];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.alertType) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            [self doneAndExit];
        }
    }
    else {
        if (buttonIndex == [alertView cancelButtonIndex]){
            [self addReminderWithoutAlarm];
            [self doneAndExit];
        }
    }
}

- (void)addReminder {
    if(!self.eventStoreAccessGranted) {
		return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:@"Would you like to set an alarm for this reminder?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"1 Hour before", nil];
    [alert show];
}

- (void)doneAndExit {
//    [self performSegueWithIdentifier:@"cancelSegue" sender:self];
    [self dismissViewControllerAnimated:YES completion:nil];
//    NSLog(@"EXITING");
}


- (void)addReminderWithoutAlarm {
    if(!self.eventStoreAccessGranted)
		return;
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:self.event.date];
    
    EKReminder *newReminder = [EKReminder reminderWithEventStore:self.eventStore];
    newReminder.title = [NSString stringWithFormat:@"%@", self.event.title];
    newReminder.dueDateComponents = comps;
    newReminder.calendar = [_eventStore defaultCalendarForNewReminders];
    NSError *error = nil;
    [self.eventStore saveReminder:newReminder
                           commit:YES
                            error:&error];
    

}


- (void)addAReminderWithAlarm {
    if(!self.eventStoreAccessGranted)
		return;
    if (self.event.date != Nil) {
        NSDate *alarmDate = [self.event.date dateByAddingTimeInterval:-3600];
        EKAlarm *ourAlarm = [EKAlarm alarmWithAbsoluteDate:alarmDate];
        EKReminder *newReminder = [EKReminder reminderWithEventStore:self.eventStore];
        
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        
        NSCalendar * cal = [NSCalendar currentCalendar];
        NSDateComponents *comps = [cal components:unitFlags fromDate:self.event.date];
        
        newReminder.title = [NSString stringWithFormat:@"%@", self.event.title];
        newReminder.dueDateComponents = comps;
        newReminder.calendar = [_eventStore defaultCalendarForNewReminders];
        
        [newReminder addAlarm:ourAlarm];
        
        NSError *error = nil;
        
        [self.eventStore saveReminder:newReminder
                               commit:YES
                                error:&error];

    }
    else {
//        NSLog(@"Ooops");
    }
}
@end
