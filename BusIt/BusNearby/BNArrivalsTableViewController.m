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
}

@synthesize busData, stop;

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"about to init arrivalsVC");
    if(self = [super initWithCoder:aDecoder]) {
        NSLog(@"did init arrivalsVC");
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
    return [stop.arrivals count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[stop.arrivals objectForKey:stop.arrivalKeys[section]] count];
}

-(BDArrival *)dataForIndexPath:(NSIndexPath *)indexPath {
    return [stop.arrivals objectForKey:stop.arrivalKeys[indexPath.section]][indexPath.row];
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

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"TripHeadsignCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    UILabel *routeNumber = (UILabel *)[cell viewWithTag:1];
    UILabel *tripHeadsign = (UILabel *)[cell viewWithTag:2];
    NSMutableArray *arrivalGroup = [stop.arrivals objectForKey:[stop.arrivalKeys objectAtIndex:section]];
    
    BDArrival *arrival = arrivalGroup[0];
    
    
    double hue = [BIHelpers hueForRoute:[arrival.routeId intValue]];
    UIColor *routeColor = [UIColor colorWithHue:hue saturation:1 brightness:0.7 alpha:0.9];
    cell.backgroundColor = routeColor;
//    routeNumber.textColor = routeColor;
    
    
    routeNumber.text = arrival.routeId;
    tripHeadsign.text = arrival.tripHeadsign;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BDArrival *arrival = [self dataForIndexPath:indexPath];
    UITableViewCell *cell;
    static NSString *CellIdentifier;
    NSDateFormatter *DateFormatter= [[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"hh:mm"];
    
    // return the same cell if there is an udpate in progress
    NSLog(@"heyyyyy %@ %@", arrival.identifier, arrival.vehicleId);
    
    if (arrival.hasObaData == NO) {
        CellIdentifier = @"ScheduledArrivalCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UILabel *scheduled =  (UILabel *)[cell viewWithTag:1];
        scheduled.text = [DateFormatter stringFromDate:arrival.scheduledArrivalTime];
        NSLog(@"date: %@", arrival.scheduledArrivalTime);
    }
    else {
        CellIdentifier = @"RealtimeArrivalCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSLog(@"AHAHAHAHAA");
    }
//    predicted.text = arrival.predictedTime;
//    distance.text = [NSString stringWithFormat:@"%@mi    %@ stops away", [BIHelpers formattedDistanceFromStop:data[@"distanceFromStop"]], data[@"numberOfStopsAway"]];
//    predicted.text = [NSString stringWithFormat:@"%@", [BIHelpers timeWithTimestamp:data[@"predictedArrivalTime"]]];
//    updated.text = [NSString stringWithFormat:@"%@", [BIHelpers timeWithTimestamp:data[@"lastUpdateTime"]]];

    return cell;
}

@end
