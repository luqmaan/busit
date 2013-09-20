//
//  BNArrivalDeparturesTableViewController.m
//  BusStop
//
//  Created by Lolcat on 8/4/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BNArrivalsTableViewController.h"

@interface BNArrivalsTableViewController ()
    @property BDBusData *busData;
@end

@implementation BNArrivalsTableViewController {
    @private
        BOOL updateInProgress;
}

@synthesize busData, stop;

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"about to init arrivalsVC");
    if(self = [super initWithCoder:aDecoder]) {
        NSLog(@"did init arrivalsVC");
        updateInProgress = FALSE;
        busData = [[BDBusData alloc] init];
        NSLog(@"Did init busData");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateAPIData];
    NSLog(@"Did update apiData");
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (IBAction)dismissView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - API

- (IBAction)refresh:(id)sender {
    [self updateAPIData];
}

- (void)updateAPIData
{
    updateInProgress = FALSE;
    
    NSLog(@"about to fetch arrivals for stop");
    NSLog(@"stop: %@", stop);
    
    [stop fetchArrivalsAndPerformCallback:^{
        NSLog(@"Got the OBA data");
        [self.tableView reloadData];
    }];
    
    // Got the local GTFS data, can reload
    NSLog(@"Did fetch arrivals");
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSNumber *)rowCount {
    if (updateInProgress) return [NSNumber numberWithInt:0];
    return [NSNumber numberWithUnsignedInteger:[stop.arrivals count]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (updateInProgress) return 0;
    // if there are no arrivals, use 1 row to inform the user
    else if ([[self rowCount] intValue] == 0) return 1;
    else return [[self rowCount] intValue];
}

-(BDArrival *)dataForIndexPath:(NSIndexPath *)indexPath {
    return stop.arrivals[indexPath.row];
}

#pragma mark - Table view delegate


- (NSString *)distanceString:(float) meters
{
	if(meters > 1000.0) {
		float km = meters * 0.001;
		if(km > 5.0) {
			return [NSString stringWithFormat:NSLocalizedString(@"%0.0f km", nil), km];
		} else {
			return [NSString stringWithFormat:NSLocalizedString(@"%0.1f km", nil), km];
		}
	} else {
		return [NSString stringWithFormat:NSLocalizedString(@"%0.0f meters", nil), meters];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArrivalsDeparturesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // return the same cell if there is an udpate in progress
    // NSLog(@"updateInProgress? %@", updateInProgress ? @"YES" : @"NO");
    if (updateInProgress) return cell;
    
    UILabel *routeName = (UILabel *)[cell viewWithTag:1];
    UILabel *tripHeadsign = (UILabel *)[cell viewWithTag:2];
    UILabel *distance = (UILabel *)[cell viewWithTag:3];
    UILabel *scheduled =  (UILabel *)[cell viewWithTag:4];
    UILabel *predicted =  (UILabel *)[cell viewWithTag:5];
    UILabel *updated =  (UILabel *)[cell viewWithTag:6];
    UILabel *routeNumber = (UILabel *)[cell viewWithTag:7];

    if ([[self rowCount] intValue] == 0) {
        for (int i = 2; i <= 13; i++) {
            // hide all labels except routeName and tripHeadsign
            UIView *view = (UILabel *)[cell viewWithTag:i];
            if (view) [view setHidden:YES];
        }
        routeName.hidden = NO;
        tripHeadsign.hidden = NO;
        routeName.text = @"Sorry, there are no arrivals";
        tripHeadsign.text = @"for this stop.";
        return cell;
    }
    
    BDArrival *arrival = [self dataForIndexPath:indexPath];
    
    double hue = [BIHelpers hueForRoute:[arrival.routeId intValue]];
    UIColor *routeColor = [UIColor colorWithHue:hue saturation:1 brightness:0.7 alpha:1];
    UIColor *timeColor = [UIColor colorWithHue:hue saturation:1 brightness:0.5 alpha:1];
    routeNumber.textColor = routeColor;
    scheduled.textColor = timeColor;
    predicted.textColor = timeColor;
    updated.textColor = timeColor;
    
    routeNumber.text = arrival.routeId;
    routeName.text = arrival.routeId;
    tripHeadsign.text = arrival.tripHeadsign;
    
//    distance.text = [NSString stringWithFormat:@"%@mi    %@ stops away", [BIHelpers formattedDistanceFromStop:data[@"distanceFromStop"]], data[@"numberOfStopsAway"]];
    scheduled.text = arrival.scheduledArrivalTime;
//    predicted.text = [NSString stringWithFormat:@"%@", [BIHelpers timeWithTimestamp:data[@"predictedArrivalTime"]]];
//    updated.text = [NSString stringWithFormat:@"%@", [BIHelpers timeWithTimestamp:data[@"lastUpdateTime"]]];

    return cell;
}

@end
