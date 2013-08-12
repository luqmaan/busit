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
    BOOL updateInProgress;
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
    updateInProgress = FALSE;
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"init w style");
    self = [super initWithStyle:style];
    if (self) {
        bench = [[BusStopREST alloc] init];
        apiData = [[NSDictionary alloc] init];
        updateInProgress = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self updateAPIData];
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

- (void)updateAPIData
{
    if (updateInProgress) {
        NSLog(@"Attempted to run a new update while update is in progress.");
        return;
    }
    dispatch_queue_t fetchAPIData = dispatch_queue_create("com.busit.arrival", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(fetchAPIData, ^{
        updateInProgress = TRUE;
        apiData = [bench arrivalsAndDeparturesForStop:stopData[@"id"]];
        updateInProgress = FALSE;
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self.tableView reloadData];            
        });
    });
    dispatch_release(fetchAPIData);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (updateInProgress)
        return 0;
    return 2;
}
- (NSNumber *)rowCount {
    return [NSNumber numberWithUnsignedInteger:[apiData[@"data"][@"entry"][@"arrivalsAndDepartures"] count]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (updateInProgress)
        return 0;
    if (section == 0)
        return 1;
    else {
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
        return 155.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"stopMapCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (updateInProgress) {
            return cell;
        }

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
        if (updateInProgress) {
            return cell;
        }
                
        NSDictionary *data = [self dataForIndexPath:indexPath];
        
        UILabel *routeName = (UILabel *)[cell viewWithTag:1];
        if ([[self rowCount] intValue] == 0) {
            routeName.text = @"Sorry, there are no arrivals for this stop.";
            return cell;
        }
        
        routeName.text = [NSString stringWithFormat:@"%@ %@", data[@"routeShortName"], data[@"routeLongName"]];
        UILabel *tripHeadsign = (UILabel *)[cell viewWithTag:2];
        tripHeadsign.text = data[@"tripHeadsign"];
        
        int miles = [(NSNumber *)data[@"distanceFromStop"] intValue] / 500;
        UILabel *distance = (UILabel *)[cell viewWithTag:3];
        distance.text = [NSString stringWithFormat:@"%dmi / %@ stops away", miles, data[@"numberOfStopsAway"]];
        
        UILabel *scheduled =  (UILabel *)[cell viewWithTag:4];
        scheduled.text = [NSString stringWithFormat:@"%@", [self timeWithTimestamp:data[@"scheduledArrivalTime"]]];
        UILabel *predicted =  (UILabel *)[cell viewWithTag:5];
        predicted.text = [NSString stringWithFormat:@"%@", [self timeWithTimestamp:data[@"predictedArrivalTime"]]];
        UILabel *updated =  (UILabel *)[cell viewWithTag:6];
        updated.text = [NSString stringWithFormat:@"%@", [self timeWithTimestamp:data[@"lastUpdateTime"]]];
    
        return cell;
    }
}

-(NSString *)timeWithTimestamp:(NSString *)timeStampString {
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter;
    NSString *dateString;
    formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"EST"];
    formatter.DateFormat = @"hh:mm";
    dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
