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

@implementation BNArrivalDeparturesTableViewController

@synthesize apiData, bench, stopData;

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"init with coder");
    
    if ( !(self = [super initWithCoder:aDecoder]) ) return nil;
    
    bench = [[BusStopREST alloc] init];
    apiData = [[NSDictionary alloc] init];
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"init w style");
    self = [super initWithStyle:style];
    if (self) {
        bench = [[BusStopREST alloc] init];
        apiData = [[NSDictionary alloc] init];
        [self updateAPIData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateAPIData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void)updateAPIData
{
    apiData = [bench arrivalsAndDeparturesForStop:stopData[@"id"]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else
        return [apiData[@"data"][@"entry"][@"arrivalsAndDepartures"] count];
}

-(NSDictionary *)dataForIndexPath:(NSIndexPath *)indexPath {
    return apiData[@"data"][@"entry"][@"arrivalsAndDepartures"][indexPath.row];
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 150.0f;
    else
        return 135.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", indexPath);
    if (indexPath.section == 0) {
        
        static NSString *CellIdentifier = @"stopMapCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        NSLog(@"stopData: %@", stopData);
        
        UILabel *stopId = (UILabel *)[cell viewWithTag:1];
        stopId.text = [NSString stringWithFormat:@"%@ %@", stopData[@"code"], stopData[@"direction"]];
        UILabel *stopName = (UILabel *)[cell viewWithTag:2];
        stopName.text = stopData[@"name"];
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"arrivalsDeparturesCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        NSDictionary *data = [self dataForIndexPath:indexPath];
        
        UILabel *routeName = (UILabel *)[cell viewWithTag:1];
        routeName.text = [NSString stringWithFormat:@"%@ %@", data[@"routeShortName"], data[@"routeLongName"]];
        UILabel *tripHeadsign = (UILabel *)[cell viewWithTag:2];
        tripHeadsign.text = data[@"tripHeadsign"];
        #pragma mark - TODO: add proper calculation for distance in miles
        int miles = [(NSNumber *)data[@"distanceFromStop"] intValue] / 500;
        UILabel *distance = (UILabel *)[cell viewWithTag:3];
        distance.text = [NSString stringWithFormat:@"%dmi %@ stops away", miles, data[@"numberOfStopsAway"]];
        UILabel *scheduled =  (UILabel *)[cell viewWithTag:4];
        scheduled.text = [NSString stringWithFormat:@"Scheduled: %@", data[@"scheduledArrivalTime"]];
        UILabel *predicted =  (UILabel *)[cell viewWithTag:5];
        predicted.text = [NSString stringWithFormat:@"Predicted: %@", data[@"predictedArrivalTime"]];
        UILabel *updated =  (UILabel *)[cell viewWithTag:6];
        updated.text = [NSString stringWithFormat:@"Updated: %@", data[@"lastUpdateTime"]];
    
        return cell;
    }
}
@end
