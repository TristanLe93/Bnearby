//
//  DEViewController.m
//  Bnearby
//
//  Created by Lucas Michael Dilts on 16/09/13.
//  Copyright (c) 2013 Lucas Michael Dilts. All rights reserved.
//

#import "DEViewController.h"

@interface DEViewController ()
@end

@implementation DEViewController
@synthesize theEvent, eventBanner, eventDetails, myTableView, receivedEvent;


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    myTableView.dataSource = self;
    myTableView.delegate = self;
    
    //    theEvent = recievedButton.myEvent;
    theEvent = receivedEvent;
    
    //NSLog(@"Image %@", theEvent.bannerImage);
    
    eventBanner.image = [UIImage imageNamed:theEvent.bannerImage];
    //    eventBanner.image = [UIImage imageNamed:@"Planner_ExampleTile2.png"];
    
    
    eventDetails = [[NSMutableArray alloc] init];
    [eventDetails addObject:[NSString stringWithFormat:@"Event: %@", theEvent.name]];
    [eventDetails addObject:[NSString stringWithFormat:@"Location: %@", theEvent.location]];
    [eventDetails addObject:[NSString stringWithFormat:@"Time: %@", theEvent.time]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return eventDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"eventDetailsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [eventDetails objectAtIndex:indexPath.row];
    return cell;
}

@end

