//
//  DESelectedEventViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 27/10/2013.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "DESelectedEventViewController.h"

@interface DESelectedEventViewController ()

@end

@implementation DESelectedEventViewController
@synthesize myDatePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSDate *now = [NSDate date];
    [myDatePicker setDate:now animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectButtonPressed:(id)sender {
    NSDate *selected = [myDatePicker date];
    NSString *message = [[NSString alloc] initWithFormat:@"The date and Time selected is %@", selected];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Date and Time Selected" message:message delegate:Nil cancelButtonTitle:@"done" otherButtonTitles:nil];
    [alert show];
}
@end
