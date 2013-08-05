//
//  BNNearbyViewController.m
//  BusStop
//
//  Created by Lolcat on 8/3/13.
//  Copyright (c) 2013 0xC0ffee. All rights reserved.
//

#import "BNNearbyViewController.h"

@interface BNNearbyViewController () {
    NSDictionary *apiData;
    BusStopREST *bench;
    CLLocationManager *locationManager;
    CLLocation *location;
}

@property (nonatomic, retain) BusStopREST *bench;
@property (nonatomic, retain) NSDictionary *apiData;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *location;

@end

@implementation BNNearbyViewController

@synthesize apiData, bench, locationManager, location;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        bench = [[BusStopREST alloc] init];
        apiData = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startStandardUpdates];
    [BusStopHelpers drawCornersAroundView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location & API

- (void)startStandardUpdates
{
    NSLog(@"Starting standard updates");
    if (locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100;
    [locationManager startUpdatingLocation];
}

- (void)startSignificantChangeUpdates
{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;    
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)locationManager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    location = newLocation;
    NSLog(@"New location: %f %f", location.coordinate.longitude, location.coordinate.latitude);
    [self updateAPIData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManagerdidFailWithError: %@", error);
}

- (void)updateAPIData
{
    apiData = [bench stopsForLocationLat:[NSNumber numberWithFloat:location.coordinate.latitude]
                                     Lon:[NSNumber numberWithFloat:location.coordinate.longitude]];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [apiData[@"data"][@"list"] count];
}

-(NSDictionary *)dataForIndexPath:(NSIndexPath *)indexPath {
    return apiData[@"data"][@"list"][indexPath.row];
}

#pragma mark - Segues & Table view delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StopCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *stopData = [self dataForIndexPath:indexPath];
    NSArray *routesArray = apiData[@"data"][@"references"][@"routes"];
    
    UILabel *stopId = (UILabel *)[cell viewWithTag:1];
    stopId.text = stopData[@"code"];
    UILabel *stopName = (UILabel *)[cell viewWithTag:2];
    stopName.text = stopData[@"name"];
    UILabel *direction = (UILabel *)[cell viewWithTag:4];
    direction.text = stopData[@"direction"];
    UILabel *routes = (UILabel *)[cell viewWithTag:3];
    NSMutableString *routesText = [NSMutableString string];
    for (NSString *routeId in stopData[@"routeIds"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", routeId];
        NSArray *filtered = [routesArray filteredArrayUsingPredicate:predicate];
        [routesText appendFormat:@"%@ ", filtered[0][@"shortName"]];
    }
    routes.text = routesText;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"stopDetailSegue"]) {        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSDictionary *stopData = [self dataForIndexPath:path];
        BNArrivalDeparturesTableViewController *stopDetailsVC = segue.destinationViewController;
        stopDetailsVC.stopData = stopData;
    }
}

@end