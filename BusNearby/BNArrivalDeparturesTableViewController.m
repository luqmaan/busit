//
//  BNArrivalDeparturesTableViewController.m
//  BusStop
//
//  Created by Lolcat on 8/4/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BNArrivalDeparturesTableViewController.h"

@interface BNArrivalDeparturesTableViewController () {
        NSDictionary *apiData;
        BusStopREST *bench;
    }
    @property NSDictionary *apiData;
    @property BusStopREST *bench;
@end

@implementation BNArrivalDeparturesTableViewController {
    @private
        BOOL updateInProgress;
}

@synthesize apiData, bench, stopData;

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"init with coder");
    
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    bench = [[BusStopREST alloc] init];
    apiData = [[NSDictionary alloc] init];
    updateInProgress = FALSE;
    [self updateAPIData];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self.tableView reloadData];
    [BusStopHelpers drawCornersAroundView:self.view];
    self.tableView.layer.cornerRadius = 10;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.separatorColor = [UIColor clearColor];
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
    dispatch_release(fetchAPIData);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSLog(@"number of sections in tableview, update:%@", updateInProgress ? @"YES" : @"NO");
    if (updateInProgress) {
        NSLog(@"number of sections in table view, udpate in progress");
        return 1;
    }
    else
        return 2;
}
- (NSNumber *)rowCount {
    return [NSNumber numberWithUnsignedInteger:[apiData[@"data"][@"entry"][@"arrivalsAndDepartures"] count]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else {
        if (updateInProgress)
            return 0;
        if ([[self rowCount] intValue] == 0)
            return 1;
        return [[self rowCount] intValue];
    }
}

-(NSDictionary *)dataForIndexPath:(NSIndexPath *)indexPath {
    return apiData[@"data"][@"entry"][@"arrivalsAndDepartures"][indexPath.row];
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 240.0f;
    else
        return 125.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell for row at indexpath: %@", indexPath);
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"stopMapCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        UILabel *stopId = (UILabel *)[cell viewWithTag:1];
        UILabel *stopName = (UILabel *)[cell viewWithTag:2];

        if (updateInProgress) {
            stopId.text = @"Loading...";
            stopName.text = @"Please wait.";
            return cell;
        }
        
        stopId.text = [NSString stringWithFormat:@"%@ %@", stopData[@"code"], stopData[@"direction"]];
        stopName.text = stopData[@"name"];
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"arrivalsDeparturesCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
                
        UILabel *routeName = (UILabel *)[cell viewWithTag:1];
        UILabel *tripHeadsign = (UILabel *)[cell viewWithTag:2];
        UILabel *distance = (UILabel *)[cell viewWithTag:3];
        UILabel *scheduled =  (UILabel *)[cell viewWithTag:4];
        UILabel *predicted =  (UILabel *)[cell viewWithTag:5];
        UILabel *updated =  (UILabel *)[cell viewWithTag:6];
        
        if (updateInProgress) {
            return cell;
        }
        if ([[self rowCount] intValue] == 0) {
            routeName.text = @"Sorry, there are no arrivals for this stop.";
            return cell;
        }
        
        NSDictionary *data = [self dataForIndexPath:indexPath];
        routeName.text = [NSString stringWithFormat:@"%@ %@", data[@"routeShortName"], data[@"routeLongName"]];
        tripHeadsign.text = data[@"tripHeadsign"];
        
        int miles = [(NSNumber *)data[@"distanceFromStop"] intValue] / 500;
        distance.text = [NSString stringWithFormat:@"%dmi / %@ stops away", miles, data[@"numberOfStopsAway"]];
        scheduled.text = [NSString stringWithFormat:@"%@", [BusStopHelpers timeWithTimestamp:data[@"scheduledArrivalTime"]]];
        predicted.text = [NSString stringWithFormat:@"%@", [BusStopHelpers timeWithTimestamp:data[@"predictedArrivalTime"]]];
        updated.text = [NSString stringWithFormat:@"%@", [BusStopHelpers timeWithTimestamp:data[@"lastUpdateTime"]]];
    
        return cell;
    }
}

@end
