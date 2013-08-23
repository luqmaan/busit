//
//  BNArrivalDeparturesTableViewController.m
//  BusStop
//
//  Created by Lolcat on 8/4/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BNArrivalsTableViewController.h"

@interface BNArrivalsTableViewController () {
        NSDictionary *apiData;
        BIRest *bench;
    }
    @property NSDictionary *apiData;
    @property BIRest *bench;
@end

@implementation BNArrivalsTableViewController {
    @private
        BOOL updateInProgress;
}

@synthesize apiData, bench, stopData;

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"init with coder");
    
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    bench = [[BIRest alloc] init];
    apiData = [[NSDictionary alloc] init];
    updateInProgress = FALSE;
    [self updateAPIData];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
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
    if (updateInProgress) {
        NSLog(@"Attempted to run a new update while update is in progress.");
        return;
    }
    dispatch_queue_t fetchAPIData = dispatch_queue_create("com.busit.arrival", DISPATCH_QUEUE_SERIAL);
    updateInProgress = TRUE;
    
    dispatch_async(fetchAPIData, ^{
        apiData = [bench arrivalsAndDeparturesForStop:stopData[@"id"]];
        dispatch_async(dispatch_get_main_queue(), ^ {
            updateInProgress = FALSE;
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Map View

- (void)setupMapView
{
    /*
    UILabel *stopId = (UILabel *)[cell viewWithTag:1];
    UILabel *stopName = (UILabel *)[cell viewWithTag:2];
    
    if (updateInProgress) {
        stopId.text = @"Loading...";
        stopName.text = @"Please wait.";
        return cell;
    }
    
    stopId.text = [NSString stringWithFormat:@"%@ %@", stopData[@"code"], stopData[@"direction"]];
    stopName.text = stopData[@"name"];
    */
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSNumber *)rowCount {
    if (updateInProgress) return [NSNumber numberWithInt:0];
    return [NSNumber numberWithUnsignedInteger:[apiData[@"data"][@"entry"][@"arrivalsAndDepartures"] count]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (updateInProgress) return 0;
    // if there are no arrivals, use 1 row to inform the user
    else if ([[self rowCount] intValue] == 0) return 1;
    else return [[self rowCount] intValue];
}

-(NSDictionary *)dataForIndexPath:(NSIndexPath *)indexPath {
    return apiData[@"data"][@"entry"][@"arrivalsAndDepartures"][indexPath.row];
}

#pragma mark - Table view delegate

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
    

    if ([[self rowCount] intValue] == 0) {
        routeName.text = @"Sorry, there are no arrivals for this stop.";
        return cell;
    }
    
    NSDictionary *data = [self dataForIndexPath:indexPath];
    routeName.text = [NSString stringWithFormat:@"%@ %@", data[@"routeShortName"], data[@"routeLongName"]];
    tripHeadsign.text = data[@"tripHeadsign"];
    
    int miles = [(NSNumber *)data[@"distanceFromStop"] intValue] / 500;
    distance.text = [NSString stringWithFormat:@"%dmi / %@ stops away", miles, data[@"numberOfStopsAway"]];
    scheduled.text = [NSString stringWithFormat:@"%@", [BIHelpers timeWithTimestamp:data[@"scheduledArrivalTime"]]];
    predicted.text = [NSString stringWithFormat:@"%@", [BIHelpers timeWithTimestamp:data[@"predictedArrivalTime"]]];
    updated.text = [NSString stringWithFormat:@"%@", [BIHelpers timeWithTimestamp:data[@"lastUpdateTime"]]];

    return cell;
}

@end
